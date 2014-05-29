//
//  RouteDetail.m
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/29/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import "RouteDetail.h"

@implementation RouteDetail


- (id)initWithRoute:(GMSMutablePath *)route time:(double)time {
    self = [super init];
    if (self) {
        self.path = [[GMSMutablePath alloc] initWithPath:route];
        self.time = time;
        self.distance = [self.path lengthOfKind:kGMSLengthRhumb];
    }
    
    return self;
    
}

- (NSComparisonResult)compareDist:(RouteDetail *)otherRoute {
    if (self.distance > otherRoute.distance) {
        return NSOrderedDescending;
    }
    else if (self.distance < otherRoute.distance) {
        return NSOrderedAscending;
    }
    else
        return NSOrderedSame;
}

- (NSComparisonResult)compareTime:(RouteDetail *)otherRoute {
    
    if (self.time > otherRoute.time) {
        return NSOrderedDescending;
    }
    else if (self.time < otherRoute.time) {
        return NSOrderedAscending;
    }
    else
        return NSOrderedSame;
}

-(GMSMutablePath *)getPath {
    return self.path;
}
-(double)getTime {
    return self.time;
}

@end
