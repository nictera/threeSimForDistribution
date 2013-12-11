//
//  simNeuron.m
//  sim
//
//  Created by Teresa on 10/2/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "simNeuron.h"


@implementation simNeuron

#pragma mark - init

-(id) init
{
    //initialize superclass
    self = [super init];
    
    [self reset:Nil];
    
    return self;
    
}

//preFab method

-(BOOL) resetVars : (NSString*)type withFilename : (NSString*)fileName
{
    //NSLog(@"resetVars - type: %@, fileName: %@", type, fileName);
    
    //RS-dependent variables
    e = 5;
    f = 140;
    
    [self setType:type];
    
    
    //initialize u and v
    int r = (arc4random()%80);
    v = (-1*r)-50;//Izhikhevich used -65, but too slow to get exciting and too un-random
    u = v * [_b floatValue];
    
    if ([_d floatValue] == 0) {//type is CC
        u = 0;
        v = CURRENTCLAMPHOLD;
    }
    
    //nand save
    //make and load dictionary
    NSMutableDictionary* vars = [[NSMutableDictionary alloc] init];
    
    [vars setValue:_i forKey:@"i"];
    [vars setValue:_a forKey:@"a"];
    [vars setValue:_b forKey:@"b"];
    [vars setValue:_c forKey:@"c"];
    [vars setValue:_d forKey:@"d"];
    NSString * booleanString = (_rs) ? @"YES" : @"NO";
    [vars setValue:booleanString forKey:@"rs"];

    //get the path to the plist file
    NSString* savePath = [fileUtilities path2SaveFile:fileName];

    //write to file
    [vars writeToFile:savePath atomically:NO];
    
    
    
    //NSLog(@"fileName: %@, savePath: %@, vars: %@", fileName, savePath, vars);


    return YES;
}

- (void) setType : (NSString*)type
{
    //convert string to integer for switch - case
    if ([type isEqualToString:@"RS"])
    {
        
        _i = [NSNumber numberWithFloat:0];
        _rs = YES;//an RS neuron
        _a = [NSNumber numberWithFloat:0.02];
        _b = [NSNumber numberWithFloat:0.2];
        _c = [NSNumber numberWithFloat:-65];//mV
        _d = [NSNumber numberWithFloat:8];
        
        //special for RS
        e = 4.1;
        f = 108;
        
    } else if ([type isEqualToString:@"IB"]) {
        
        _i = [NSNumber numberWithFloat:0];
        _rs = NO;//not an RS neuron
        _a = [NSNumber numberWithFloat:0.02];
        _b = [NSNumber numberWithFloat:0.2];
        _c = [NSNumber numberWithFloat:-55];//mV
        _d = [NSNumber numberWithFloat:4];
        
    } else if ([type isEqualToString:@"CH"]) {
        
        _i = [NSNumber numberWithFloat:0];
        _rs = NO;//not an RS neuron
        _a = [NSNumber numberWithFloat:0.02];
        _b = [NSNumber numberWithFloat:0.2];
        _c = [NSNumber numberWithFloat:-50];//mV
        _d = [NSNumber numberWithFloat:2];
        
    } else if ([type isEqualToString:@"FS"]) {
        
        _i = [NSNumber numberWithFloat:0];
        _rs = NO;//not an RS neuron
        _a = [NSNumber numberWithFloat:0.1];
        _b = [NSNumber numberWithFloat:0.2];
        _c = [NSNumber numberWithFloat:-65];//mV
        _d = [NSNumber numberWithFloat:2];
        
    } else if ([type isEqualToString:@"LTS"]) {
        
        _i = [NSNumber numberWithFloat:0];
        _rs = NO;//not an RS neuron
        _a = [NSNumber numberWithFloat:0.02];
        _b = [NSNumber numberWithFloat:0.25];
        _c = [NSNumber numberWithFloat:-65];//mV
        _d = [NSNumber numberWithFloat:2];
        
    } else if ([type isEqualToString:@"TC"]) {//inhibiotry rebound burst if v -> -90
        
        _i = [NSNumber numberWithFloat:0];
        _rs = NO;//not an RS neuron
        _a = [NSNumber numberWithFloat:0.02];
        _b = [NSNumber numberWithFloat:0.25];
        _c = [NSNumber numberWithFloat:-65];//mV
        _d = [NSNumber numberWithFloat:0.05];
        
    } else if ([type isEqualToString:@"RZ"]) {//resonator
        
        _i = [NSNumber numberWithFloat:0];
        _rs = NO;//not an RS neuron
        _a = [NSNumber numberWithFloat:0.1];
        _b = [NSNumber numberWithFloat:0.26];
        _c = [NSNumber numberWithFloat:-60];//mV
        _d = [NSNumber numberWithFloat:2];
    } else if (([type isEqualToString:@"CC"]) || ([type isEqualToString:@"OFF"])) {//current clamp for post, effectively off for pre
        
        _i = [NSNumber numberWithFloat:0];
        _rs = NO;//not an RS neuron
        _a = [NSNumber numberWithFloat:0.02];
        _b = [NSNumber numberWithFloat:0.2];
        _c = [NSNumber numberWithFloat:-65];//mV
        _d = [NSNumber numberWithFloat:0];
        
        //add custom types here
    } else {
        NSLog(@"Invalid neuron type.");
    }
}

