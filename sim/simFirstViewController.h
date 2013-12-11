//
//  simFirstViewController.h
//  sim
//
//  Created by Teresa on 10/2/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "neuron.h"

#import "simNeuron.h"
#import "fileUtilities.h"

@interface simFirstViewController : UIViewController
{ //instance vars

    simNeuron* n1;
    neuron* props;
    NSString* fileName;
    NSMutableDictionary* vars;
    
}


#pragma mark - property variables

@property (strong, nonatomic) NSMutableString* spikeTrain;
@property (weak, nonatomic) IBOutlet UILabel *spikeLabel;

@property (strong, nonatomic) NSNumber *appI;
@property (strong, nonatomic) NSNumber* a;//timescale of u, recovery variable
@property (strong, nonatomic) NSNumber* b;//sensitivity of u to v
@property (strong, nonatomic) NSNumber* c;//after spike reset value of v, membrane potential
@property (strong, nonatomic) NSNumber* d;//after spike reset increment of u
@property (nonatomic) BOOL rs;//if the neuron is regular spiking, the equation constants slightly differ


#pragma mark - UI parameters

@property (weak, nonatomic) IBOutlet UILabel *appCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;
@property (weak, nonatomic) IBOutlet UILabel *bLabel;
@property (weak, nonatomic) IBOutlet UILabel *cLabel;
@property (weak, nonatomic) IBOutlet UILabel *dLabel;

- (IBAction)runSim:(id)sender;
- (IBAction)appCurrentSlider:(UISlider *)sender;
- (IBAction)rsSwitch:(UISwitch *)sender;
- (IBAction)aSlider:(UISlider *)sender;
- (IBAction)bSlider:(UISlider *)sender;
- (IBAction)cSlider:(UISlider *)sender;
- (IBAction)dSlider:(UISlider *)sender;

//slider outlets for resetting
@property (weak, nonatomic) IBOutlet UISlider *slider_i;
@property (weak, nonatomic) IBOutlet UISwitch *switch_rs;
@property (weak, nonatomic) IBOutlet UISlider *slider_a;
@property (weak, nonatomic) IBOutlet UISlider *slider_b;
@property (weak, nonatomic) IBOutlet UISlider *slider_c;
@property (weak, nonatomic) IBOutlet UISlider *slider_d;

#pragma mark - data retrieval methods
- (NSMutableDictionary*) neurProps;
- (void) clearParams;


@end
