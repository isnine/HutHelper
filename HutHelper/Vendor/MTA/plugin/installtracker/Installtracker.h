//
//  installtracker.h
//  installtracker
//
//  Created by xiang on 20/06/2017.
//  Copyright © 2017 xiangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString* NameLinkReceivedNotification = @"NameLinkReceivedNotification";

@interface Installtracker : NSObject


+(instancetype)getInstance;

//判断是否是MTA来源
-(BOOL)checkIsFromMTARefer:(NSUserActivity *)userActivity;

//处理Url Schema
-(void)handleOpenURL:(NSURL *)url;

//在启动的第一个页面初始化
-(void)startByViewDidload;

//设置中间页的地址,例如投放的地址(如果是通过接入js sdk自定义的话，需要调用此接口)
//示例: http://domain.com/test/download.html
-(void)setChannelUrl:(NSString *)urlString;


@end
