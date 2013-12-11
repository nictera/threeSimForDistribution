//
//  neuron.m
//  sim
//
//  Created by Teresa on 10/10/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "neuron.h"

@implementation neuron



-(neuron*) initWithFilename : (NSString*)fileName
{
    self = [super init];
    
    [self loadParams:fileName];
    
    return self;
}




#pragma mark - variable management


- (void) loadParams : (NSString*)fileName
{
    
    
    //get the path to the QAInfo.plist file
    NSString* plistPath = [fileUtilities path2file:fileName];
    
    
    if (plistPath){
        //load params
        [self loadData:fileName];
        
        _appI = [vars objectForKey:@"i"];
        _a = [vars objectForKey:@"a"];
        _b = [vars objectForKey:@"b"];
        _c = [vars objectForKey:@"c"];
        _d = [vars objectForKey:@"d"];
        NSNumber *val = [vars objectForKey:@"rs"];
        _rs = [val boolValue];
        
        
    } else {
        
        //set params
        _appI = [NSNumber numberWithFloat:5.0];
        _rs = YES;//an RS neuron
        _a = [NSNumber numberWithFloat:0.02];
        _b = [NSNumber numberWithFloat:0.2];
        _c = [NSNumber numberWithFloat:-65];//mV
        _d = [NSNumber numberWithFloat:8];
        
        //save simulation parameters
        [self saveData : fileName];

    }
    
        
}// end loadParams

- (void) changeParams : (NSMutableDictionary*)params withFilename :(NSString*)fileName
{
    
    //changeParams
    _appI = [params objectForKey:@"i"];
    _a = [params objectForKey:@"a"];
    _b = [params objectForKey:@"b"];
    _c = [params objectForKey:@"c"];
    _d = [params objectForKey:@"d"];
    NSNumber *val = [params objectForKey:@"rs"];
    _rs = [val boolValue];
    
    //save Params
    [self saveData:fileName];
    
}//end changeParams



#pragma mark - file methods


- (void)saveData : (NSString*)fileName
{
    
    //get the path to the plist file
    NSString* savePath = [fileUtilities path2SaveFile:fileName];
    
    
    //make and load dictionary
    vars = [[NSMutableDictionary alloc] init];
    
    [vars setValue:_appI forKey:@"i"];
    [vars setValue:_a forKey:@"a"];
    [vars setValue:_b forKey:@"b"];
    [vars setValue:_c forKey:@"c"];
    [vars setValue:_d forKey:@"d"];
    NSString * booleanString = (_rs) ? @"YES" : @"NO";
    [vars setValue:booleanString forKey:@"rs"];
    
    
    //write to file
    [vars writeToFile:savePath atomically:NO];
    
}// end saveData


- (NSMutableDictionary*) loadData  : (NSString*)fileName
{
    
    //get the path to the QAInfo.plist file
    NSString* plistPath = [fileUtilities path2file:fileName];
    
    
    if (plistPath){
        
        //load the dictionary file
        vars = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        
    } 
    
    return vars;//dictionary was loaded
    
}//end loadData

#pragma mark - reset


- (void) resetData  : (NSString*)fileName
{
    
    //initialize simulation parameters
    _appI = [NSNumber numberWithFloat:5.0];
    _rs = YES;//an RS neuron
    _a = [NSNumber numberWithFloat:0.02];
    _b = [NSNumber numberWithFloat:0.2];
    _c = [NSNumber numberWithFloat:-65];//mV
    _d = [NSNumber numberWithFloat:8];
    
    //save simulation parameters
    [self saveData : fileName];
    
    
}//end resetAdaptive


@end
