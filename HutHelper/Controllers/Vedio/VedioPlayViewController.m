//
//  VedioPlayViewController.m
//  HutHelper
//
//  Created by Nine on 2017/4/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "VedioPlayViewController.h"
#import "ZFPlayer.h"
@interface VedioPlayViewController () <ZFPlayerDelegate>
@property (strong, nonatomic)  IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation VedioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  self.zf_prefersNavigationBarHidden = YES;
    // 自动播放，默认不自动播放
    
    self.view.backgroundColor=[UIColor whiteColor];
    _playerFatherView=[[ZFPlayerView alloc]initWithFrame:CGRectMake(0,SYReal(68),DeviceMaxWidth,DeviceMaxWidth*9/16)];
    [self.view addSubview:self.playerFatherView];
    self.navigationItem.title=_name;
    [self.playerView autoPlayTheVideo];
    [self draw];
    
    
}
-(void)draw{
    int witgh=0;
    int height=0;
    for(int i=0;i<_listUrl.count;i++){
        UIButton *button= [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i;
        if (SYReal(60)+witgh>DeviceMaxWidth) {
            height+=SYReal(80);
            witgh=0;
        }
        [button setFrame:CGRectMake(SYReal(10)+witgh,SYReal(120)+DeviceMaxWidth*9/16+height, SYReal(50), SYReal(50))];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize: 15.0];
        button.backgroundColor=[UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnNewVedio:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        witgh+=SYReal(65);
    }
}

-(void)btnNewVedio:(UIButton *)button{
    int i=(short)button.tag;
    self.playerModel.title            = [_listUrl[i] objectForKey:@"title"];;
    self.playerModel.videoURL         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Config getVedio480p],[_listUrl[i] objectForKey:@"url"]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",[Config getVedio480p],[_listUrl[i] objectForKey:@"url"]]);
    _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
    [self.playerView resetToPlayNewVideo:self.playerModel];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = [_listUrl[0] objectForKey:@"title"];
        _playerModel.videoURL         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Config getVedio480p],[_listUrl[0] objectForKey:@"url"]]];
        //        NSLog(@"网络地址%@",[_listUrl[0] objectForKey:@"url"]);
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        // _playerModel.placeholderImageURLString = [NSString stringWithFormat:API_IMG,_img];
        _playerModel.fatherView       = self.playerFatherView;
        NSLog(@"%@",[NSString stringWithFormat:@"%@%@",[Config getVedio1080p],[_listUrl[0] objectForKey:@"url"]]);
        _playerModel.resolutionDic = @{
                                       @"高清" : [NSString stringWithFormat:@"%@%@",[Config getVedio480p],[_listUrl[0] objectForKey:@"url"]],
                                       @"超清" : [NSString stringWithFormat:@"%@%@",[Config getVedio1080p],[_listUrl[0] objectForKey:@"url"]]
                                       };
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

@end
