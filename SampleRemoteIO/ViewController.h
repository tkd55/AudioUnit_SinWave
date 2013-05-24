//
//  ViewController.h
//  SampleRemoteIO
//
//  Created by takeda on 13/05/19.
//  Copyright (c) 2013年 takeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteOutput.h"

@interface ViewController : UIViewController{
    RemoteOutput *remoteOutput;
}

-(void)play:(id)sender;
-(void)stop:(id)sender;
@end
