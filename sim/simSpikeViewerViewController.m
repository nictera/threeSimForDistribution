//
//  simSpikeViewerViewController.m
//  sim
//
//  Created by Teresa on 10/6/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import "simSpikeViewerViewController.h"

@interface simSpikeViewerViewController ()

@end

@implementation simSpikeViewerViewController

NSArray* spikes;
int ind;
NSTimer* spikeTimer;
int total;
float stretchFactor;
float oldstretchFactor;
NSMutableDictionary* infoDict;

/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }*/

#pragma mark - adminstrative stuff

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //take this out when implement controls
    sound = YES;
    
    //AUDIO
    
    // Create the URL for the source audio file. The URLForResource:withExtension: method is
    //    new in iOS 4.0.
    NSURL *sound1   = [[NSBundle mainBundle] URLForResource: @"high"
                                                withExtension: @"mp3"];
    NSURL *sound2   = [[NSBundle mainBundle] URLForResource: @"middle"
                                                  withExtension: @"mp3"];
    NSURL *sound3   = [[NSBundle mainBundle] URLForResource: @"lowG"
                                              withExtension: @"mp3"];
    // Store the URL as a CFURLRef instance
    sound1FileURLRef = (CFURLRef) CFBridgingRetain(sound1);
    sound2FileURLRef = (CFURLRef) CFBridgingRetain(sound2);
    sound3FileURLRef = (CFURLRef) CFBridgingRetain(sound3);

    
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      sound1FileURLRef,
                                      &sound1FileObject
                                      );
    AudioServicesCreateSystemSoundID (
                                      sound2FileURLRef,
                                      &sound2FileObject
                                      );
    AudioServicesCreateSystemSoundID (
                                      sound3FileURLRef,
                                      &sound3FileObject
                                      );

    
    
    
}//end viewDidLoad

- (void) viewWillAppear:(BOOL)animated
{
    //need to find out if being sent from circuit view controller - see if there are spikes there to pick up
    
    //get the spikes from the circuit view controller
    spikes = [simCircuitViewController getSpikes];
    
    //initialize stretchFactor
    stretchFactor = 100;
    oldstretchFactor = stretchFactor;
    [_stretchFactorLabel setText:[[NSNumber numberWithFloat:stretchFactor] stringValue]];

    
    if ((spikes != nil) && ([spikes count] > 0)) {

        //show spikes
        [self showSpikes];
        
        
    } else {

        
        //load data from plist file
        int status = [self loadData];
        
        
        //if data exist, alert user
        if (status == 0) {//spikes were loaded
            
            //alert to give user option to replay last simulation
            //see alertView below
            UIAlertView* replayAlert = [[UIAlertView alloc] initWithTitle:@"Simulation exists" message:@"Would you like to replay the previous simulation?" delegate: self cancelButtonTitle:@"No" otherButtonTitles:@"Yes, replay", nil];
            
            [replayAlert show];
        } else {
            [self resetSimulator];
        }
        
    }
        
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    //save data to plist file
    [self saveData];
    
    //reset
    [self resetSimulator];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}//end idReceiveMemoryWarning

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //NSLog(@"Clicked button at index: %ld", (long)buttonIndex);
    
    
    if (buttonIndex == 1) {//yes, replay previous
        
        [spikeTimer invalidate];
        [self showSpikes];
        
    } else {
        [spikeTimer invalidate];
    }
    
    
    
}//end alertView clickedButtonAtIndex

#pragma mark - reset

- (void) resetSimulator
{
    //get rid of spikes in simCircuit...
    [simCircuitViewController deleteSpikes];
    
    //reset knobs and readouts
    stretchFactor = 100;
    oldstretchFactor = stretchFactor;
    [_stretchFactorLabel setText:[[NSNumber numberWithFloat:stretchFactor] stringValue]];
    [_sliderReadOut setValue:100];
    
    //kill timer
    [spikeTimer invalidate];
    
    
    
}

#pragma mark - show spikes

- (void) showSpikes
{
    
    
    total = (int)[[spikes objectAtIndex:0] count];
    ind = 0;
    
    
    //start timer
    spikeTimer = [NSTimer scheduledTimerWithTimeInterval:(0.001*stretchFactor) target:self selector:@selector(changeButton) userInfo:nil repeats:YES];
    
    
    
}

