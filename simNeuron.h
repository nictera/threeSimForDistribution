//
//  simNeuron.h
//  sim
//
//  Created by Teresa on 10/2/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "neuron.h"
#import <stdlib.h>

#define CURRENTCLAMPHOLD -45;


@interface simNeuron : NSObject
{
    float v;//membrane voltage
    float u;//recovery variable
    float e;//second term in equation - RS-dependent
    float f;//third term in equation - RS-dependent
}

#pragma input arguments
//based on Izhikevich, 2003 model

@property (strong, nonatomic) NSNumber* i;//applied current
@property (strong, nonatomic) NSNumber* a;//timescale of u, recovery variable
@property (strong, nonatomic) NSNumber* b;//sensitivity of u to v
@property (strong, nonatomic) NSNumber* c;//after spike reset value of v, membrane potential
@property (strong, nonatomic) NSNumber* d;//after spike reset increment of u
@property (nonatomic) BOOL rs;//if the neuron is regular spiking, the equation constants slightly differ




#pragma methods
-(BOOL) resetVars : (NSString*)type withFilename : (NSString*)fileName;
//-(BOOL)simulate:(NSNumber*)I;
-(BOOL)simulate:(NSNumber*)I regSpike:(BOOL)RS withA:(NSNumber*)A B:(NSNumber*)B C:(NSNumber*)C D:(NSNumber*)D;
-(void)reset:(NSNumber*)B;
-(BOOL)simulate:(NSNumber*)I withType:(NSString*)type;




@end
