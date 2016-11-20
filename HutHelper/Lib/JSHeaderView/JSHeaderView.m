//
//  JSHeaderView.m
//  JSHeaderView
//
//  Created by 雷亮 on 16/8/1.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "JSHeaderView.h"

#ifndef Block_exe
#define Block_exe(block, ...) \
if (block) { \
    block(__VA_ARGS__); \
}
#endif

static NSString *const kContentOffset = @"contentOffset";

@interface JSHeaderView ()

@property (nonatomic, strong) UIButton *headerButton;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) ClickHeaderBlock clickHeaderBlock;

@end

@implementation JSHeaderView

#pragma mark -
#pragma mark - init and dealloc methods
- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildingUI];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        [self buildingUI];
        self.image = image;
    }
    return self;
}

- (void)dealloc {
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:kContentOffset context:nil];
    }
}

#pragma mark -
#pragma mark - external calling methods
- (void)reloadSizeWithScrollView:(UIScrollView *)scrollView {
    self.scrollView = scrollView;
    [self.scrollView addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

- (void)handleClickActionWithBlock:(ClickHeaderBlock)block {
    self.clickHeaderBlock = block;
    self.userInteractionEnabled = YES;
    
    [self.headerButton addTarget:self action:@selector(tapHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark - setter methods
- (void)setImage:(UIImage *)image {
    _image = image;
    [self.headerButton setImage:image forState:UIControlStateNormal];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.headerButton.layer.borderColor = borderColor.CGColor;
}

#pragma mark -
#pragma mark - building UI methods
- (void)buildingUI {
    CGFloat kWidth = 60;
    
    self.frame = CGRectMake(0, 0, kWidth, kWidth);

    self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerButton.frame = CGRectMake(0, 0, kWidth, kWidth);
    _headerButton.center = CGPointMake(kWidth / 2, kWidth / 2);
    _headerButton.backgroundColor = [UIColor clearColor];
    _headerButton.layer.borderWidth = 0.5f;
    _headerButton.layer.cornerRadius = kWidth / 2;
    _headerButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    _headerButton.clipsToBounds = YES;
    [self addSubview:_headerButton];
}

#pragma mark -
#pragma mark - reload image size handle methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kContentOffset] && object == self.scrollView) {
        
        CGFloat offsetY = self.scrollView.contentOffset.y;
        CGFloat scale = 1.0;
        if (offsetY < 0) { // 放大
            scale = MIN(1.2, 1 - offsetY / 300);
        } else if (offsetY > 0) { // 缩小
            scale = MAX(0.55, 1 - offsetY / 300);
        }
        self.headerButton.transform = CGAffineTransformMakeScale(scale, scale);

        CGRect frame = self.headerButton.frame;
        frame.origin.y = 15;
        self.headerButton.frame = frame;
    }
}

- (void)tapHeaderAction:(UITapGestureRecognizer *)sender {
    Block_exe(_clickHeaderBlock)
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
