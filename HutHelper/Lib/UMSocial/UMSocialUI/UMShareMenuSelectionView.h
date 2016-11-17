//
//  UMShareMenuSelectionView.h
//  SocialSDK
//
//  Created by umeng on 16/4/24.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialShareScrollView.h"
#import <UMSocialCore/UMSocialCore.h>

@class UMShareMenuSelectionView;
typedef void(^UMSocialSharePlatformSelectionBlock)(UMShareMenuSelectionView *shareSelectionView,UMSocialPlatformType platformType);

@interface UMShareMenuSelectionView : UMSocialShareScrollView

@property (nonatomic, strong) UIView *backgroundGrayView;

@property (nonatomic, strong) NSMutableArray *sharePlatformInfoArray;

@property (nonatomic, assign, readonly) UMSocialPlatformType selectionPlatform;

@property (nonatomic, copy) UMSocialSharePlatformSelectionBlock shareSelectionBlock;

@property (nonatomic, copy) void (^dismissBlock) ();

- (void)show;
- (void)hiddenShareMenuView;

@end


