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
@property (weak, nonatomic) IBOutlet UIButton *startLocation;
@property (weak, nonatomic) IBOutlet UIButton* stoplocation;
@property (weak, nonatomic) IBOutlet UILabel *trackLocation;
@property (weak, nonatomic) IBOutlet UIButton *stopTracking;
@property (weak, nonatomic) IBOutlet UILabel *timePath;
@property (weak, nonatomic) IBOutlet UILabel *timeOfPath;
@property (strong, nonatomic) GMSMutablePath *testPath;
@property (nonatomic) NSTimeInterval timeStart;
@property (weak, nonatomic) IBOutlet UILabel *lengthPath;
@property (weak, nonatomic) IBOutlet UILabel *forLength;
@property (weak, nonatomic) IBOutlet UILabel *forLength2;
@property (nonatomic) PFObject* parsePath;
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
    [self.stoplocation setHidden:TRUE];
    [self.trackLocation setHidden:TRUE];
    [self.stopTracking setHidden:TRUE];
    [self.timePath setHidden:TRUE];
    [self.timeOfPath setHidden:TRUE];
    [self.lengthPath setHidden:TRUE];
    [self.forLength setHidden:TRUE];
    locationManager = [[CLLocationManager alloc] init];
    
    self.parsePath = [[PFObject alloc] initWithClassName:@"ParsePath"];
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
    [self.startLocation setHidden:TRUE];
    [self.trackLocation setHidden:FALSE];
    
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
   
    GMSPolyline *route = [GMSPolyline polylineWithPath:self.testPath];
    
    CLLocationCoordinate2D cameraCoord = [self.testPath coordinateAtIndex:0];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:[GMSCameraPosition cameraWithLatitude:cameraCoord.latitude longitude:cameraCoord.longitude zoom:16]];
    
    [self.testPath removeAllCoordinates];
    
    route.strokeColor = [UIColor blueColor];
    route.strokeWidth = 1.f;
    route.map = mapView;
    
    self.view = mapView;
    
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
    

    
    if (currentLocation != nil) {
        [self.testPath addCoordinate:currentLocation.coordinate];
        [self.parsePath addObject:@(currentLocation.coordinate.latitude) forKey:@"latitude"];
        [self.parsePath addObject:@(currentLocation.coordinate.longitude) forKey:@"longitude"];
        [self.parsePath addObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"timeStamps"];
        [self.parsePath saveInBackground];
    }
}
@end
