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

#import <UIKit/UIKit.h>
#import "DJRefreshMacro.h"

/**
 *  DJRefreshView的状态
 */
typedef NS_ENUM(NSInteger, DJRefreshViewType){
    /**
     *  默认状态
     */
    DJRefreshViewTypeDefine=0,
    /**
     *  可以刷新状态
     */
    DJRefreshViewTypeCanRefresh,
    /**
     *  正在刷新状态
     */
    DJRefreshViewTypeRefreshing
};

@class DJRefreshView;

/**
 *	拉动的距离进度Block
 *	@param refreshView	刷新View控件
 *	@param progress		进度（0.0-1.0）
 *	@param info			预留参数
 */
typedef void(^DJRefreshViewDraggingProgressCompletionBlock)(DJRefreshView * refreshView,CGFloat progress,NSDictionary *info);

/**
 *  刷新的View控件
 */
@interface DJRefreshView : UIView

/**
 *  当前的状态
 */
@property (nonatomic,readonly)DJRefreshViewType refreshViewType;

/**
 *  返回重置
 */
- (void)reset;

/**
 *  可以进行刷新操作
 */
- (void)canEngageRefresh;

/**
 *  不能刷新操作
 */
- (void)didDisengageRefresh;

/**
 *  开始刷新
 */
- (void)startRefreshing;

/**
 *  完成刷新
 */
- (void)finishRefreshing;

/**
 *  拉动的进度 范围（0.0-1.0）
 *
 *  @param progress 进度
 */
- (void)draggingProgress:(CGFloat)progress;


/**
 *	拉动的进度回调,在draggingProgress:方法中回调
 *	@param com	回调Block
 */
- (void)didDraggingProgressCompletionBlock:(DJRefreshViewDraggingProgressCompletionBlock)com;


@end
