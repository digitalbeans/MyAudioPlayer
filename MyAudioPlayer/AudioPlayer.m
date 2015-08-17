//
//  AudioPlayer.m
//  iAccord
//
//  Created by Dean Thibault on 8/17/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

static void *statusContext = &statusContext;

@implementation AudioPlayer

@synthesize toolbar, player, timeSlider, updateTimer, duration, timeElapsed, closeButton, sliderViewButton;
@synthesize didSetDuration;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void) commonInit
{
		toolbar = [[UIToolbar alloc] init];
		[toolbar setBackgroundColor:[UIColor clearColor]];
		[toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
		[toolbar setItems:[self playerButtons:false]];
		[self addSubview:toolbar];
		
		[self.toolbar setTranslatesAutoresizingMaskIntoConstraints:false];
		
		NSDictionary *viewsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:toolbar, @"toolbar", nil];
		NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat: @"V:[toolbar]|"
														options:0
														metrics:nil
														views:viewsDictionary];
		[self addConstraints:constraint_POS_V];
					
		NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[toolbar]|"
														options:0
														metrics:nil
														views:viewsDictionary];

		[self addConstraints:constraint_POS_H];
		NSLayoutConstraint *audPlayerHeightConstraint = [NSLayoutConstraint constraintWithItem:toolbar
																			attribute:NSLayoutAttributeHeight
																			relatedBy:NSLayoutRelationEqual
																			toItem:nil
																			attribute:NSLayoutAttributeHeight multiplier:1
																			constant:44];
		
		[self addConstraint:audPlayerHeightConstraint];

}

-(IBAction)sliderAction:(UISlider *)sender
{
	[player.currentItem seekToTime: CMTimeMake(self.timeSlider.value, 1)];
	self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self timeFormat:CMTimeGetSeconds(self.player.currentItem.duration)]];
	
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self timeFormat:CMTimeGetSeconds(self.player.currentItem.duration) - CMTimeGetSeconds(self.player.currentItem.currentTime)]];
}

- (void)updateTimeSlider
{
	if ((!didSetDuration) && ([player status] == AVPlayerStatusReadyToPlay)){
			if (CMTimeGetSeconds(player.currentItem.duration) >0) {
				self.timeSlider.maximumValue = CMTimeGetSeconds(player.currentItem.duration);
				self.didSetDuration = YES;
			}
	}
	float progress = CMTimeGetSeconds(self.player.currentItem.currentTime);
	[self.timeSlider setValue:progress];
	
	self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self timeFormat:CMTimeGetSeconds(self.player.currentItem.currentTime)]];
	
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self timeFormat:CMTimeGetSeconds(self.player.currentItem.duration) - CMTimeGetSeconds(self.player.currentItem.currentTime)]];
	
}

- (NSArray *)playerButtons:(Boolean) isPlaying
{
	if (!sliderViewButton) {
		CGRect labelFrame = CGRectMake(0, 3, 40, 30);
		timeElapsed = [[UILabel alloc] initWithFrame:labelFrame];
		[timeElapsed setFont:[UIFont systemFontOfSize:9]];
		[timeElapsed setText:@("0:0")];
		
		CGRect sliderFrame = CGRectMake(labelFrame.size.width -10, 5, 100, 25);
		timeSlider = [[UISlider alloc] initWithFrame:sliderFrame];
		[timeSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
		
		labelFrame = CGRectMake(sliderFrame.origin.x + sliderFrame.size.width +5, 3, 40, 30);
		duration = [[UILabel alloc] initWithFrame:labelFrame];
		[duration setFont:[UIFont systemFontOfSize:9]];
		[duration setText:@("0:0")];
		
		CGRect sliderViewFrame = CGRectMake(0, 0, labelFrame.size.width *2 + sliderFrame.size.width +10, 30);
		UIView *sliderView = [[UIView alloc] initWithFrame:sliderViewFrame];
		[sliderView addSubview: timeElapsed];
		[sliderView addSubview:timeSlider];
		[sliderView addSubview:duration];
		
		sliderViewButton = [[UIBarButtonItem alloc] initWithCustomView:sliderView];

	}
	
	


	NSArray *buttonArray = nil;
	if (isPlaying) {
		buttonArray = [NSArray arrayWithObjects:
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action:nil],
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRewind target: self action:@selector(doRewind:)],
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPause target: self action:@selector(doPause:)],
					   sliderViewButton,
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(doStop:)],
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action:nil],
					   nil ];
	} else {
		buttonArray = [NSArray arrayWithObjects:
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action:nil],
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRewind target: self action:@selector(doRewind:)],
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPlay target: self action:@selector(doPlay:)],
					   sliderViewButton,
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(doStop:)],
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action:nil],
					   nil ];
		
	}
	
	return buttonArray;
}

