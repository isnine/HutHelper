//
//  DJRefresh.h
//
//  Copyright (c) 2014 YDJ ( https://github.com/ydj/DJRefresh )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "DJRefreshTopView.h"

@implementation DJRefreshTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];
    
    _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped=YES;
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_activityIndicatorView];
    
    NSLayoutConstraint * aBottom=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    NSLayoutConstraint * aRight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-5];
    NSLayoutConstraint * aWith=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:35];
    NSLayoutConstraint * aHeight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:35];
    
    NSArray * aList=@[aBottom,aRight,aWith,aHeight];
    
    [self addConstraints:aList];
    
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image=[UIImage imageNamed:@"DJRefresh.bundle/dj_arrow_down"];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_imageView];
    
    
    NSLayoutConstraint *vBottom=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-13];
    NSLayoutConstraint *vRight=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-8];
    NSLayoutConstraint *vWidth=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:32];
    NSLayoutConstraint *vHeight=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * vList=@[vBottom,vRight,vWidth,vHeight];
    [self addConstraints:vList];
    
    
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor=[UIColor clearColor];
    _promptLabel.font=[UIFont systemFontOfSize:13];
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    
    NSLayoutConstraint * tLeft=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * tBottom=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-13];
    NSLayoutConstraint * tRight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * tHeight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * tList=@[tLeft,tBottom,tRight,tHeight];
    
    [self addConstraints:tList];
    
    
    [self reset];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
///重新布局
- (void)reset{
    [super reset];
    
    _imageView.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformIdentity;
    }];
    if ([_activityIndicatorView isAnimating])
    {
        [_activityIndicatorView stopAnimating];
    }
    _promptLabel.text=kDJRefreshTopTypeDefine;
}

///松开可刷新
- (void)canEngageRefresh{
    [super canEngageRefresh];
    
    _promptLabel.text=kDJRefreshTopTypeCanRefresh;
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformMakeRotation(M_PI);
    }];
}

///开始刷新
- (void)startRefreshing{
    [super startRefreshing];
    
    _imageView.hidden=YES;
    _imageView.transform=CGAffineTransformIdentity;

    [_activityIndicatorView startAnimating];
    _promptLabel.text=kDJRefreshTopTypeRefreshing;
}



@end
