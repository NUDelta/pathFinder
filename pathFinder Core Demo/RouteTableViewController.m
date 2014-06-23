//
//  RouteTableViewController.m
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 4/25/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import "RouteTableViewController.h"

@interface RouteTableViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)changeSeg:(id)sender;

@property (nonatomic) NSMutableArray *routeDetails;
@property (nonatomic) NSArray *sortedDetails;

@property BOOL parseAdded;
@property int currentLat;
@property int currentLong;
@property BOOL sortByTime;

@end

@implementation RouteTableViewController
CLLocationManager *locationManager;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
//Loads the view controller
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.parseAdded = false;
    
    if (self.segment.selectedSegmentIndex == 0) {
        self.sortByTime = true;
    }
    else if (self.segment.selectedSegmentIndex == 1) {
        self.sortByTime = false;
    }
    
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
        return [self.routeDetails count];
    return 1;
}

//Initilizes the cells based on sortedDetails
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = (RouteTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    if ([self.routeDetails count] > 0) {
            [cell initializeCell:[self.sortedDetails[indexPath.row] getPath]  timeTaken:[self.sortedDetails[indexPath.row] getTime]];
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
    
    //Collects current location
    if (currentLocation != nil) {
        
        self.currentLat = (int)(currentLocation.coordinate.latitude * 1000);
        self.currentLong = (int)(currentLocation.coordinate.longitude * 1000);
    }
    
    [locationManager stopUpdatingLocation];
    
    self.routeDetails = [[NSMutableArray alloc] init];
    self.sortedDetails = [[NSArray alloc] init];
    
    //Finds routes in Parse that start at the current location
    PFQuery *query = [PFQuery queryWithClassName:@"ParsePath"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.parseAdded = true;
            
            int i = 0;
            
            GMSMutablePath *path = [[GMSMutablePath alloc] init];
            
            for (PFObject *object in objects) {
                
                NSArray *latHolder = [object objectForKey:@"latitude"];
                int latFloat = (int)([latHolder[0] floatValue] * 1000);
                
                NSArray *longHolder = [object objectForKey:@"longitude"];
                int longFloat = (int)([longHolder[0] floatValue] * 1000);
                
                if (longFloat == self.currentLong && latFloat == self.currentLat) {
                    
                    for (int j = 0; j < [longHolder count]; j++) {
                        [path addLatitude:[[latHolder objectAtIndex:j] doubleValue] longitude:[[longHolder objectAtIndex:j] doubleValue]];
                    }

                    NSArray *holder = [[NSMutableArray alloc] init];
                    holder = [object objectForKey:@"timeStamps"];
                
                    double hold = [holder[holder.count - 1] doubleValue] - [holder[0] doubleValue];
                    
                    self.routeDetails[i] = [[RouteDetail alloc] initWithRoute:path time:hold];
                    
                    i++;
                }
                
            }
            //Sorts routeDetails into the sorted array, sortedDetails based on the Segmented Control
            self.sortedDetails = [self.routeDetails sortedArrayUsingComparator:^NSComparisonResult(RouteDetail *r1, RouteDetail *r2){
                if (self.sortByTime) {
                    return [r1 compareTime:r2];
                }
                else {
                    return [r1 compareDist:r2];
                }
            }];
            
            
            
            [self.tableView reloadData];
            
        }
        else {
            NSLog(@"error");
        }
        
    }];

}
/**
 Changes the view controller if a cell is clicked to show the selected route on a map
 
 @param segue
 identifies the segue requested from view controllers
 @param sender
 identifies the view controller that sent the segue request
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"CellToMap"]) {
        PathFinderMapViewController *control = [segue destinationViewController];
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        [control setPath:[self.sortedDetails[ip.row] getPath]];

    }
}



/**
 Responds to a change in Segmented Control if the user touches it
 
 @param sender
 identifies the view controller where the gesture occurred
 */
- (IBAction)changeSeg:(id)sender {
    if (self.segment.selectedSegmentIndex == 0) {
        self.sortByTime = true;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [locationManager startUpdatingLocation];
    }
    else if (self.segment.selectedSegmentIndex == 1) {
        self.sortByTime = false;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [locationManager startUpdatingLocation];
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
