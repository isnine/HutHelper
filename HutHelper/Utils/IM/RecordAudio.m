//
//  RecordAudio.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/3.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "RecordAudio.h"
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"
#import <CoreAudio/CoreAudioTypes.h>
#import "CommonUtil.h"

@interface RecordAudio ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (copy,   nonatomic) NSURL           *recordedTmpFile;

@property (strong, nonatomic) AVAudioRecorder *recorder;

@property (strong, nonatomic) AVAudioPlayer   *player;

@property (assign, nonatomic) NSTimeInterval  startTime;

@property (assign, nonatomic) NSTimeInterval  endTime;

@property (copy,   nonatomic) NSString        *fileName;



@end

@implementation RecordAudio

+(instancetype)defaultRecordAudio{
    static dispatch_once_t onceToken;
    static RecordAudio *audio = nil;
    dispatch_once(&onceToken, ^{
        audio = [[[self class] alloc] init];
    });
    return audio;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupAudioSession];
        
    }
    
    return self;
}


-(void)setupAudioSession{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    
    [audioSession setActive:YES error: &error];
}



-(void)startRecord{
    
    if (self.recorder) {
        self.recorder.delegate = nil;
        self.recorder = nil;
    }
    [self setupAudioSession];
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    NSError *error = nil;
    _fileName = [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"wav"];
    
    NSString *path = [CommonUtil audioCacheDirectory];
    
    
    
    _path = [path  stringByAppendingPathComponent:self.fileName];
    _recordedTmpFile = [NSURL fileURLWithPath:_path];
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordedTmpFile settings:recordSetting error:&error];
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    [self.recorder record];
    
    self.startTime = [[NSDate date] timeIntervalSince1970];
    
}

-(void)cancelRecord{
    [self.recorder stop];
    [self.recorder deleteRecording];
    
}

-(void)stopRecord{
    self.endTime = [[NSDate date] timeIntervalSince1970];
    self.recordedDuration = self.endTime - self.startTime;
    [self.recorder stop];
    
   
    
}

-(NSData *)audioData{
    NSData *data = [[NSData alloc] initWithContentsOfURL:self.recordedTmpFile];
    NSData *amrData = EncodeWAVEToAMR(data, 1, 16);
    
    if (data && data.length > 0) {
        [self.recorder deleteRecording];
    }
    
    return amrData;
}

-(BOOL)isPlaying{
   return  [self.player isPlaying];
}

-(void)play:(NSData *)data type:(NSString *)type{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: &error];
    [audioSession setActive:YES error:nil];
    if ([self.player isPlaying]) {
        [self.player stop];
    }else{
        if (self.player) {
            self.player.delegate = nil;
            self.player = nil;
        }
        if ([type isEqualToString:@"wav"]) {
            if (!self.player) {
                _player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            }
        }else if([type isEqualToString:@"amr"]){
            if (data && data.length > 0) {
                NSData *outData = DecodeAMRToWAVE(data);
                _player = [[AVAudioPlayer alloc] initWithData:outData error:nil];
            }
        }
        
        self.player.delegate = self;
        [self.player prepareToPlay];
        [self.player play];
        [self.player setVolume:1.0f];
        
    }

}

-(void)stopPlay{
    if (self.player) {
        [self.player stop];
    }
    
}

#pragma mark - delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playDidFinish)]) {
        [self.delegate playDidFinish];
    }
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playFailWithError:)]) {
        [self.delegate playFailWithError:error];
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordDidFinish)]) {
        [self.delegate recordDidFinish];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordFailWithError:)]) {
        [self.delegate recordFailWithError:error];
    }
}

@end
