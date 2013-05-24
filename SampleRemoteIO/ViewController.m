//
//  ViewController.m
//  SampleRemoteIO
//
//  Created by takeda on 13/05/19.
//  Copyright (c) 2013年 takeda. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    remoteOutput = [[RemoteOutput alloc] init];
    
    // 前進ボタンの生成
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goBtn.frame = CGRectMake(30, 100, 100, 30);
    [goBtn setTitle:@"Go" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBtn];
    
    
    // 停止ボタンの生成
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopBtn.frame = CGRectMake(180, 100, 100, 30);
    [stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma private
-(void)play:(id)sender{
    [remoteOutput play];
}
-(void)stop:(id)sender{
    [remoteOutput stop];
}

- (void)dealloc {
    [remoteOutput release];
    [super dealloc];
}
@end
