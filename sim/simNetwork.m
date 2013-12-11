//
//  simNetwork.m
//  sim
//
//  Created by Teresa on 10/6/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "simNetwork.h"


@implementation simNetwork


-(simNetwork*)init
{
    self = [super init];
    
    return self;
}




-(NSMutableArray*)simulateNetwork:(NSMutableDictionary*)synVars
{
    
    
    
    //synaptic propoerties and simulation time provided in call from simCircuitViewController
    NSNumber* stimTime = [synVars valueForKey:@"stimTime"];
    NSNumber* p1 = [synVars valueForKey:@"peak1"];
    NSNumber* t1 = [synVars valueForKey:@"tau1"];
    NSNumber* p2 = [synVars valueForKey:@"peak2"];
    NSNumber* t2 = [synVars valueForKey:@"tau2"];
    //random synaptic activity max
    NSNumber* randomMax = [synVars valueForKey:@"randMax"];

  
    NSMutableArray* spikes1 = [[NSMutableArray alloc] init];
    NSMutableArray* spikes2 = [[NSMutableArray alloc] init];
    NSMutableArray* spikes3 = [[NSMutableArray alloc] init];

    NSMutableArray* spikes = [[NSMutableArray alloc] init];


    
    //get cellular properties from neuronal viewControllers
    //neuron 1 (presyn)
    VC1 = [[simFirstViewController alloc] init];
    NSMutableDictionary* props1 =  [VC1 neurProps];
        BOOL rs1 = ([[props1 objectForKey:@"rs"]  isEqual: @"YES"]) ? YES: NO;

    //neuron 2 (presyn)
    VC2 = [[simSecondViewController alloc] init];
    NSMutableDictionary* props2 =  [VC2 neurProps];
    BOOL rs2 = ([[props2 objectForKey:@"rs"]  isEqual: @"YES"]) ? YES: NO;
    
    //neuron 3 (postsyn)
    VC3 = [[simThirdViewController alloc] init];
    NSMutableDictionary* props3 =  [VC3 neurProps];
    BOOL rs3 = ([[props3 objectForKey:@"rs"]  isEqual: @"YES"]) ? YES: NO;
    
    //create neurons
    simNeuron* n1 = [[simNeuron alloc] init];
    simNeuron* n2 = [[simNeuron alloc] init];
    simNeuron* n3 = [[simNeuron alloc] init];
    
    //create spike parameters
    BOOL s1 = 0;
    BOOL s2 = 0;
    BOOL s3 = 0;
    
    //currents
    NSNumber* i1;
    NSNumber* i2;
    NSNumber* i3;
    
    //syn currents
    // NSNumber* si1 = [NSNumber numberWithInt:0];
    //NSNumber* si2 = [NSNumber numberWithInt:0];
    float si1 = 0;
    float si2 = 0;
    
    //maximum random current
    int randMax = [randomMax intValue];
    
    //amount to change synaptic weights (peaks) with simultaneous firing
    //float weightFactor = 1.01;

    
    //for time of simulation, simulate
   for (int i = 0;  i < [stimTime floatValue]*1000; i++) {
       
       //get currents - i1,i2 - just random; i3 - random fluctuation plus synaptic currents
       i1 = [NSNumber numberWithFloat:arc4random() % randMax];
       i2 = [NSNumber numberWithFloat:arc4random() % randMax];
       //no random current for i3
       //i3 = [NSNumber numberWithFloat:arc4random() % randMax + si1 + si2];
       i3 = [NSNumber numberWithFloat:si1 + si2];
       
        //NSLog(@"si1: %f, si2: %f, i3: %@", si1, si2, i3);
       
       //run simulation for each neuron
       //-(BOOL)simulate:(NSNumber*)I regSpike:(BOOL)RS withA:(NSNumber*)A B:(NSNumber*)B C:(NSNumber*)C D:(NSNumber*)D;
       s1 = [n1 simulate:i1 regSpike:rs1 withA:[props1 objectForKey:@"a"] B:[props1 objectForKey:@"b"] C:[props1 objectForKey:@"c"] D:[props1 objectForKey:@"d"]];
       s2 = [n2 simulate:i2 regSpike:rs2 withA:[props2 objectForKey:@"a"] B:[props2 objectForKey:@"b"] C:[props2 objectForKey:@"c"] D:[props2 objectForKey:@"d"]];
       s3 = [n3 simulate:i3 regSpike:rs3 withA:[props3 objectForKey:@"a"] B:[props3 objectForKey:@"b"] C:[props3 objectForKey:@"c"] D:[props3 objectForKey:@"d"]];
       
       //degrade previous synpatic inputs by tau
       si1 = si1-(si1 * 1/[t1 floatValue]);
       si2 = si2-(si2 * 1/[t2 floatValue]);
       
       //NSLog(@"si1: %f, si2: %f", si1, si2);
       
       
       //save spiking info for next millisecond
       if (s1) {
           si1 = si1 + [p1 floatValue];
       }
       if (s2) {
           si2 = si2 + [p2 floatValue];
       }
       
       //check for maxSy
       si1 = [self maxSynapticCurrent:si1];
       si2 = [self maxSynapticCurrent:si2];

       
       /*
       //change syn weights according to simultaneous firing
       if (s1 && s3) {
           p1 = [NSNumber numberWithFloat:[p1 floatValue] * weightFactor];
       }
       if (s2 && s3) {
           p2 = [NSNumber numberWithFloat:[p1 floatValue] * weightFactor];
       }
        */
       
       //save spiking info for export

       [spikes1 addObject:[NSNumber numberWithBool:s1]];
       [spikes2 addObject:[NSNumber numberWithBool:s2]];
       [spikes3 addObject:[NSNumber numberWithBool:s3]];
       
       //NSLog(@"s1: %hhd, s2: %hhd, s3: %hhd", s1, s2, s3);

    }//end for
    //NSLog(@"spikes1: %@", [spikes1 objectAtIndex:0]);

    [spikes addObject:spikes1];
    [spikes addObject:spikes2];
    [spikes addObject:spikes3];
    
    //NSLog(@"spikes: %@", [[spikes objectAtIndex:1] objectAtIndex:0]);

    
    
    return spikes;
    
}//end simulateNetwork

-(int)maxSynapticCurrent:(int)si
{
    //maximum synaptic current from a cell
    int maxSyn = 50;


    if (si<maxSyn*-1) {
        si=maxSyn*-1;
    }
    
    if (si>maxSyn) {
        si=maxSyn;
    }
    
    return si;

}

@end
