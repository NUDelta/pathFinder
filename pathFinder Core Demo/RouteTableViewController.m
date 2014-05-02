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
@end

@implementation RouteTableViewController

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
    
    self.latitude = [[NSMutableArray alloc] init];
    self.longitude = [[NSMutableArray alloc] init];
    self.startTimes = [[NSMutableArray alloc] init];
    self.stopTimes = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ParsePath"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"got %d objects", objects.count);
            int i = 0;
            
            for (PFObject *object in objects) {
                self.latitude[i] = [object objectForKey:@"latitude"];
                
                self.longitude[i] = [object objectForKey:@"longitude"];
                NSMutableArray *holder = [[NSMutableArray alloc] init];
                holder = [object objectForKey:@"timeStamps"];
                
               
                self.startTimes[i] = holder[0];
                self.stopTimes[i] = holder[holder.count - 1];
                
                i++;
            }
            
            NSLog(@"%@  %@", self.startTimes[0], self.latitude[0][0]);
        
        }
        else {
            NSLog(@"error");
        }
        
    }];
    
        
        
            
            
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
 
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"ParsePath"];
    NSArray *holder = [query findObjects];

    
    cell.textLabel.text = [NSString stringWithFormat:@"Route %d", indexPath.row + 1];
    
    return cell;
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
        
        NSLog(@"Lat: %@, Long: %@", latHolder[0], longHolder[1]);
        
        
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
