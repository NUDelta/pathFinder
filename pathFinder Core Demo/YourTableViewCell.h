//
//  YourTableViewCell.h
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/23/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface YourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *to;
@property (weak, nonatomic) IBOutlet UILabel *EnterName;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property GMSMutablePath* route;
@property NSString *name;

/**
 Creates a table cell with a given route and time for the route

 @param inputRoute
 The route for the cell
 @param time
 The time taken to walk the given route
 */
- (void)initializeCell:(GMSMutablePath *)inputRoute timeTaken:(NSTimeInterval)time;
@end
