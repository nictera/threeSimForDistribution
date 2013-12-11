//
//  simPrefabViewController.h
//  sim
//
//  Created by Teresa on 10/11/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simFirstViewController.h"
#import "simSecondViewController.h"
#import "simThirdViewController.h"
#import "fileUtilities.h"

@interface simPrefabViewController : UIViewController
{
    NSMutableArray* props;//neuron array
    NSMutableArray* n;//simNeuron array
    NSArray* fileNames;//filenames array
    NSMutableArray* spikeLabels;//string array for display
    NSMutableArray* types;
    NSMutableArray* typeInds;
    
}

@property (weak, nonatomic) IBOutlet UILabel *spikeTrain1;
@property (weak, nonatomic) IBOutlet UILabel *spikeTrain2;
@property (weak, nonatomic) IBOutlet UILabel *spikeTrain3;

@property (strong, nonatomic) NSNumber *appI;
@property (strong, nonatomic) NSNumber* a;//timescale of u, recovery variable
@property (strong, nonatomic) NSNumber* b;//sensitivity of u to v
@property (strong, nonatomic) NSNumber* c;//after spike reset value of v, membrane potential
@property (strong, nonatomic) NSNumber* d;//after spike reset increment of u
@property (nonatomic) BOOL rs;//if the neuron is regular spiking, the equation constants slightly differ
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl1Outlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl2Outlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl3Outlet;

#pragma mark - methods

- (IBAction)preFab1:(UISegmentedControl *)sender;
- (IBAction)preFab2:(UISegmentedControl *)sender;
- (IBAction)preFab3:(UISegmentedControl *)sender;

- (IBAction)runSim1:(UIButton *)sender;
- (IBAction)runSim2:(UIButton *)sender;
- (IBAction)runSim3:(UIButton *)sender;

#pragma mark - reset method
- (void) resetSegControls;

@end
