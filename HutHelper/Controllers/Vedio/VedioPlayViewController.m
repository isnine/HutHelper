//
//  VedioPlayViewController.m
//  HutHelper
//
//  Created by Nine on 2017/4/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "VedioPlayViewController.h"
#import "ZFPlayer.h"
@interface VedioPlayViewController ()<ZFPlayerDelegate>
@property (weak, nonatomic)  IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@end

@implementation VedioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  self.zf_prefersNavigationBarHidden = YES;
    // 自动播放，默认不自动播放

    
    self.playerView = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        // 这里宽高比16：9，可以自定义视频宽高比
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    
    // 初始化控制层view(可自定义)
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    // 初始化播放模型
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.videoURL  = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
    playerModel.title = @"123";
    playerModel.fatherView       = self.playerView;
    [self.playerView playerControlView:controlView playerModel:playerModel];
    
    // 设置代理
    self.playerView.delegate = self;
    // 自动播放
    [self.playerView autoPlayTheVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
