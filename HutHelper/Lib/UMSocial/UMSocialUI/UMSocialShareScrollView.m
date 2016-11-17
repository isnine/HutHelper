//
//  UMSocialShareScrollView.m
//  UMSocialShareScrollView
//
//  Created by umeng on 16/9/26.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import "UMSocialShareScrollView.h"


@interface UMSocialShareScrollView ()<UIScrollViewDelegate>

@property (nonatomic, assign) DJXScrollSubViewLocation subViewLocation;

@property (nonatomic, strong) NSMutableArray *contentViews;


@end

@implementation UMSocialShareScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentViews = [NSMutableArray array];
        self.delegate = self;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 5, frame.size.width, 20)];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
        
    }
    return self;
}

- (void)setTotalCount:(NSInteger)totalCount
{
    _totalCount = totalCount;
        
    if (_totalCount > 0) {
        if (_totalCount == 1) {
            self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            self.contentOffset = CGPointMake(0, 0);
            self.scrollEnabled = NO;
        }else{
            self.contentSize = CGSizeMake(3*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
            self.scrollEnabled = YES;
        }
        [self configContentView];
    }else{
        [self.contentViews removeAllObjects];
    }
    self.pageControl.numberOfPages = totalCount;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    self.pageControl.currentPage = currentPageIndex;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= (2*CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
        [self configContentView];
    }
    if (scrollView.contentOffset.x <= 0) {
        self.currentPageIndex = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
        [self configContentView];
    }
    self.pageControl.currentPage = self.currentPageIndex;
}

- (void)configContentView
{
    NSInteger leftPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex-1];
    NSInteger currentPage = self.currentPageIndex;
    NSInteger rightPage = [self validNextPageWithExpectedNextPage:self.currentPageIndex+1];
    
    [self.contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentViews removeAllObjects];
    
    if (self.contentViewWithIndex) {
        if (self.totalCount == 1) {
            UIView *curView = self.contentViewWithIndex(self, self.currentPageIndex,DJX_curView);
            [self addSubview:curView];
            [self setContentOffset:CGPointMake(0, 0.0f) animated:NO];

        }else if (self.totalCount > 1){
            
            UIView *leftView = self.contentViewWithIndex(self, leftPage, DJX_leftView);
            [self.contentViews addObject:leftView];
            
            UIView *curView = self.contentViewWithIndex(self, currentPage, DJX_curView);
            [self.contentViews addObject:curView];
            
            UIView *rightView = self.contentViewWithIndex(self, rightPage, DJX_rightView);
            [self.contentViews addObject:rightView];
            
            for (int index = 0; index < self.contentViews.count; index++) {
                UIImageView *contentView = self.contentViews[index];
                CGRect contentViewFrame = contentView.frame;
                contentViewFrame.origin.x = index*self.frame.size.width + (self.frame.size.width - contentView.frame.size.width)/2;
                contentView.frame = contentViewFrame;
                [self addSubview:contentView];
            }
            [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0f) animated:NO];
            
        }else{
            NSLog(@"There is no subviews to show");
        }
    }else{
        NSLog(@"There is no subviews to show");
    }
}

- (NSInteger)validNextPageWithExpectedNextPage:(NSInteger)expectedNextPage
{
    if (expectedNextPage == -1) {
        return self.totalCount - 1;
    }else if (expectedNextPage == self.totalCount || expectedNextPage < -1){
        return 0;
    }else if (expectedNextPage > self.totalCount){
        return self.totalCount - 1;
    }else{
        return expectedNextPage;
    }
}

- (void)didMoveToSuperview
{
    [self.pageControl removeFromSuperview];
//    CGRect pageControllFrame = self.pageControl.frame;
//    pageControllFrame.origin.y = self.frame.origin.y + self.frame.size.height;
//    pageControllFrame.origin.x = self.frame.origin.x;
//    self.pageControl.frame = pageControllFrame;
    [self.superview addSubview:self.pageControl];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
