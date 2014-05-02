//
//  PathFinderMapViewController.m
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/2/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import "PathFinderMapViewController.h"

@interface PathFinderMapViewController ()

@end

@implementation PathFinderMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    GMSPolyline *line = [GMSPolyline polylineWithPath:self.route];
    
    CLLocationCoordinate2D cameraCoord = [self.route coordinateAtIndex:0];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:[GMSCameraPosition cameraWithLatitude:cameraCoord.latitude longitude:cameraCoord.longitude zoom:16]];
    
    line.strokeColor = [UIColor blueColor];
    line.strokeWidth = 1.f;
    line.map = mapView;
    
    self.view = mapView;
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
