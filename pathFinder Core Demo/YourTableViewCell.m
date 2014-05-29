//
//  YourTableViewCell.m
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/23/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import "YourTableViewCell.h"

@implementation YourTableViewCell
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
NSString *start;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.viewForBaselineLayout addGestureRecognizer:tap];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initializeCell:(GMSMutablePath *)inputRoute timeTaken:(NSTimeInterval)time {
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    
    self.route = [[GMSMutablePath alloc] initWithPath:inputRoute];
    
    
    NSString *urlString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
    
    urlString = [urlString stringByAppendingString:@"key=AIzaSyDCevZ4LtOP-XMSvfGd3PNkdS1hoTSYFP8"];
    
    NSString *location = [NSString stringWithFormat:@"&location=%f,%f", [self.route coordinateAtIndex:0].latitude, [self.route coordinateAtIndex:0].longitude];
    
    urlString = [urlString stringByAppendingString:location];
    
    urlString = [urlString stringByAppendingString:@"&rankby=distance&sensor=false&types=establishment"];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if (jsonData != nil) {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            self.start.text = [[[result objectForKey:@"results"] firstObject] objectForKey:@"name"];
        }
    }
    
    
    
    
    CLLocationCoordinate2D end = [self.route coordinateAtIndex:[self.route count] - 1];
    
    
    
    NSString *urlStringEnd = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
    
    urlStringEnd = [urlStringEnd stringByAppendingString:@"key=AIzaSyDCevZ4LtOP-XMSvfGd3PNkdS1hoTSYFP8"];
    
    NSString *locationEnd = [NSString stringWithFormat:@"&location=%f,%f", end.latitude, end.longitude];
    
    urlStringEnd = [urlStringEnd stringByAppendingString:locationEnd];
    
    urlStringEnd = [urlStringEnd stringByAppendingString:@"&rankby=distance&sensor=false&types=establishment"];
    
    
    NSURL *urlEnd = [NSURL URLWithString:urlStringEnd];
    
    NSData *jsonDataEnd = [NSData dataWithContentsOfURL:urlEnd];
    
    if (jsonDataEnd != nil) {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonDataEnd options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            self.end.text = [[[result objectForKey:@"results"] firstObject] objectForKey:@"name"];
        }
    }
    
    if (time > 60)
        self.time.text = [NSString stringWithFormat:@"Time: %.1f min", time/60];
    else
        self.time.text = [NSString stringWithFormat:@"Time: %.2f s", time];
    
    CLLocationDistance dist = [self.route lengthOfKind:kGMSLengthRhumb];
    
    
    if (dist > 1000)
        self.distance.text = [NSString stringWithFormat:@"Distance: %.0f km", dist/1000];
    else
        self.distance.text = [NSString stringWithFormat:@"Distance: %.2f m", dist];
}

-(void)HideName {
    [self.EnterName setHidden:TRUE];
    [self.nameField setHidden:TRUE];
    [self.start setHidden:FALSE];
    [self.end setHidden:FALSE];
    [self.time setHidden:FALSE];
    [self.distance setHidden:FALSE];
    [self.to setHidden:FALSE];
}

-(void)HideLabels {
    [self.start setHidden:TRUE];
    [self.end setHidden:TRUE];
    [self.time setHidden:TRUE];
    [self.distance setHidden:TRUE];
    [self.to setHidden:TRUE];
    [self.EnterName setHidden:FALSE];
    [self.nameField setHidden:FALSE];
}

-(void)HideAll{
    [self.start setHidden:TRUE];
    [self.end setHidden:TRUE];
    [self.time setHidden:TRUE];
    [self.distance setHidden:TRUE];
    [self.to setHidden:TRUE];
    [self.EnterName setHidden:TRUE];
    [self.nameField setHidden:TRUE];
}

- (void)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.name = textField.text;
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    
    NSString *filePath = [docDirectory stringByAppendingString:@"/Name.txt"];
    
    [self.name writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

-(void)dismissKeyboard {
    [self.nameField resignFirstResponder];
}
@end
