//
//  PathFinderMapViewController.h
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/2/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface PathFinderMapViewController : UIViewController

/**
 Sets the private variable @c route to given route
 
 @param route
 Route being passed into the map contorller
 */
- (void)setPath:(GMSMutablePath *)route;

@end
