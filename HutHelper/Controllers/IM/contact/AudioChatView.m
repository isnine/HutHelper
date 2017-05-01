//
//  AudioChatView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/7.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "AudioChatView.h"
#import "RecordAudio.h"
#import "AFNetworking.h"
#import "CommonUtil.h"
#import "UIColor+SubClass.h"
#import "BmobIMDemoPCH.h"

@interface AudioChatView ()

@property (strong, nonatomic) UILabel  *audioTimeLabel;

@property (strong, nonatomic) UIButton *audioButton;

@property (strong, nonatomic) UIImageView *audioImageView;

@end


@implementation AudioChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UILabel *)audioTimeLabel{
    if (!_audioTimeLabel) {
        _audioTimeLabel = [[UILabel alloc] init];
        _audioTimeLabel.font = [UIFont systemFontOfSize:14];
        [self.chatContentView addSubview:_audioTimeLabel];
        
    }
    
    return _audioTimeLabel;
}

-(UIButton *)audioButton{
    if (!_audioButton) {
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chatContentView addSubview:_audioButton];
    }
    
    return _audioButton;
}

-(UIImageView *)audioImageView{
    if (!_audioImageView) {
        _audioImageView = [[UIImageView alloc] init];
        [self.chatContentView addSubview:_audioImageView];
    }
    return _audioImageView;
}

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo{
    [super setMessage:msg user:userInfo];
    
    [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    
    BmobIMAudioMessage *audioMsg = (BmobIMAudioMessage *)msg;
    self.audioTimeLabel.text = [NSString stringWithFormat:@"%.0f's",audioMsg.duration];
}

-(void)layoutViewsSelf{
    [super layoutViewsSelf];
    self.audioImageView.image = [UIImage imageNamed:@"chat_animation_white3"];
    self.audioImageView.animationImages =@[[UIImage imageNamed:@"chat_animation_white1"],[UIImage imageNamed:@"chat_animation_white2"],[UIImage imageNamed:@"chat_animation_white3"]];
    self.audioTimeLabel.textColor = [UIColor whiteColor];
    BmobIMAudioMessage *audioMsg = (BmobIMAudioMessage *)self.msg;
    //布局
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarBackgroundImageView.mas_left).with.offset(-8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.equalTo(@(60 + audioMsg.duration * 8));
        make.height.equalTo(self.audioImageView.mas_height).with.offset(20);
    }];
    
    
    [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatContentView.mas_centerY);
        make.right.equalTo(self.chatContentView.mas_right).with.offset(-20);
        make.width.equalTo(@(15));
        make.height.equalTo(@(17));
    }];

    [self.audioTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatContentView.mas_centerY);
        make.left.equalTo(self.chatContentView.mas_left).with.offset(8);
    }];
    
    
    
    
}



-(void)layoutViewsOther{
    [super layoutViewsOther];
    self.audioImageView.image = [UIImage imageNamed:@"chat_animation3"];
    self.audioImageView.animationImages =@[[UIImage imageNamed:@"chat_animation1"],[UIImage imageNamed:@"chat_animation2"],[UIImage imageNamed:@"chat_animation3"]];
    self.audioTimeLabel.textColor = [UIColor colorWithR:47 g:39 b:37];
    BmobIMAudioMessage *audioMsg = (BmobIMAudioMessage *)self.msg;
    //布局
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarBackgroundImageView.mas_right).with.offset(8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.equalTo(@(60 + audioMsg.duration * 8));
        make.height.equalTo(self.audioImageView.mas_height).with.offset(20);
    }];
    
    
    [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatContentView.mas_centerY);
        make.left.equalTo(self.chatContentView.mas_left).with.offset(20);
        make.width.equalTo(@(15));
        make.height.equalTo(@(17));
    }];
    
    [self.audioTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatContentView.mas_centerY);
        make.right.equalTo(self.chatContentView.mas_right).with.offset(-8);
    }];
    
}


-(void)playAudio{
    
    if ([[RecordAudio defaultRecordAudio] isPlaying]) {
        return;
    }
    
    self.audioButton.enabled = NO;
    //得到地址
    BmobIMAudioMessage *audioMessage = (BmobIMAudioMessage *)self.msg;
    NSArray *array = [self.msg.content componentsSeparatedByString:@"&"];
    if (!audioMessage.localPath || audioMessage.localPath.length == 0) {
        if (array.count > 1) {
            audioMessage.localPath = [array firstObject];
            audioMessage.content   = [array lastObject];
        }else{
            audioMessage.localPath = nil;
            audioMessage.content   = self.msg.content;
        }
    }
    //本地有就下载本地的，没有就从网络下载下来放在本地
    NSString *audioLocalPath = [NSHomeDirectory() stringByAppendingPathComponent:audioMessage.localPath];
    if (audioMessage.localPath.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:audioLocalPath]) {
        [self playWithLocalPath:[NSURL fileURLWithPath:audioLocalPath]];
    } else{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:audioMessage.content];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        __weak typeof(self)weakSelf = self;
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[CommonUtil audioCacheDirectory]];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (!error) {
                [weakSelf playWithLocalPath:filePath];
            }else{
                weakSelf.audioButton.enabled = YES;
            }
        }];
        [downloadTask resume];
    }
    
    
}

-(void)playWithLocalPath:(NSURL *)path{
    NSData *data            = [[NSData alloc] initWithContentsOfURL:path];
    NSString *type          = [path.absoluteString pathExtension];
    
    self.audioImageView.animationDuration = 1;
    self.audioImageView.animationRepeatCount = 0;
    [self.audioImageView startAnimating];
    NSTimeInterval stopTime = [self.msg.extra[KEY_METADATA][KEY_DURATION] floatValue];
    int time = ceil(stopTime);
    int afterDelayTime =time+ (3- time % 3);
    [self performSelector:@selector(stopAudio) withObject:nil afterDelay:afterDelayTime];
    [[RecordAudio defaultRecordAudio] play:data type:type];
}

-(void)stopAudio{
    [self.audioImageView stopAnimating];
    [[RecordAudio defaultRecordAudio] stopPlay];
    self.audioButton.enabled = YES;
}




@end