#pragma mark - simulation methods

-(BOOL)simulate:(NSNumber*)I withType:(NSString*)type
{
    float vprime;
    float uprime;
    
    [self setType:type];
    
    if ([_d floatValue] ==0)//type is CC
    {
        u = 0;
        v = CURRENTCLAMPHOLD;
    }

    
    //simulation
    vprime = (0.04 * powf(v, 2)) + (e * v) + f - u + [_i floatValue];
    uprime = [_a floatValue] * ([_b floatValue]*v - u);
    
    v = v + 0.5 * vprime;//divide 1 ms into 2 for numerical stability
    v = v + 0.5 * vprime;
    u = u + uprime;
    
    //NSLog(@"Values are: rs = %hhd, a = %@, b = %@, c = %@, d = %@, e = %f, f = %f, i = %@", _rs, _a, _b, _c, _d, e, f, _i);
    
    
    if (v>=30) {
        v = [_c floatValue];
        u = u + [_d floatValue];
        return YES;
    }
    
    
    //NSLog(@"u = %f, v = %f", u, v);
    
    return NO;
    
}


//simulate a millisecond of neural activity
//inputs: 6 parameters from Izhikevich model (2003)
//output: bool - spike
-(BOOL)simulate:(NSNumber*)I regSpike:(BOOL)RS withA:(NSNumber*)A B:(NSNumber*)B C:(NSNumber*)C D:(NSNumber*)D

{
    if (I) {
        _i = I;
    }
    if (RS) {
        _rs = RS;
    }
    if (A){
        _a = A;
    }
    if (B){
        _b = B;
    }
    if (C){
        _c = C;
    }
    if (D){
        _d = D;
    }
    
    //NSLog(@"_i is %@", _i);
    
    if ([_d floatValue] == 0)//type is CC
    {
        u = 0;
        v = CURRENTCLAMPHOLD;
    }
    
    float vprime = 0;
    float uprime = 0;
    
    //check if regular spiking
    if (_rs) {
        e = 4.1;
        f = 108;
    }
    
    
    //simulation
    if ([_d floatValue] != 0) {
        vprime = (0.04 * powf(v, 2)) + (e * v) + f - u + [_i floatValue];
        uprime = [_a floatValue] * (([_b floatValue]*v) - u);
    } else {
        vprime = [_i floatValue];
    }
    
    //NSLog(@"u=%f v = %f uprime = %f, vprime= %f", u, v, uprime, vprime);
    
    v = v + 0.5 * vprime;//divide 1 ms into 2 for numerical stability
    v = v + 0.5 * vprime;
    u = u + uprime;
    
    //NSLog(@"Values are: rs = %hhd, a = %@, b = %@, c = %@, d = %@, e = %f, f = %f, i = %@", _rs, _a, _b, _c, _d, e, f, _i);
    //NSLog(@"v=%f, u=%f, i=%@, v>=30: %d  powf(v, 2): %f", v, u, I, v>=30,  powf(v, 2));
    
    if (v>=30) {
        v = [_c floatValue];
        u = u + [_d floatValue];
       
        return YES;
    }
    
   

    
    return NO;
}// end simulate

-(void)reset:(NSNumber*)B
{
    //set defaults
    _i = [NSNumber numberWithFloat:5];
    _rs = NO;//not an RS neuron
    _a = [NSNumber numberWithFloat:0.02];
    
    _c = [NSNumber numberWithFloat:-65];//mV
    _d = [NSNumber numberWithFloat:2];
    
    if (B) {
        _b = B;
    }
    
    //RS-dependent variables
    e = 5;
    f = 140;
    
    //initialize u and v
    int r = (arc4random()%85);
    v = (-1*r)-50;//Izhikhevich used -65, but too slow to get exciting and too un-random
    u = v * [_b floatValue];
    
    if ([_d floatValue] ==0)//type is CC
    {
        u = 0;
        v = CURRENTCLAMPHOLD;
    }


}// end reset

@end
