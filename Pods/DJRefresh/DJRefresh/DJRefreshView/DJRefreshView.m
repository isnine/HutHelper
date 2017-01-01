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

#import "DJRefreshView.h"

@interface DJRefreshView ()

@property (nonatomic,copy)DJRefreshViewDraggingProgressCompletionBlock progressBlock;

@end

@implementation DJRefreshView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
}




///重新布局
- (void)reset{
    _refreshViewType=DJRefreshViewTypeDefine;
}

///松开可刷新
- (void)canEngageRefresh{
    _refreshViewType=DJRefreshViewTypeCanRefresh;

}
///松开返回
- (void)didDisengageRefresh{
    [self reset];
}
///开始刷新
- (void)startRefreshing{
    _refreshViewType=DJRefreshViewTypeRefreshing;

}
///结束
- (void)finishRefreshing{
    [self reset];
}


- (void)draggingProgress:(CGFloat)progress{
    
    if (self.progressBlock) {
        @try {
            self.progressBlock(self,progress,nil);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
}

- (void)didDraggingProgressCompletionBlock:(DJRefreshViewDraggingProgressCompletionBlock)com{
    self.progressBlock=com;
}



@end
