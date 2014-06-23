//
//  RouteDetail.h
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/29/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//
//Object that can hold a route, its time, and its distance, in order for the tables to sort the cells based on time or distance

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface RouteDetail : NSObject

/**
 Compares two @c RouteDetail objects based on distance, and returns their order
 
 @param otherRoute
 Route being compared to @c self
 @return NSOrderedDescending if @c otherRoute is shorter than @c self
 NSOrderedAscending if @c otherRoute is longer than @c self
 NSOrderedSame if @c otherRoute is the same distance as @c self
 */
- (NSComparisonResult)compareDist:(RouteDetail *)otherRoute;
/**
 Compares two @c RouteDetail objects based on time, and returns their order
 
 @param otherRoute
 Route being compared to @c self
 @return NSOrderedDescending if @c otherRoute takes less than @c self
 NSOrderedAscending if @c otherRoute takes more time than @c self
 NSOrderedSame if @c otherRoute takes the same amount of time as @c self
 */
- (NSComparisonResult)compareTime:(RouteDetail *)otherRoute;

/**
 Initializes a @c RouteDetail object with a given route and time of route
 
 @param route
 Route to be stored in the @c RouteDetail object
 @param time
 Time to be stored in the @c RouteDetial object
 @return @c RouteDetail object with @c route and @c time stored as private variables
 */
-(id)initWithRoute:(GMSMutablePath *)route time:(double)time;

/**
 Returns the private variable @c path from a @c RouteDetail object
 

 @return @c GMSMutablePath route stored in @c RouteDetail object
 */
-(GMSMutablePath *)getPath;

/**
 Returns the private variable @c time from a @c RouteDetail object
 
 
 @return @c double time stored in @c RouteDetail object
 */
-(double)getTime;
@end
