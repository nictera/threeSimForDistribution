//
//  simNeuronUITableViewController.h
//  sim
//
//  Created by Teresa on 10/6/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simFirstViewController.h"
#import "simSecondViewController.h"
#import "simThirdViewController.h"  

@interface simNeuronUITableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSDictionary* neurons;
@property (nonatomic, strong) NSArray* neuronKeys;


@end
