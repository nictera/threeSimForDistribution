//
//  simCircuitViewController.m
//  sim
//
//  Created by Teresa on 10/5/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "simCircuitViewController.h"

@interface simCircuitViewController ()

@end

@implementation simCircuitViewController

//major output to spike viewer:
NSMutableArray* spikes;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [self reset:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - run simulation

- (IBAction)runSimulation:(UIButton *)sender {
    
    //run simulations for all 3 cells
    
    //make synVar dictionary
    NSMutableDictionary* synVars = [[NSMutableDictionary alloc] init];
    [synVars setValue:_peak1 forKey:@"peak1"];
    [synVars setValue:_tau1 forKey:@"tau1"];
    [synVars setValue:_peak2 forKey:@"peak2"];
    [synVars setValue:_tau2 forKey:@"tau2"];
    [synVars setValue:_stimTime forKey:@"stimTime"];
    [synVars setValue:_randMax forKey:@"randMax"];
    
       
    //call network simulator
    simNetwork* network = [[simNetwork alloc] init];
    spikes = [network simulateNetwork:synVars];
    
    
    
    //switch to simulation simSpikeViewer view controller
    [self.tabBarController setSelectedIndex:1];


    
}//end runSimulation

#pragma mark - manage spikes

+ (NSMutableArray*)getSpikes
{
    return spikes;
    
}//end getSpikes

+ (void) deleteSpikes
{
    spikes = nil;
}

#pragma mark - reset everything

- (IBAction)reset:(UIButton *)sender {
    
    //reset neuron properties
    simFirstViewController* VC1 = [[simFirstViewController alloc] init];
    [VC1 clearParams];
    simSecondViewController* VC2 = [[simSecondViewController alloc] init];
    [VC2 clearParams];
    simThirdViewController* VC3 = [[simThirdViewController alloc] init];
    [VC3 clearParams];
    
    //reset prefab viewer settings
    simPrefabViewController* prefab =[[simPrefabViewController alloc] init];
    [prefab resetSegControls];
    
    //reset synaptic parameters
    //initialize parameters
    _peak1 = [NSNumber numberWithFloat:5];
    _tau1 = [NSNumber numberWithFloat:2];
    _peak2 = [NSNumber numberWithFloat:5];
    _tau2 = [NSNumber numberWithFloat:2];
    _stimTime = [NSNumber numberWithFloat:1];
    _randMax = [NSNumber numberWithFloat:10];
    
    //set labels
    [_peak1Label setText:[_peak1 stringValue]];
    [_tau1Label setText:[_tau1 stringValue]];
    [_peak2Label setText:[_peak2 stringValue]];
    [_tau2Label setText:[_tau2 stringValue]];
    [_stimTimeLabel setText:[_stimTime stringValue]];
    [_randMaxLabel setText:[_randMax stringValue]];
    
    //reset sliders
    [_slider1peak setValue:[_peak1 floatValue] animated:YES];
    [_slider1time setValue:[_tau1 floatValue] animated:YES];
    [_slider2peak setValue:[_peak2 floatValue] animated:YES];
    [_slider2time setValue:[_tau2 floatValue] animated:YES];
    [_sliderSimTime setValue:[_stimTime floatValue] animated:YES];
    [_sliderRandMax setValue:[_randMax floatValue] animated:YES];
    
    //delete spikes
    spikes = nil;
    
    //reset simSpikeViewer
    [simSpikeViewerViewController resetData];

}//end reset


- (NSMutableString*)array2String : (NSMutableArray*)array
{
    NSMutableString* spikeTrain = [[NSMutableString alloc] init];
    
    for (int i = 0; i< [array count]; i++) {
        [spikeTrain appendString:[[array objectAtIndex:i] stringValue]];
    }
    
    return spikeTrain;
}//end array2String


#pragma mark - sliders

- (IBAction)peak1Slider:(UISlider *)sender {
    
    _peak1 = [NSNumber numberWithFloat:[sender value]];
    
    [_peak1Label setText:[_peak1 stringValue]];
}

- (IBAction)tau1Slider:(UISlider *)sender {
    _tau1 = [NSNumber numberWithFloat:[sender value]];
    
    [_tau1Label setText:[_tau1 stringValue]];

}

- (IBAction)peak2Slider:(UISlider *)sender {
    _peak2 = [NSNumber numberWithFloat:[sender value]];
    
    [_peak2Label setText:[_peak2 stringValue]];

}

- (IBAction)tau2Slider:(UISlider *)sender {
    _tau2 = [NSNumber numberWithFloat:[sender value]];
    
    [_tau2Label setText:[_tau2 stringValue]];

}

- (IBAction)stimTimeSlider:(UISlider *)sender {
    
    _stimTime = [NSNumber numberWithFloat:[sender value]];
    
    //need to make _stimTime even milliseconds
    float s = [_stimTime floatValue]*1000;//convert to milliseconds
    
    float s2 = floorf(s)/1000;
    
    _stimTime = [NSNumber numberWithFloat:s2];
    
    [_stimTimeLabel setText:[_stimTime stringValue]];
}

- (IBAction)randMaxSlider:(UISlider *)sender {
    
    _randMax = [NSNumber numberWithFloat:[sender value]];
    
    [_randMaxLabel setText:[_randMax stringValue]];
}
@end
