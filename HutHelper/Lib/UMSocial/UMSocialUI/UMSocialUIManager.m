//
//  UMSocialUIManager.m
//  UMSocialSDK
//
//  Created by umeng on 16/8/10.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import "UMSocialUIManager.h"

@interface UMSocialUIManager ()

@property (nonatomic, strong) UMShareMenuSelectionView *shareMenuView;

@end

@implementation UMSocialUIManager

+ (UMSocialUIManager *)defaultManager
{
    static UMSocialUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock
{
    UMSocialUIManager *uiManager = [UMSocialUIManager defaultManager];
    [uiManager showShareMenuViewInWindowWithPlatformSelectionBlock:sharePlatformSelectionBlock];
}

- (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock
{
    if (!self.shareMenuView) {
        [self creatShareSelectionView];
    }
    self.shareMenuView.shareSelectionBlock = ^(UMShareMenuSelectionView *shareSelectionView,UMSocialPlatformType platformType){
        if (sharePlatformSelectionBlock) {
            sharePlatformSelectionBlock(shareSelectionView, platformType);
        }
    };

    [self.shareMenuView show];
}


- (void)creatShareSelectionView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UMShareMenuSelectionView *selectionView = [[UMShareMenuSelectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.shareMenuView = selectionView;
}




@end
