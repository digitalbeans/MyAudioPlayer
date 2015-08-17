//
//  AudioPlayer.h
//  iAccord
//
//  Created by Dean Thibault on 8/17/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

IB_DESIGNABLE

@interface AudioPlayer : UIView <AVAudioPlayerDelegate>

@property (nonatomic, retain)IBOutlet AVPlayer* player;
@property (nonatomic, retain)IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain)IBOutlet UISlider* timeSlider;
@property (nonatomic, retain)IBOutlet NSTimer* updateTimer;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *timeElapsed;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sliderViewButton;
@property (nonatomic) Boolean didSetDuration;

-(IBAction)doRewind:(id)sender;
-(IBAction)doPause:(id)sender;
-(IBAction)doPlay:(id)sender;
-(IBAction)doStop:(id)sender;

-(IBAction)sliderAction:(UISlider *)sender;

- (id)initWithFrame:(CGRect)frame;
-(void) playAudioFileAtURL:(NSURL *) inURL;
- (NSString*)timeFormat:(float)value;
- (Boolean)playing;

@end
