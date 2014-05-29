//
//  RouteDetail.h
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/29/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface RouteDetail : NSObject
@property GMSMutablePath *path;
@property double time;
@property double distance;

- (NSComparisonResult)compareDist:(RouteDetail *)otherRoute;
- (NSComparisonResult)compareTime:(RouteDetail *)otherRoute;
-(id)initWithRoute:(GMSMutablePath *)route time:(double)time;
-(GMSMutablePath *)getPath;
-(double)getTime;
@end
