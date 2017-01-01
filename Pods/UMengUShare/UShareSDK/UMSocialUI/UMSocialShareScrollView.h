//
//  UMSocialShareScrollView.h
//  UMSocialShareScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DJX_curView = 0,
    DJX_leftView,
    DJX_rightView,
    
} DJXScrollSubViewLocation;


@class UMSocialShareScrollView;
@protocol UMSocialShareScrollViewDelegate <NSObject>

- (void)djx_scrollView:(UMSocialShareScrollView *)scrollView nextPage:(NSInteger)nextPage;

@end

@interface UMSocialShareScrollView : UIScrollView

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) BOOL loopScroll; //是否循环滚动

@property (nonatomic, copy) UIView *(^contentViewWithIndex)(UMSocialShareScrollView *scrollView, NSInteger index, DJXScrollSubViewLocation location);

- (void)configContentView;


@end
