//
//  simNeuronUITableViewController.m
//  sim
//
//  Created by Teresa on 10/6/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "simNeuronUITableViewController.h"

#import "simFirstViewController.h"
#import "simSecondViewController.h"
#import "simThirdViewController.h"

@interface simNeuronUITableViewController ()

@end

@implementation simNeuronUITableViewController

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
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Neurons" ofType:@"plist"];
    
    _neurons = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    //_neuronKeys = [_neurons allKeys];
    _neuronKeys = [[NSArray alloc] initWithObjects:@"Presynaptic Neuron 1",@"Presynaptic Neuron 2",@"Postsynaptic Neuron 3",@"Prefab neurons", @"The mathematical model",@"Basic neuron types", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_neuronKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    // Configure the cell...
    NSString* currentNeuron = [_neuronKeys objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:currentNeuron];
    
    //NSLog(@"row: %i currentNeuron: %@",[indexPath row], currentNeuron);
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //simFirstViewController *first = [[simFirstViewController alloc] initWithNibName:nil bundle:nil];
            //[self.navigationController pushViewController:first animated:YES];
             [self performSegueWithIdentifier:@"firstSegue" sender:nil];
            break;
        }
        case 1:
        {
            [self performSegueWithIdentifier:@"secondSegue" sender:nil];
            break;
        }
        case 2:
        {
            [self performSegueWithIdentifier:@"thirdSegue" sender:nil];
            break;
        }
        case 3:{
            [self performSegueWithIdentifier:@"fourthSegue" sender:nil];
            break;
        }
        case 4:{
            [self performSegueWithIdentifier:@"fifthSegue" sender:nil];
            break;
        }
        case 5:{
            [self performSegueWithIdentifier:@"sixthSegue" sender:nil];
            break;
        }
            
        default:
            break;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
