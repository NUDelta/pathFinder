//
//  YourRouteTableViewController.m
//  pathFinder Core Demo
//
//  Created by Nick Scoliard on 5/23/14.
//  Copyright (c) 2014 Delta Lab. All rights reserved.
//

#import "YourRouteTableViewController.h"

@interface YourRouteTableViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)segChange:(id)sender;
@property (nonatomic) NSMutableArray *routeDetails;
@property (nonatomic) NSArray *sortedDetails;

@property BOOL parseAdded;
@property NSString *name;
@property BOOL sortByTime;

@end

@implementation YourRouteTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    if (self.segment.selectedSegmentIndex == 0) {
        self.sortByTime = true;
    }
    else if (self.segment.selectedSegmentIndex == 1) {
        self.sortByTime = false;
    }
    
    [self startTable];
    
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
        return [self.sortedDetails count];
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YourTableViewCell *cell = (YourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"YourTableCell" forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = (YourTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YourTableCell"];
    }
    
    if ([self.sortedDetails count] > 0) {
        [cell initializeCell:[self.sortedDetails[indexPath.row] getPath] timeTaken:[self.sortedDetails[indexPath.row] getTime]];
    }
    
    return cell;
}

#pragma mark - CLLocationManagerDelegate

- (void)startTable
{
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    
    NSString *filePath = [docDirectory stringByAppendingString:@"/Name.txt"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (!fileContents) {
        return;
    }
    else if (fileContents && !self.name) {
        self.name = fileContents;
    }

    
    self.sortedDetails = [[NSArray alloc] init];
    self.routeDetails = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ParsePath"];
    [query whereKey:@"Name" equalTo:self.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.parseAdded = true;
            
            int i = 0;
            
            GMSMutablePath *path = [[GMSMutablePath alloc] init];
            
            for (PFObject *object in objects) {
                
                NSArray *latHolder  = [object objectForKey:@"latitude"];
                
                NSArray *longHolder = [object objectForKey:@"longitude"];

                for (int j = 0; j < [longHolder count]; j++) {
                    [path addLatitude:[[latHolder objectAtIndex:j] doubleValue] longitude:[[longHolder objectAtIndex:j] doubleValue]];
                }
                
                
                
                NSArray *holder = [[NSMutableArray alloc] init];
                holder = [object objectForKey:@"timeStamps"];
                
                double hold = [holder[holder.count - 1] doubleValue] - [holder[0] doubleValue];
                
                self.routeDetails[i] = [[RouteDetail alloc] initWithRoute:path time:hold];
                
                i++;
            }
            
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

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"YourCellToMap"]) {
        PathFinderMapViewController *control = [segue destinationViewController];
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        
        control.route = [[GMSMutablePath alloc] initWithPath:[self.sortedDetails[ip.row] getPath]];
        
    }
}*/

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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"YourCellToMap"]) {
         PathFinderMapViewController *control = [segue destinationViewController];
         
         NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
         
         
         control.route = [[GMSMutablePath alloc] initWithPath:[self.sortedDetails[ip.row] getPath]];
     }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Row Selected = %i",indexPath.row);
    
    [self performSegueWithIdentifier:@"testID" sender:self.view];
}


- (IBAction)segChange:(id)sender {
    if (self.segment.selectedSegmentIndex == 0) {
        self.sortByTime = true;
        [self startTable];    }
    else if (self.segment.selectedSegmentIndex == 1) {
        self.sortByTime = false;
        [self startTable];
    }
}
@end