-(IBAction)doRewind:(id)sender
{
	[player.currentItem seekToTime:CMTimeMake(0, 1)];
	
	self.timeElapsed.text = @"0:00";
	
	self.duration.text = [NSString stringWithFormat:@"-%@",
						  [self timeFormat:CMTimeGetSeconds(self.player.currentItem.duration)]];
	
	[self.timeSlider setValue:0];
}

-(IBAction)doPause:(id)sender
{
	[player pause];
	[toolbar setItems:[self playerButtons:false]];
	
	[updateTimer invalidate];
}

-(IBAction)doPlay:(id)sender
{
	[player play];
	[toolbar setItems:[self playerButtons:true]];
	
	self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeSlider) userInfo:nil repeats:YES];
}

-(void) playAudioFileAtURL:(NSURL *) inURL
{
	if (player) {
		@try{
		   [player removeObserver:self forKeyPath:@"status"];
		}@catch(id anException){
		   //do nothing, obviously it wasn't attached because an exception was thrown
		}
	}
	player = [[AVPlayer alloc] initWithURL:inURL];

	if (player)
	{
		[player addObserver:self forKeyPath:@"status" options:0 context:statusContext];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];

		[self.timeSlider setValue:0];

		self.timeSlider.minimumValue = 0;
		
		self.timeElapsed.text = @"0:00";
		
		self.duration.text = @"0:00";
		
		self.didSetDuration = NO;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
 
    if (context == statusContext) {
        AVPlayer *thePlayer = (AVPlayer *)object;
        if ([thePlayer status] == AVPlayerStatusFailed) {
            NSError *error = [thePlayer error];
            // Respond to error: for example, display an alert sheet.
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Playback Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
            return;
        } else if ([thePlayer status] == AVPlayerStatusReadyToPlay){
			if (CMTimeGetSeconds(thePlayer.currentItem.duration) >0) {
				self.timeSlider.maximumValue = CMTimeGetSeconds(thePlayer.currentItem.duration);
				self.didSetDuration = YES;
			}
			[self doPlay:self];
		}
		if (player) {
			@try{
			   [player removeObserver:self forKeyPath:@"status"];
			}@catch(id anException){
			   //do nothing, obviously it wasn't attached because an exception was thrown
			}
		}
		
        // Deal with other status change if appropriate.
    }
}


-(void)itemDidFinishPlaying:(NSNotification *) notification
{
	[updateTimer invalidate];
	
	[toolbar setItems:[self playerButtons:false]];
	
	[self doRewind:self];
	
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	[toolbar setItems:[self playerButtons:false]];
	
	[updateTimer invalidate];
}


-(NSString*)timeFormat:(float)value{
	
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
	
    long roundedSeconds = lroundf(seconds);
    long roundedMinutes = lroundf(minutes);
	
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%ld:%02ld",
                      roundedMinutes, roundedSeconds];
    return time;
}

-(IBAction)doStop:(id)sender
{
	[self doPause:self];
	// Enable this if you want the player to be dismissed
//	if (player) {
//		@try{
//		   [player removeObserver:self forKeyPath:@"status"];
//		}@catch(id anException){
//		   //do nothing, obviously it wasn't attached because an exception was thrown
//		}
//	}
}

- (Boolean)playing
{
	return player.rate != 0;
}

@end
