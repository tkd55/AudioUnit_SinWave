//
//  RemoteOutPut.h
//  SampleRemoteIO
//
//  Created by takeda on 13/05/19.
//  Copyright (c) 2013年 takeda. All rights reserved.
//

#import <AudioUnit/AudioUnit.h>

@interface RemoteOutput : NSObject {
    AudioUnit   audioUnit;
    double      phase;
    Float64     sampleRate;
    BOOL        isPlaying;
}

-(void)play;
-(void)stop;

@property(nonatomic) double phase;
@property(nonatomic) Float64 sampleRate;

- (void)prepareAudioUnit;
@end
