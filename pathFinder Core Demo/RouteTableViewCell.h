//
//  RouteTableViewCell.h
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/2/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface RouteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *startToEnd;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property GMSMutablePath* route;

- (void)initializeCell:(GMSMutablePath *)inputRoute timeTaken:(NSTimeInterval)time;

@end
