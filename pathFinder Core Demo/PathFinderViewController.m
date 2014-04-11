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
- (IBAction)showRoute:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startLocation;
@property (weak, nonatomic) IBOutlet UIButton* stoplocation;
@property (strong, nonatomic) GMSMutablePath *testPath;
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
    locationManager = [[CLLocationManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.stoplocation setHidden:FALSE];
    [self.startLocation setHidden:TRUE];
    
    [locationManager startUpdatingLocation];
}

- (IBAction)showRoute:(id)sender {
    [locationManager stopUpdatingLocation];
    
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
    }
}
@end
