//
//  ChatBottomControlView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/21.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ChatBottomControlView.h"
#import "UUProgressHUD.h"
#import "RecordAudio.h"
#import <AVFoundation/AVFoundation.h>


@implementation ChatBottomControlView

static CGFloat kRecordMin = 1.0f;
static CGFloat kRecordMax = 60.0f;

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ChatBottomControlView" owner:self options:nil] firstObject];
        [self addSubview:view];
        
        
        [self.typeButton setImage:[UIImage imageNamed:@"chat_icon1"] forState:UIControlStateNormal];
        [self.typeButton setImage:[UIImage imageNamed:@"chat_icon1_"] forState:UIControlStateHighlighted ];
        
        [self.emojiButton setImage:[UIImage imageNamed:@"chat_icon2"] forState:UIControlStateNormal];
        [self.emojiButton setImage:[UIImage imageNamed:@"chat_icon2_"] forState:UIControlStateHighlighted];
        
        [self.talkButton setImage:[UIImage imageNamed:@"chat_icon3"] forState:UIControlStateNormal];
        [self.talkButton setImage:[UIImage  imageNamed:@"chat_icon3_"] forState:UIControlStateHighlighted];
        [self.talkButton addTarget:self action:@selector(hideOrShowTalkingButton) forControlEvents:UIControlEventTouchUpInside];
        
        [self.voiceRecordButton setTitle:@"释放发送" forState:UIControlStateHighlighted];
        [self.voiceRecordButton addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.voiceRecordButton addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceRecordButton addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        
        [self.voiceRecordButton addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    }
    return self;
}




-(void)hideOrShowTalkingButton{
    if (self.voiceRecordButton.hidden) {
        self.voiceRecordButton.hidden = NO;
        self.textField.hidden = YES;
        [self.textField resignFirstResponder];
    }else{
        self.voiceRecordButton.hidden = YES;
        self.textField.hidden = NO;
        [self.textField becomeFirstResponder];
    }
}


#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
    NSString *mediaType = AVMediaTypeAudio;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (status == AVAuthorizationStatusAuthorized) {
        [[RecordAudio defaultRecordAudio] startRecord];
        
        [UUProgressHUD show];
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
        }];
    }
    
}

- (void)endRecordVoice:(UIButton *)button
{
    
    RecordAudio *recordAudio = [RecordAudio defaultRecordAudio];
    [recordAudio stopRecord];
    if (recordAudio.recordedDuration < kRecordMin || recordAudio.recordedDuration > kRecordMax) {
        [recordAudio cancelRecord];
    }
    NSData *data = [recordAudio audioData];
    [UUProgressHUD dismissWithError:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordCompletedWithData: duration: localPath:)]) {
            [self.delegate recordCompletedWithData:data duration:recordAudio.recordedDuration localPath:recordAudio.path];
        }
    });
    
    
    
}

- (void)cancelRecordVoice:(UIButton *)button
{
    [[RecordAudio defaultRecordAudio] cancelRecord];
    [UUProgressHUD dismissWithError:nil];
}

- (void)RemindDragExit:(UIButton *)button
{
//    [UUProgressHUD changeSubTitle:@"释放发送"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"滑动取消"];
}



@end
