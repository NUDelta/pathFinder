//
//  PathFinderViewController.m
//  pathFinder Core Demo
//
//  Created by Delta Lab on 4/8/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import "PathFinderViewController.h"

@interface PathFinderViewController ()
- (IBAction)getLocation:(id)sender;
- (IBAction)stopTracking:(id)sender;
- (IBAction)showRoute:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIButton *startLocation;
@property (weak, nonatomic) IBOutlet UIButton* stoplocation;
@property (weak, nonatomic) IBOutlet UILabel *trackLocation;
@property (weak, nonatomic) IBOutlet UIButton *stopTracking;
@property (weak, nonatomic) IBOutlet UILabel *timePath;
@property (weak, nonatomic) IBOutlet UILabel *timeOfPath;
@property (weak, nonatomic) IBOutlet UILabel *EnterName;
@property (strong, nonatomic) GMSMutablePath *testPath;
@property (nonatomic) NSTimeInterval timeStart;
@property (weak, nonatomic) IBOutlet UILabel *lengthPath;
@property (weak, nonatomic) IBOutlet UILabel *forLength;
@property (weak, nonatomic) IBOutlet UILabel *forLength2;
@property (nonatomic) PFObject* parsePath;
@property (weak, nonatomic) IBOutlet UILabel *welcome;
@property (weak, nonatomic) IBOutlet UILabel *previous;
@property (weak, nonatomic) IBOutlet UILabel *other;
@property (weak, nonatomic) IBOutlet UILabel *down1;
@property (weak, nonatomic) IBOutlet UILabel *down2;
@property NSString* name;
@end



@implementation PathFinderViewController
CLLocationManager *locationManager;


- (GMSMutablePath *)testPath
{
    if(!_testPath) _testPath = [[GMSMutablePath alloc] init];
    return _testPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *nameItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete Name" style:UIBarButtonItemStylePlain target:self action:@selector(deleteName)];
    
    NSArray *actionButtonItems = @[nameItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    
    NSString *filePath = [docDirectory stringByAppendingString:@"/Name.txt"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (!fileContents) {
        [self.startLocation setHidden:TRUE];
        [self.nameField setHidden:FALSE];
        [self.EnterName setHidden:FALSE];
        [self.welcome setHidden:TRUE];
        [self.previous setHidden:TRUE];
        [self.other setHidden:TRUE];
        [self.down1 setHidden:TRUE];
        [self.down2 setHidden:TRUE];
    }
    else {
        self.name = fileContents;
        [self.nameField setHidden:TRUE];
        [self.EnterName setHidden:TRUE];
        [self.startLocation setHidden:FALSE];
        
    }
    
    
    [self.stoplocation setHidden:TRUE];
    [self.trackLocation setHidden:TRUE];
    [self.stopTracking setHidden:TRUE];
    [self.timePath setHidden:TRUE];
    [self.timeOfPath setHidden:TRUE];
    [self.lengthPath setHidden:TRUE];
    [self.forLength setHidden:TRUE];
    
    locationManager = [[CLLocationManager alloc] init];
    
    self.parsePath = [[PFObject alloc] initWithClassName:@"ParsePath"];
    
    self.nameField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.stopTracking setHidden:FALSE];
    [self.nameField setHidden:TRUE];
    [self.EnterName setHidden:TRUE];
    [self.startLocation setHidden:TRUE];
    [self.trackLocation setHidden:FALSE];
    [self.welcome setHidden:TRUE];
    [self.previous setHidden:TRUE];
    [self.other setHidden:TRUE];
    [self.down1 setHidden:TRUE];
    [self.down2 setHidden:TRUE];
    
    self.timeStart = [[NSDate date] timeIntervalSince1970];
    
    [locationManager startUpdatingLocation];
}

- (IBAction)stopTracking:(id)sender {
    [locationManager stopUpdatingLocation];
    
    [self.stopTracking setHidden:TRUE];
    [self.trackLocation setHidden:TRUE];
    [self.timeOfPath setHidden:FALSE];
    [self.timePath setHidden:FALSE];
    [self.stoplocation setHidden:FALSE];
    [self.lengthPath setHidden:FALSE];
    [self.forLength setHidden:FALSE];
    [self.welcome setHidden:TRUE];
    [self.previous setHidden:TRUE];
    [self.other setHidden:TRUE];
    [self.down1 setHidden:TRUE];
    [self.down2 setHidden:TRUE];
    
    NSDate *timeSince = [[NSDate alloc] initWithTimeIntervalSince1970:self.timeStart];
    
    NSTimeInterval timeOfPath = -1 * [timeSince timeIntervalSinceNow];
    
    if (timeOfPath < 60) {
        self.timeOfPath.text = [NSString stringWithFormat:@"%.0f s", timeOfPath];
    }
    else {
        NSTimeInterval timeInSec = fmod(timeOfPath, 60.0);
        
        NSTimeInterval timeInMin = (timeOfPath - timeInSec)/60;
    
        self.timeOfPath.text = [NSString stringWithFormat:@"%.0f min  %.0f s", timeInMin, timeInSec];
    }
    
    CLLocationDistance length2 = [self.testPath lengthOfKind:kGMSLengthRhumb];
    
    if (length2 < 1000) {
        self.forLength.text = [NSString stringWithFormat:@"%.2f meters", length2];
    }
    else {
        length2 = length2/1000;
        self.forLength.text = [NSString stringWithFormat:@"%.2f km", length2];
    }
}

- (IBAction)showRoute:(id)sender {
   
    [self.testPath removeAllCoordinates];
    
    [self viewDidLoad];
    
    /*[self.stoplocation setHidden:TRUE];
    [self.trackLocation setHidden:TRUE];
    [self.stopTracking setHidden:TRUE];
    [self.timePath setHidden:TRUE];
    [self.timeOfPath setHidden:TRUE];
    [self.lengthPath setHidden:TRUE];
    [self.forLength setHidden:TRUE];
    [self.nameField setHidden:FALSE];
    [self.EnterName setHidden:FALSE];*/
    
    
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    

    
    if (currentLocation != nil && currentLocation.horizontalAccuracy < 75) {
        
        int latHolder = (int)(currentLocation.coordinate.latitude * 10000);
        
        int longHolder = (int)(currentLocation.coordinate.longitude * 10000);
        
        if (longHolder == -876762 && latHolder == 420577) {
            [self.stopTracking sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [self.testPath addCoordinate:currentLocation.coordinate];
        [self.parsePath addObject:@(currentLocation.coordinate.latitude) forKey:@"latitude"];
        [self.parsePath addObject:@(currentLocation.coordinate.longitude) forKey:@"longitude"];
        [self.parsePath addObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"timeStamps"];
        self.parsePath[@"Name"] = self.name;
        [self.parsePath saveInBackground];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RouteToMap"]) {
        PathFinderMapViewController *control = [segue destinationViewController];
        
        control.route = [[GMSMutablePath alloc] initWithPath:self.testPath];

    }
}

- (void)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.name = textField.text;
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    
    NSString *filePath = [docDirectory stringByAppendingString:@"/Name.txt"];
    
    [self.name writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self.welcome setHidden:FALSE];
    [self.previous setHidden:FALSE];
    [self.other setHidden:FALSE];
    [self.down1 setHidden:FALSE];
    [self.down2 setHidden:FALSE];
    
    [self viewDidLoad];
    
}

-(void)dismissKeyboard {
    [self.nameField resignFirstResponder];
}

-(void)deleteName {
    self.name = nil;
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    
    NSString *filePath = [docDirectory stringByAppendingString:@"/Name.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:filePath error:nil];
    
    [self viewDidLoad];
}

@end
