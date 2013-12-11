//
//  neuron.h
//  sim
//
//  Created by Teresa on 10/10/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "simNeuron.h"
#import "fileUtilities.h"

@interface neuron : NSObject
{ //instance vars
    
    //variable storage dictionary
    NSMutableDictionary*  vars;

}

@property (strong, nonatomic) NSMutableString* spikeTrain;
@property (weak, nonatomic) IBOutlet UILabel *spikeLabel;
@property (strong, nonatomic) NSNumber *appI;
@property (strong, nonatomic) NSNumber* a;//timescale of u, recovery variable
@property (strong, nonatomic) NSNumber* b;//sensitivity of u to v
@property (strong, nonatomic) NSNumber* c;//after spike reset value of v, membrane potential
@property (strong, nonatomic) NSNumber* d;//after spike reset increment of u
@property (nonatomic) BOOL rs;//if the neuron is regular spiking, the equation constants slightly differ

#pragma mark - instance methods

-(neuron*) initWithFilename : (NSString*)fileName;
- (NSMutableDictionary*) loadData  : (NSString*)fileName;
- (void) changeParams : (NSMutableDictionary*)params withFilename :(NSString*)fileName;
- (void) resetData  : (NSString*)fileName;

@end
