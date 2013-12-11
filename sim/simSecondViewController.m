//
//  simSecondViewController.m
//  sim
//
//  Created by Teresa on 10/2/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "simSecondViewController.h"

@interface simSecondViewController ()

@end

@implementation simSecondViewController



#pragma mark - view methods

- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    fileName = @"n2";
    
    //initialize neuron simulation
    n1 = [[simNeuron alloc] init];
    
    //initialize neuron properties
    props = [[neuron alloc] initWithFilename:fileName];
    
    //get props from neuron
    vars = [props loadData:fileName];
    
    if (!vars)  {
        
        //get props from new neuron
        vars = [props loadData:fileName];
    }
    
    
    //get vars from vars Dictionary
    _appI = [vars objectForKey:@"i"];
    _a = [vars objectForKey:@"a"];
    _b = [vars objectForKey:@"b"];
    _c = [vars objectForKey:@"c"];
    _d = [vars objectForKey:@"d"];
    NSNumber *val = [vars objectForKey:@"rs"];
    _rs = [val boolValue];
    
    
    //set labels for first simulation
    [self setLabels];
    
    [self saveData];
    
    
    [self runSim:self];
    
    
    
}//end viewDidLoad

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}//end didReceiveMemoryWarning

-(void)viewWillAppear:(BOOL)animated
{
    
    //get props from neuron
    vars = [props loadData:fileName];
    
    
    //get vars from vars Dictionary
    _appI = [vars objectForKey:@"i"];
    _a = [vars objectForKey:@"a"];
    _b = [vars objectForKey:@"b"];
    _c = [vars objectForKey:@"c"];
    _d = [vars objectForKey:@"d"];
    NSNumber *val = [vars objectForKey:@"rs"];
    _rs = [val boolValue];
    
    //set labels
    [self setLabels];
    
    //set sliders
    [_slider_i setValue:[_appI floatValue]];
    _switch_rs.on = _rs;
    [_slider_a setValue:[_a floatValue]];
    [_slider_b setValue:[_b floatValue]];
    [_slider_c setValue:[_c floatValue]];
    [_slider_d setValue:[_d floatValue]];
    
    
}//end viewwill appear

-(void) viewWillDisappear:(BOOL)animated
{
    [self saveData];
}


#pragma mark -  init

- (simSecondViewController*) init
{
    self = [super init];
    
    fileName = @"n2";
    
    //initialize neuron properties
    props = [[neuron alloc] initWithFilename:fileName];
    
    
    return self;
}




#pragma mark - simulation


- (IBAction)runSim:(id)sender {
    
    BOOL s;
    
    _spikeTrain = [NSMutableString stringWithString:@""];
    
    [n1 reset:_b];
    
    for (int i = 0; i<100; i++) {
        //NSLog(@"_appI is %@", _appI);
        s = [n1 simulate:_appI regSpike:_rs withA:_a B:_b C:_c D:_d];
        if (s)
        {
            //NSLog(@"s is %hhd", s);
            [_spikeTrain appendString:@"|"];
            
        } else {
            [_spikeTrain appendString:@"."];
        }
        
        
    }
    
    //[_spikeTrain appendString:@"___"];
    [_spikeLabel setText:_spikeTrain];
    [_spikeLabel setTextColor:[UIColor blackColor]];
    
    
    //save variable data for circuit simulation
    [self saveData];
    
    
}//end runSim

-(void) saveData
{
    
    
    //make and load dictionary
    vars = [[NSMutableDictionary alloc] init];
    
    [vars setValue:_appI forKey:@"i"];
    [vars setValue:_a forKey:@"a"];
    [vars setValue:_b forKey:@"b"];
    [vars setValue:_c forKey:@"c"];
    [vars setValue:_d forKey:@"d"];
    NSString * booleanString = (_rs) ? @"YES" : @"NO";
    [vars setValue:booleanString forKey:@"rs"];
    
    
    //notify props neuron object and save
    [props changeParams:vars withFilename:fileName];
    
    
}

#pragma mark - external property manipulation methods


//return properties
- (NSMutableDictionary*) neurProps
{
    
    return [props loadData: fileName];
    
}//end neurProps

//reset properties
- (void) clearParams
{
    [props resetData:fileName];
}



#pragma mark - buttons and sliders



- (IBAction)appCurrentSlider:(UISlider *)sender {
    
    
    _appI = [NSNumber numberWithFloat:[sender value]];
    
    [_appCurrentLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_appI floatValue] ]] stringValue]];
    
}//end appCurrentSlider

- (IBAction)rsSwitch:(UISwitch *)sender {
    
    _rs = sender.on;
    
    
}//end rsSwitch


- (IBAction)aSlider:(UISlider *)sender {
    
    _a = [NSNumber numberWithFloat:[sender value]];
    
    [_aLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_a floatValue] ]] stringValue]];
    
}

- (IBAction)bSlider:(UISlider *)sender {
    
    _b = [NSNumber numberWithFloat:[sender value]];
    
    [_bLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_b floatValue] ]] stringValue]];
    
    
}

- (IBAction)cSlider:(UISlider *)sender {
    
    _c = [NSNumber numberWithFloat:[sender value]];
    
    [_cLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_c floatValue] ]] stringValue]];
}

- (IBAction)dSlider:(UISlider *)sender {
    
    _d = [NSNumber numberWithFloat:[sender value]];
    
    [_dLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_d floatValue] ]] stringValue]];
    
    
}

#pragma mark - utilities

- (void) setLabels
{
    
    [_appCurrentLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_appI floatValue] ]] stringValue] ];
    [_aLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_a floatValue] ]] stringValue] ];
    [_bLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_b floatValue] ]] stringValue] ];
    [_cLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_c floatValue] ]] stringValue] ];
    [_dLabel setText:[ [NSNumber numberWithFloat: [self cleanUpFloat:[_d floatValue] ]] stringValue] ];
    
}

- (float) cleanUpFloat:(float)f
{
    
    //set up formatter
    NSNumberFormatter * formatter =  [[NSNumberFormatter alloc] init];
    [formatter setUsesSignificantDigits:YES];
    [formatter setMaximumSignificantDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundCeiling];
    
    //change to string
    NSString* str = [formatter stringFromNumber:[NSNumber numberWithFloat:f]];
    
    //change string to float and return
    return [str floatValue];
    
}

@end
