//
//  MoviePlayerViewController.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "ZFPlayer.h"
#import "UINavigationBar+Awesome.h"
@interface MoviePlayerViewController ()
@property (weak, nonatomic)  IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation MoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  self.zf_prefersNavigationBarHidden = YES;
    // 自动播放，默认不自动播放
    self.navigationItem.title=_name;
    [self.playerView autoPlayTheVideo];
    //self.playerView.playerPushedOrPresented = YES;
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = [_listUrl[0] objectForKey:@"title"];
        _playerModel.videoURL         = [NSURL URLWithString:[_listUrl[0] objectForKey:@"url"]];
        NSLog(@"网络地址%@",[_listUrl[0] objectForKey:@"url"]);
        _playerModel.placeholderImageURLString = [NSString stringWithFormat:API_IMG,_img];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        [_playerView playerControlView:nil playerModel:self.playerModel];
        _playerView.delegate = self;
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = NO;
        // 打开预览图
        self.playerView.hasPreviewView = YES;
    }
    return _playerView;
}

#pragma mark - Action

- (IBAction)playNewVideo:(UIButton *)sender {
    self.playerModel.title            = @"这是新播放的视频";
    self.playerModel.videoURL         = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
    // 设置网络封面图
    self.playerModel.placeholderImageURLString = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
    // 从xx秒开始播放视频
    // self.playerModel.seekTime         = 15;
    [self.playerView resetToPlayNewVideo:self.playerModel];
}


@end
