//
//  simCircuitViewController.h
//  sim
//
//  Created by Teresa on 10/5/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simNetwork.h"
#import "simSpikeViewerViewController.h"
#import "simFirstViewController.h"
#import "simSecondViewController.h"
#import "simThirdViewController.h"
#import "simPrefabViewController.h"


@interface simCircuitViewController : UIViewController


#pragma mark - variables

@property (strong, nonatomic) NSNumber *peak1;
@property (strong, nonatomic) NSNumber *tau1;
@property (strong, nonatomic) NSNumber *peak2;
@property (strong, nonatomic) NSNumber *tau2;
@property (strong, nonatomic) NSNumber *stimTime;
@property (strong, nonatomic) NSNumber *randMax;



#pragma mark - spike train outputs

@property (weak, nonatomic) IBOutlet UILabel *spikeTrain1;
@property (weak, nonatomic) IBOutlet UILabel *spikeTrain2;
@property (weak, nonatomic) IBOutlet UILabel *postSpikeTrain;


#pragma mark - synaptic weight readout

@property (weak, nonatomic) IBOutlet UILabel *peak1Label;
@property (weak, nonatomic) IBOutlet UILabel *tau1Label;
@property (weak, nonatomic) IBOutlet UILabel *peak2Label;
@property (weak, nonatomic) IBOutlet UILabel *tau2Label;
@property (weak, nonatomic) IBOutlet UILabel *stimTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *randMaxLabel;

#pragma mark - simulation methods

- (IBAction)runSimulation:(UIButton *)sender;

#pragma mark - vary synaptic parameters

- (IBAction)peak1Slider:(UISlider *)sender;

- (IBAction)tau1Slider:(UISlider *)sender;

- (IBAction)peak2Slider:(UISlider *)sender;

- (IBAction)tau2Slider:(UISlider *)sender;

- (IBAction)stimTimeSlider:(UISlider *)sender;

- (IBAction)randMaxSlider:(UISlider *)sender;

//sliders outlets for resetting
@property (weak, nonatomic) IBOutlet UISlider *slider1peak;
@property (weak, nonatomic) IBOutlet UISlider *slider1time;
@property (weak, nonatomic) IBOutlet UISlider *slider2peak;
@property (weak, nonatomic) IBOutlet UISlider *slider2time;
@property (weak, nonatomic) IBOutlet UISlider *sliderSimTime;
@property (weak, nonatomic) IBOutlet UISlider *sliderRandMax;


#pragma mark - output spikes

+ (NSMutableArray*)getSpikes;
+ (void) deleteSpikes;

#pragma mark - reset
- (IBAction)reset:(UIButton *)sender;
//- (void)viewWillTerminate;//called by app delegate when program terminating

@end
