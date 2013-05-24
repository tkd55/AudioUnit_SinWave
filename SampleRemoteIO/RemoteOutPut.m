//
//  RemoteOutPut.m
//  SampleRemoteIO
//
//  Created by takeda on 13/05/19.
//  Copyright (c) 2013年 takeda. All rights reserved.
//

#import "RemoteOutput.h"

@implementation RemoteOutput

@synthesize phase;
@synthesize sampleRate;

static OSStatus renderCallback(void*                       inRefCon,
                               AudioUnitRenderActionFlags* ioActionFlags,
                               const AudioTimeStamp*       inTimeStamp,
                               UInt32                      inBusNumber,
                               UInt32                      inNumberFrames,
                               AudioBufferList*            ioData){
    
    RemoteOutput* def = (RemoteOutput*)inRefCon;
    // サイン波の計算に使う数値の用意
    float freq = 440 * 2.0 * M_PI / def.sampleRate;
    
    // phaseはサウンドの再生中に継続して使うため、RemoteOutputのプロパティとする
    double phase = def.phase;
	AudioSampleType *out = ioData->mBuffers[0].mData;//変更
	
	for (int i = 0; i< inNumberFrames; i++){
		// サイン波を計算
		float wave = sin(phase);
		
        // 16bit（-32768〜32767)に変換する
		AudioSampleType sample = wave * 32767; //変更
		*out++ = sample;
		*out++ = sample;
        phase = phase + freq;
    }
    
    def.phase = phase;
    return noErr;
}

- (id)init{
    self = [super init];
    if (self != nil)[self prepareAudioUnit];
    return self;
}

-(BOOL)isPlaying{
    return isPlaying;
}

- (void)prepareAudioUnit{
    //RemoteIO Audio UnitのAudioComponentDescriptionを作成
    AudioComponentDescription cd;
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType = kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    
    // AudioComponentDescriptionからAudioComponentを取得
    AudioComponent component = AudioComponentFindNext(NULL, &cd);
    
    AudioComponentInstanceNew(component, &audioUnit);
    
    // 初期化
    AudioUnitInitialize(audioUnit);
    
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = renderCallback;  //コールバック関数の設定
    callbackStruct.inputProcRefCon = self;      //コールバック関数内で参照するデータのポインタ
    
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input, //サイン波の値はAudioUnitに入ってくるものなのでScopeはInput
                         0,                     // 0 == スピーカー
                         &callbackStruct,
                         sizeof(AURenderCallbackStruct));
    sampleRate = 44100.0;
    
	AudioStreamBasicDescription audioFormat;
	audioFormat.mSampleRate         = sampleRate;
	audioFormat.mFormatID           = kAudioFormatLinearPCM;
	audioFormat.mFormatFlags        = kAudioFormatFlagsCanonical;
	audioFormat.mChannelsPerFrame   = 2;                            //ステレオ
	audioFormat.mBytesPerPacket     = sizeof(AudioSampleType) * 2;
	audioFormat.mBytesPerFrame      = sizeof(AudioSampleType) * 2;
	audioFormat.mFramesPerPacket    = 1;
	audioFormat.mBitsPerChannel     = 8 * sizeof(AudioSampleType);
	audioFormat.mReserved           = 0;
    
	AudioUnitSetProperty(audioUnit,
						 kAudioUnitProperty_StreamFormat,
						 kAudioUnitScope_Input,
						 0,
						 &audioFormat,
						 sizeof(audioFormat));
}

-(void)play{
    if(!isPlaying){
        AudioOutputUnitStart(audioUnit);
    }
    isPlaying = YES;
}

-(void)stop{
    if(isPlaying){
        AudioOutputUnitStop(audioUnit);
    }
    isPlaying = NO;
}

- (void)dealloc{
    if(isPlaying){
        AudioOutputUnitStop(audioUnit);

    }
    AudioUnitUninitialize(audioUnit);
    AudioComponentInstanceDispose(audioUnit);
    [super dealloc];
}

@end