//
//  simSpikeViewerViewController.h
//  sim
//
//  Created by Teresa on 10/6/13.
//  Copyright (c) 2013 disynaptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simCircuitViewController.h"
#import "fileUtilities.h"
#import <AudioToolbox/AudioToolbox.h>


@interface simSpikeViewerViewController : UIViewController
{
    //AUDIO - from Apple Audio UI Sounds (SysSound)
    CFURLRef        sound1FileURLRef;
    SystemSoundID   sound1FileObject;
    CFURLRef        sound2FileURLRef;
    SystemSoundID   sound2FileObject;
    CFURLRef        sound3FileURLRef;
    SystemSoundID   sound3FileObject;
    BOOL            sound;

}

@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIImageView *neuron1;
@property (weak, nonatomic) IBOutlet UIImageView *neuron2;
@property (weak, nonatomic) IBOutlet UIImageView *neuron3;
@property (weak, nonatomic) IBOutlet UILabel *stretchFactorLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderReadOut;
@property (weak, nonatomic) IBOutlet UILabel *n1Spikes;
@property (weak, nonatomic) IBOutlet UILabel *n2Spikes;
@property (weak, nonatomic) IBOutlet UILabel *n3Spikes;

- (IBAction)stretchFactorSlider:(UISlider *)sender;
- (IBAction)play:(UIButton *)sender;
- (IBAction)pause:(UIButton *)sender;
- (IBAction)replay:(id)sender;

//class method to enable simCircuitView to reset
+ (void) resetData;

@end
