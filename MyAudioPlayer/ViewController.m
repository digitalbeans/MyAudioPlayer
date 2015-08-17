//
//  ViewController.m
//  MyAudioPlayer
//
//  Created by Dean Thibault on 8/17/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.audioPlayer playAudioFileAtURL:[NSURL URLWithString:@"http://deanthibault@www.blackberrytutor.info/digitalbeans/music/Daily%20Beetle.mp3"]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
