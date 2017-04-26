//
//  RecordAudio.h
//  BmobIMDemo
//
//  Created by Bmob on 16/3/3.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol RecordAudioDelegate;

@interface RecordAudio : NSObject

@property (copy, nonatomic) NSString *path;

@property (weak, nonatomic) id<RecordAudioDelegate> delegate;

@property (assign, nonatomic) CGFloat recordedDuration;



+(instancetype)defaultRecordAudio;

-(void) startRecord;

-(void)stopRecord;

-(NSData *)audioData;

-(BOOL)isPlaying;

-(void)play:(NSData *)data type:(NSString *)type;

-(void)stopPlay;

-(void)cancelRecord;

@end


@protocol RecordAudioDelegate <NSObject>
@optional

/**
 *  录音失败
 *
 *  @param error <#error description#>
 */
-(void)recordFailWithError:(NSError *)error;

/**
 *  录音结束
 */
-(void)recordDidFinish;

/**
 *  播放失败
 *
 *  @param error <#error description#>
 */
-(void)playFailWithError:(NSError *)error;

/**
 *  播放结束
 */
-(void)playDidFinish;

@end