- (void) changeButton
{
    //NSLog(@"changeButton");
    
    //prep for text spike trains
    NSIndexSet* range;
    int displaySpikeNum = 47;
    NSUInteger len;
    NSUInteger loc;
    NSString* spikeTrain1;
    NSString* spikeTrain2;
    NSString* spikeTrain3;

    //get text spike trains
    NSMutableArray* s1 = [spikes objectAtIndex:0];
    NSMutableArray* s2 = [spikes objectAtIndex:1];
    NSMutableArray* s3 = [spikes objectAtIndex:2];
    
    
    //set images
    NSMutableArray* rest = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed: @"Neuron-1rest.png"],[UIImage imageNamed: @"Neuron-2rest.png"], [UIImage imageNamed: @"Neuron-3rest.png"], nil];
    NSMutableArray* active = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed: @"Neuron-1active.png"],[UIImage imageNamed: @"Neuron-2active.png"], [UIImage imageNamed: @"Neuron-3active.png"], nil];
    NSMutableArray* imageViewers = [[NSMutableArray alloc] initWithObjects: _neuron1, _neuron2, _neuron3, nil];
    
    
    for (int i=0; i<3; i++) {
        
        //set the spike labels
        //get the range
        if (ind - displaySpikeNum < 0) {
            loc = 0;
            len = ind;
        } else {
            loc = (NSUInteger)(ind - displaySpikeNum);
            len = displaySpikeNum;
        }
        range = [ NSIndexSet indexSetWithIndexesInRange: NSMakeRange(loc, len)];
        
        //neuron 1 text spike train
        spikeTrain1 = [self array2String:(NSMutableArray*)[s1 objectsAtIndexes:range]];
        spikeTrain1 = [spikeTrain1 stringByReplacingOccurrencesOfString:@"0" withString:@"."];
        spikeTrain1 = [spikeTrain1 stringByReplacingOccurrencesOfString:@"1" withString:@"|"];
        [_n1Spikes setText: spikeTrain1];
        
        //neuron 2 text spike train
        spikeTrain2 = [self array2String:(NSMutableArray*)[s2 objectsAtIndexes:range]];
        spikeTrain2 = [spikeTrain2 stringByReplacingOccurrencesOfString:@"0" withString:@"."];
        spikeTrain2 = [spikeTrain2 stringByReplacingOccurrencesOfString:@"1" withString:@"|"];
        [_n2Spikes setText: spikeTrain2];
        
        //neuron 3 text spike train
        spikeTrain3 = [self array2String:(NSMutableArray*)[s3 objectsAtIndexes:range]];
        spikeTrain3 = [spikeTrain3 stringByReplacingOccurrencesOfString:@"0" withString:@"."];
        spikeTrain3 = [spikeTrain3 stringByReplacingOccurrencesOfString:@"1" withString:@"|"];
        [_n3Spikes setText: spikeTrain3];

        
        if ([[[spikes objectAtIndex:i] objectAtIndex:ind] intValue] == 1) {
            //make neuron orange
            [imageViewers[i] setImage:active[i]];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"play_sounds_preference"]) {
                //AUDIO
                switch (i) {
                    case 0:
                    {
                        AudioServicesPlaySystemSound (sound1FileObject);
                        break;
                    }
                    case 1:
                    {
                        AudioServicesPlaySystemSound (sound2FileObject);
                        break;
                    }
                    case 2:
                    {
                        AudioServicesPlaySystemSound (sound3FileObject);
                        break;
                    }
                        
                    default:
                        break;
                }

                
            }
            
        } else {
            //make neuron gray
            [imageViewers[i] setImage:rest[i]];
            
        }
        
        
    }
    
    
    
    //increment index for arrays
    ind++;
    
    
    //if at end of array, invalidate timer
    if (ind == total-1) {
        [spikeTimer invalidate];
    }
    
    if (stretchFactor != oldstretchFactor) {
        
        
        //reset oldstretchFactor
        oldstretchFactor = stretchFactor;
        
        //kill timer
        [spikeTimer invalidate];
        
        //restart timer with new stretchFactor
        spikeTimer = [NSTimer scheduledTimerWithTimeInterval:(0.001*stretchFactor) target:self selector:@selector(changeButton) userInfo:nil repeats:YES];
    }
    
}//end changeButton





- (NSMutableString*)array2String : (NSMutableArray*)array
{
    NSMutableString* spikeTrain = [[NSMutableString alloc] init];
    
    for (int i = 0; i< [array count]; i++) {
        [spikeTrain appendString:[[array objectAtIndex:i] stringValue]];
    }
    
    return spikeTrain;
}


#pragma mark - buttons and sliders

- (IBAction)stretchFactorSlider:(UISlider *)sender {
    
    stretchFactor = [sender value] ;
    
    [_stretchFactorLabel setText:[[NSNumber numberWithFloat:stretchFactor] stringValue]];
    
}



- (IBAction)play:(UIButton *)sender {
    
    if (spikeTimer) {
        //kill current timer
        [spikeTimer invalidate];
    }
    
    if (ind<total-1) {
        //restart timer with new stretchFactor
        spikeTimer = [NSTimer scheduledTimerWithTimeInterval:(0.001*stretchFactor) target:self selector:@selector(changeButton) userInfo:nil repeats:YES];
    } else {
        [self showSpikes];
    }
    
    
}

- (IBAction)pause:(UIButton *)sender {
    
    //kill timer
    [spikeTimer invalidate];
    
    
}

- (IBAction)replay:(id)sender {
    
    //kill timer in case user wants to start from beginning
    [spikeTimer invalidate];
    
    //start again
    [self showSpikes];
}

#pragma mark - saving/loading data

- (void)saveData
{
    
    //get the path to the plist file
    NSString* savePath = [fileUtilities path2SaveFile:@"simData"];
    
    //write to file
   [spikes writeToFile:savePath atomically:NO];
    
}// end saveAdaptive


- (int) loadData
{
    
    //get the path to the QAInfo.plist file
    NSString* plistPath = [fileUtilities path2file:@"simData"];

    
    if (plistPath){
        
        //load the dictionary file
        spikes = [NSArray arrayWithContentsOfFile:plistPath];
        
    } else {
        return -1;//no spikes were loaded
    }
    
    if ((spikes == nil) || ([spikes count]<2)) {
        return -1;
    }
    
    
    return 0;//spikes were loaded
    
}//end loadAdaptive

#pragma reset and close the database


+ (void) resetData
{
    
    //NSLog(@"Resetting adaptive");
    
    //reinitialize dictionary
    spikes = [[NSArray alloc] init];
    //get the path to the plist file
    NSString* plistPath = [fileUtilities path2file:@"simData"];
    
    if (plistPath){
        //NSLog(@"Saving adaptive");
        //overwrite file
        //write to file
        [spikes writeToFile:plistPath atomically:NO];
    }
    
}//end resetAdaptive
@end
