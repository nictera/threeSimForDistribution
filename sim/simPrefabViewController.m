//
//  simPrefabViewController.m
//  sim
//
//  Created by Teresa on 10/11/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "simPrefabViewController.h"

@interface simPrefabViewController ()

@end

@implementation simPrefabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //initialize simNeuron array
    n = [[NSMutableArray alloc] init];
    
    //initialize neuron property array
    props = [[NSMutableArray alloc] init];
    
    //initialize neuron types array
    types = [[NSMutableArray alloc] init];
    
    //initialize neuron type indices array
    typeInds = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        [typeInds addObject:[NSNumber numberWithInt:0]];
    }
    
    [self loadData];
    
    //get the type indices
    [_segControl1Outlet setSelectedSegmentIndex:[typeInds[0] intValue]];
    [_segControl2Outlet setSelectedSegmentIndex:[typeInds[1] intValue]];
    [_segControl3Outlet setSelectedSegmentIndex:[typeInds[2] intValue]];

    
    //initialize the filenames
    fileNames = [[NSArray alloc] initWithObjects:@"n1", @"n2", @"n3", nil];
    
    //initialize the neurons
     //initialize the simulation
    for (int i=0; i<3; i++) {
        n[i] = [[simNeuron alloc] init];
        props[i] = [[neuron alloc] initWithFilename:fileNames[i]];
        types[i] = @"RS";
    }
    
    //initialize the labels that will show spiketrains
    spikeLabels = [[NSMutableArray alloc] init];
    spikeLabels[0] = _spikeTrain1;
    spikeLabels[1] = _spikeTrain2;
    spikeLabels[2] = _spikeTrain3;
    
    //current to be injected
    _appI = [NSNumber numberWithInt:10];
    

    
}//end viewDidLoad

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [self loadData];
    
    //get the type indices
    [_segControl1Outlet setSelectedSegmentIndex:[typeInds[0] intValue]];
    [_segControl2Outlet setSelectedSegmentIndex:[typeInds[1] intValue]];
    [_segControl3Outlet setSelectedSegmentIndex:[typeInds[2] intValue]];

}

- (void) viewWillDisappear:(BOOL)animated
{
    
    //[self saveData];
}

#pragma mark - save/load data

- (void)saveData
{
    
    //get the path to the plist file
    NSString* savePath = [fileUtilities path2SaveFile:@"preFabs"];
    
    
    //make and load dictionary
    NSMutableDictionary* vars = [[NSMutableDictionary alloc] init];
        
    [vars setValue:typeInds[0] forKey:@"n1"];
    [vars setValue:typeInds[1] forKey:@"n2"];
    [vars setValue:typeInds[2] forKey:@"n3"];
        
    //write to file
    [vars writeToFile:savePath atomically:NO];
    
}// end saveData

- (void)loadData
{
    
    //get the path to the QAInfo.plist file
    NSString* plistPath = [fileUtilities path2file:@"preFabs"];
    
    if (plistPath){
        
        //load the dictionary file
        NSMutableDictionary* vars = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        
        if ([vars objectForKey:@"n1"])
        {

        typeInds[0]= [vars objectForKey:@"n1"];
        typeInds[1]= [vars objectForKey:@"n2"];
        typeInds[2]= [vars objectForKey:@"n3"];
        }
        
    }
    
    

}

- (void)clearData
{

    typeInds = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        [typeInds addObject:[NSNumber numberWithInt:0]];
    }

    [self saveData];

}

#pragma mark - simulation and saving methods

- (IBAction)runSim:(NSInteger)neuronIndex {

    
    BOOL s;
    
    NSMutableString* spikeTrain = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i<70; i++) {
        //NSLog(@"_appI is %@", _appI);
        s = [n[neuronIndex] simulate:_appI withType:types[neuronIndex]];
        if (s)
        {
            //NSLog(@"s is %hhd", s);
            [spikeTrain appendString:@"|"];
            
        } else {
            [spikeTrain appendString:@"."];
        }
        
        
    }
    
    //NSLog(@"Iapp = %@", _appI);
    
    
    //set spike label to text string
    [spikeLabels[neuronIndex] setText:spikeTrain];
    [spikeLabels[neuronIndex] setTextColor:[UIColor blackColor]];
    
    
    //save variable data for circuit simulation
    //[self saveData:neuronIndex ];
    
    
}//end runSim



#pragma mark - buttons & sliders

//preFab selector methods change the properties of selected neurons
- (IBAction)preFab1:(UISegmentedControl *)sender {
    
    [self setNeuron:sender :0 ];

}

- (IBAction)preFab2:(UISegmentedControl *)sender {
    
    [self setNeuron:sender :1 ];
}

- (IBAction)preFab3:(UISegmentedControl *)sender {
    
    [self setNeuron:sender :2 ];
}

//switch case to get correct type string and initialize neuron
- (void) setNeuron : (UISegmentedControl *)sender : (NSInteger)neuronIndex
{
    NSString* type;
    //save the index for saving to refresh view when it reappears
    typeInds[neuronIndex] = [NSNumber numberWithInteger:[sender selectedSegmentIndex]];
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            type = @"RS";
            break;
        case 1:
            type = @"IB";
            break;
        case 2:
            type = @"CH";
            break;
        case 3:
            type = @"TC";
            break;
        case 4:
            type = @"RZ";
            break;
        case 5:
            type = @"FS";
            break;
        case 6:
            type = @"LTS";
            break;
        case 7:
            type = @"CC";
            break;
            
        default:
            break;
    }
    
    //initialize proper neuron type
    [ n[neuronIndex] resetVars:type withFilename:fileNames[neuronIndex] ];
    
    [self saveData];
    
    //NSLog(@"setNeuron - n[neuronIndex]: %@, type: %@, neuronIndex: %ld, fileNames[neuronIndex]: %@, success: %hhd", n[neuronIndex],type, (long)neuronIndex, fileNames[neuronIndex], success);
    
    //save
    //[self saveData:neuronIndex];
}



//run simulation on selected neuron
- (IBAction)runSim1:(UIButton *)sender {

    [self runSim:0];
    
}

- (IBAction)runSim2:(UIButton *)sender {
    
    [self runSim:1];
    
}

- (IBAction)runSim3:(UIButton *)sender {
    
    [self runSim:2];
    
}

#pragma mark - reset segControls

- (void) resetSegControls
{
    [_segControl1Outlet setSelectedSegmentIndex:0];
    [_segControl2Outlet setSelectedSegmentIndex:0];
    [_segControl3Outlet setSelectedSegmentIndex:0];
    
    [self clearData];//resets and clears data in file
    
    
}



@end
