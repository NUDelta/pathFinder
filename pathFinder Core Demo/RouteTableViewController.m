//
//  RouteTableViewController.m
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 4/25/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import "RouteTableViewController.h"

@interface RouteTableViewController ()
@property (nonatomic) NSMutableArray *latitude;
@property (nonatomic) NSMutableArray *longitude;
@property (nonatomic) NSMutableArray *startTimes;
@property (nonatomic) NSMutableArray *stopTimes;
@property (nonatomic) GMSMutablePath *testPath;
@property BOOL parseAdded;
@property float currentLat;
@property float currentLong;
@end

@implementation RouteTableViewController
CLLocationManager *locationManager;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    NSLog(@"%@", @"first");
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.parseAdded = false;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager startUpdatingLocation];
            
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
 

    if (self.parseAdded)
        return [self.latitude count];
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = (RouteTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    if ([self.latitude count] != 0) {
        
        GMSMutablePath *path = [[GMSMutablePath alloc] init];
        
        for (int i = 0; i < [self.latitude[indexPath.row] count]; i++) {
            [path addLatitude:[[self.latitude[indexPath.row] objectAtIndex:i] doubleValue] longitude:[[self.longitude[indexPath.row] objectAtIndex:i] doubleValue]];
        }
        
        NSTimeInterval time = [self.stopTimes[indexPath.row] doubleValue] - [self.startTimes[indexPath.row] doubleValue];
        
        [cell initializeCell:path  timeTaken:time];
    }
    
    return cell;
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
        NSString *latHold = [NSString stringWithFormat:@"%.3f", currentLocation.coordinate.latitude];
        NSString *longHold = [NSString stringWithFormat:@"%.3f", currentLocation.coordinate.longitude];
        self.currentLat = [latHold floatValue];
        self.currentLong = [longHold floatValue];
    }
    
    [locationManager stopUpdatingLocation];
    
    self.latitude = [[NSMutableArray alloc] init];
    self.longitude = [[NSMutableArray alloc] init];
    self.startTimes = [[NSMutableArray alloc] init];
    self.stopTimes = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ParsePath"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.parseAdded = true;
            
            int i = 0;
            
            for (PFObject *object in objects) {
                NSArray *latHolder = [object objectForKey:@"latitude"];
                float latFloat = [latHolder[0] floatValue];
                NSString *latRound = [NSString stringWithFormat:@"%.3f", latFloat];
                latFloat =[latRound floatValue];
                
                if (latFloat == self.currentLat)
                    self.latitude[i] = latHolder;
                else
                    continue;
                
                NSArray *longHolder = [object objectForKey:@"longitude"];
                float longFloat = [longHolder[0] floatValue];
                NSString *longRound = [NSString stringWithFormat:@"%.3f", longFloat];
                longFloat =[longRound floatValue];
                
                if (longFloat == self.currentLong)
                    self.longitude[i] = longHolder;
                else {
                    [self.latitude removeLastObject];
                    continue;
                }
                
                
                
                
                NSArray *holder = [[NSMutableArray alloc] init];
                holder = [object objectForKey:@"timeStamps"];
                
                
                self.startTimes[i] = holder[0];
                self.stopTimes[i] = holder[holder.count - 1];
                
                i++;
            }
            
            NSLog(@"%d", i);
            [self.tableView reloadData];
            
        }
        else {
            NSLog(@"error");
        }
        
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"CellToMap"]) {
        PathFinderMapViewController *control = [segue destinationViewController];
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        NSArray *latHolder  = self.latitude[ip.row];
        
        NSArray* longHolder = self.longitude[ip.row];
        
        
        control.route = [[GMSMutablePath alloc] init];
        
        for (int i = 0; i < latHolder.count; i++) {
            [control.route addLatitude:[latHolder[i] doubleValue] longitude:[longHolder[i] doubleValue]];
        }
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
