//
//  simNetwork.h
//  sim
//
//  Created by Teresa on 10/6/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "simFirstViewController.h"
#import "simSecondViewController.h"
#import "simThirdViewController.h"
#import <stdlib.h>


@interface simNetwork : NSObject
{
    simFirstViewController* VC1;
    simSecondViewController* VC2;
    simThirdViewController* VC3;
}


-(NSMutableArray*)simulateNetwork:(NSMutableDictionary*)synVars;

@end
