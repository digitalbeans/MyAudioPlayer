//
//  ViewController.h
//  MyAudioPlayer
//
//  Created by Dean Thibault on 8/17/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet AudioPlayer *audioPlayer;

@end

