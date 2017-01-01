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



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 * 当前refreshing状态
 */
typedef enum {
    DJRefreshingDirectionNone    = 0,
    DJRefreshingDirectionTop     = 1 << 0,
    DJRefreshingDirectionBottom  = 1 << 1
} DJRefreshingDirections;

/**
 *  指定回调方向
 */
typedef enum {
    DJRefreshDirectionTop = 0,
    DJRefreshDirectionBottom
} DJRefreshDirection;

@class DJRefresh,DJRefreshView;

/**
 *  刷新回调Block
 *
 *  @param refresh   刷新组件对象
 *  @param direction 方向
 *  @param info      预留参数
 */
typedef void(^DJRefreshCompletionBlock)(DJRefresh * refresh,DJRefreshDirection direction,NSDictionary *info);

@protocol DJRefreshDelegate;


/**
 *	刷新组件
 */
@interface DJRefresh : NSObject

/**当前的状态*/
@property (nonatomic,assign,readonly)DJRefreshingDirections refreshingDirection;

/**当前监控的scrollView*/
@property (nonatomic,readonly)UIScrollView * scrollView;

/**代理回调对象*/
@property (nonatomic,weak)id<DJRefreshDelegate>delegate;

/**下拉刷新TopRefreshView,自定义时需要继承DJRefreshView类*/
@property (nonatomic,strong)DJRefreshView * topRefreshView;

/**上拉刷新BottomRefreshView,自定义时需要继承DJRefreshView类*/
@property (nonatomic,strong)DJRefreshView * bottomRefreshView;

+ (instancetype)refreshWithScrollView:(UIScrollView *)scrollView;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<DJRefreshDelegate>)delegate;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

/**设置回调Block*/
- (void)didRefreshCompletionBlock:(DJRefreshCompletionBlock)completionBlock;

/**是否开启下拉刷新，YES-开启 NO-不开启 默认是NO*/
@property (nonatomic,assign)BOOL topEnabled;

/**是否开启上拉加载更多，YES-开启 NO-不开启 默认是NO*/
@property (nonatomic,assign)BOOL bottomEnabled;

/**下拉刷新 状态改变的距离 默认65.0*/
@property (nonatomic,assign)float enableInsetTop;

/**上拉 状态改变的距离 默认65.0*/
@property (nonatomic,assign)float enableInsetBottom;

/**
 *  是否开启自动刷新,下拉到enableInsetTop位置自动刷新
    YES-开启，NO-不开启，默认是NO
 */
@property (nonatomic,assign)BOOL autoRefreshTop;
/**
 *  是否开启自动加载更多，上拉到enableInsetBottom位置自动加载更多
    YES-开启，NO-不开启，默认是NO
 */
@property (nonatomic,assign)BOOL autoRefreshBottom;

/**
 *  是否禁止添加topView到ScrollView上,默认是否
 */
@property (nonatomic,assign)BOOL isDisableAddTop;
/**
 *  是否禁止添加bottomView到ScrollView上,默认是否
 */
@property (nonatomic,assign)BOOL isDisableAddBottom;

/**
 *	自定义TopView,注册Top加载的view,view必须继承DJRefreshView类
 *	@param topClass 类类型
 */
- (void)registerClassForTopView:(Class)topClass;
/**
 *	自定义Bottom,注册Bottom加载的view,view必须继承DJRefreshView类
 *	@param bottomClass 类类型
 */
- (void)registerClassForBottomView:(Class)bottomClass;


/**
 *	启动刷新
 *	@param direction 方向
 *  @param animation 是否动画
 */
- (void)startRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation;

/**
 *	完成刷新
 *	@param direction 方向
 *  @param animation 是否动画
 */
- (void)finishRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation;

@end


/**
 *	刷新控件的代理方法
 */
@protocol DJRefreshDelegate <NSObject>


@optional

/**
 *	刷新回调
 *	@param refresh      刷新的控件
 *	@param direction    刷新的方向
 */
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection) direction;




@end



