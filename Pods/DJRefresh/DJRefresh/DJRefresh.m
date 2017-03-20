//
//  DJRefresh.m
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

#import "DJRefresh.h"
#import "DJRefreshView.h"
#import "DJRefreshTopView.h"
#import "DJRefreshBottomView.h"

@interface DJRefresh ()

@property (nonatomic,copy)NSString * topClass;
@property (nonatomic,copy)NSString * bottomClass;

@property (nonatomic,copy)DJRefreshCompletionBlock comBlock;

@end

@implementation DJRefresh


- (void)registerClassForTopView:(Class)topClass
{
    if ([topClass isSubclassOfClass:[DJRefreshView class]]) {
        self.topClass=NSStringFromClass([topClass class]);
    }

}
- (void)registerClassForBottomView:(Class)bottomClass
{
    if ([bottomClass isSubclassOfClass:[DJRefreshView class]]) {
        self.bottomClass=NSStringFromClass([bottomClass class]);
    }
}


+ (instancetype)refreshWithScrollView:(UIScrollView *)scrollView{
    __autoreleasing  DJRefresh *refresh=[[DJRefresh alloc] initWithScrollView:scrollView];
    return refresh;
}


- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<DJRefreshDelegate>)delegate
{
    if (self=[super init])
    {
        _scrollView=scrollView;
        _delegate=delegate;
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    if (self=[super init]) {
        _scrollView=scrollView;
        [self setup];
    }
    return self;
}


- (void)setup{
    
    self.enableInsetTop=65.0;
    self.enableInsetBottom=65.0;
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];
    
}

- (void)didRefreshCompletionBlock:(DJRefreshCompletionBlock)completionBlock{
    self.comBlock=completionBlock;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqual:@"contentSize"])
    {
        if (self.topEnabled)
        {
            [self initTopView];
        }
        
        if (self.bottomEnabled)
        {
            [self initBottonView];
        }
    }
    else if([keyPath isEqual:@"contentOffset"])
    {
        if (_refreshingDirection==DJRefreshingDirectionNone) {
            [self _drogForChange:change];
        }
    }
    
    
}

- (void)_drogForChange:(NSDictionary *)change
{
    
    if ( self.topEnabled && self.scrollView.contentOffset.y<0)
    {
        CGFloat progress=self.scrollView.contentOffset.y/(-self.enableInsetTop);
        progress=MIN(1, MAX(progress, 0));
        [self _didDraggingProgress:progress direction:DJRefreshDirectionTop];
        
        if(self.scrollView.contentOffset.y<=-self.enableInsetTop)
        {
            if (self.autoRefreshTop || ( self.scrollView.decelerating && self.scrollView.dragging==NO)) {
                [self _engageRefreshDirection:DJRefreshDirectionTop];
            }
            else {
                [self _canEngageRefreshDirection:DJRefreshDirectionTop];
            }
        }
        else
        {
            [self _didDisengageRefreshDirection:DJRefreshDirectionTop];
        }
    }
    
    if ( self.bottomEnabled && self.scrollView.contentOffset.y>0 )
    {
        
        if (self.scrollView.contentOffset.y>(self.scrollView.contentSize.height-self.scrollView.bounds.size.height)) {
            CGFloat progress=(self.scrollView.contentOffset.y-(self.scrollView.contentSize.height-self.scrollView.bounds.size.height))/self.enableInsetBottom;
            progress=MIN(1, MAX(progress, 0));
            [self _didDraggingProgress:progress direction:DJRefreshDirectionBottom];
        }
        
        if(self.scrollView.contentOffset.y>=(self.scrollView.contentSize.height+self.enableInsetBottom-self.scrollView.bounds.size.height) )
        {
            if(self.autoRefreshBottom || (self.scrollView.decelerating && self.scrollView.dragging==NO)){
                [self _engageRefreshDirection:DJRefreshDirectionBottom];
            }
            else{
                [self _canEngageRefreshDirection:DJRefreshDirectionBottom];
            }
        }
        else {
            [self _didDisengageRefreshDirection:DJRefreshDirectionBottom];
        }
        
    }
    
    
    
}


- (void)_didDraggingProgress:(CGFloat)progress direction:(DJRefreshDirection)direction{
    if (direction==DJRefreshDirectionTop) {
        [self.topRefreshView draggingProgress:progress];
    }else if (direction==DJRefreshDirectionBottom){
        [self.bottomRefreshView draggingProgress:progress];
    }
}

- (void)_canEngageRefreshDirection:(DJRefreshDirection) direction
{
    
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topRefreshView.refreshViewType!=DJRefreshViewTypeCanRefresh) {
            [self.topRefreshView canEngageRefresh];
        }
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        if (self.bottomRefreshView.refreshViewType!=DJRefreshViewTypeCanRefresh) {
            [self.bottomRefreshView canEngageRefresh];
        }
    }
}

- (void)_didDisengageRefreshDirection:(DJRefreshDirection) direction
{
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topRefreshView.refreshViewType!=DJRefreshViewTypeDefine) {
            [self.topRefreshView didDisengageRefresh];
        }
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        if (self.bottomRefreshView.refreshViewType!=DJRefreshViewTypeDefine) {
            [self.bottomRefreshView didDisengageRefresh];
        }
    }
}


- (void)_engageRefreshDirection:(DJRefreshDirection) direction
{
    
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if (direction==DJRefreshDirectionTop)
    {
        _refreshingDirection=DJRefreshingDirectionTop;
        CGFloat topH=self.enableInsetTop<45?45:self.enableInsetTop;
        if (self.isDisableAddTop) {
            topH=0;
        }
        edge=UIEdgeInsetsMake(topH, 0, 0, 0);///enableInsetTop
        
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        CGFloat botomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        if (self.isDisableAddBottom) {
            botomH=0;
        }
        edge=UIEdgeInsetsMake(0, 0, botomH, 0);///self.enableInsetBottom
        _refreshingDirection=DJRefreshingDirectionBottom;
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _scrollView.contentInset=edge;
        if (direction==DJRefreshDirectionTop) {
            [_scrollView setContentOffset:CGPointMake(0, -edge.top) animated:YES];
        }
        [self _didEngageRefreshDirection:direction];
    });
    
    
}

- (void)_didEngageRefreshDirection:(DJRefreshDirection) direction
{
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topRefreshView.refreshViewType!=DJRefreshViewTypeRefreshing) {
            [self.topRefreshView startRefreshing];
        }
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        if (self.bottomRefreshView.refreshViewType!=DJRefreshViewTypeRefreshing) {
            [self.bottomRefreshView startRefreshing];
        }
    }
    
    if (self.comBlock) {
        @try {
            self.comBlock(self,direction,nil);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(refresh:didEngageRefreshDirection:)])
    {
        [self.delegate refresh:self didEngageRefreshDirection:direction];
    }
    
    
}


- (void)_startRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
{
    CGPoint point =CGPointZero;
    
    if (direction==DJRefreshDirectionTop)
    {
        CGFloat topH=self.enableInsetTop<45?45:self.enableInsetTop;
        if (self.isDisableAddTop) {
            topH=0;
        }
        point=CGPointMake(0, -topH);//enableInsetTop
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        CGFloat height=MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        CGFloat bottomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        if (self.isDisableAddBottom) {
            bottomH=0;
        }
        point=CGPointMake(0, height-self.scrollView.bounds.size.height+bottomH);///enableInsetBottom
    }
    
    __weak typeof(self)weakSelf=self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self)strongSelf=weakSelf;
        [_scrollView setContentOffset:point animated:animation];
        [strongSelf _engageRefreshDirection:direction];
    });
    
}

- (void)_finishRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
{
    
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentInset=UIEdgeInsetsZero;
        }];
    }else {
        _scrollView.contentInset=UIEdgeInsetsZero;
    }

    _refreshingDirection=DJRefreshingDirectionNone;
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topRefreshView.refreshViewType!=DJRefreshViewTypeDefine) {
            [self.topRefreshView finishRefreshing];
        }
    }
    else if(direction==DJRefreshDirectionBottom)
    {
        if (self.bottomRefreshView.refreshViewType!=DJRefreshViewTypeDefine) {
        [self.bottomRefreshView finishRefreshing];
        }
    }
    
}




- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)setTopRefreshView:(DJRefreshView *)topRefreshView{
    
    if (_topRefreshView!=topRefreshView) {
        [_topRefreshView removeFromSuperview];
    }
    _topRefreshView=topRefreshView;

}

- (void)setBottomRefreshView:(DJRefreshView *)bottomRefreshView{
    if (_bottomRefreshView!=bottomRefreshView) {
        [_bottomRefreshView removeFromSuperview];
    }
    _bottomRefreshView=bottomRefreshView;
}

- (void)initTopView
{
    
    if (!CGRectIsEmpty(self.scrollView.frame))
    {
        CGFloat topOffsetY=self.enableInsetTop+45;
        
        CGRect currentRect=CGRectMake(0, -topOffsetY, self.scrollView.frame.size.width, topOffsetY);
        
        if (_topRefreshView==nil) {
            NSString *classNameString=NSStringFromClass([DJRefreshTopView class]);
            if (self.topClass.length>0) {
                classNameString=self.topClass;
            }
            
            Class className=NSClassFromString(classNameString);
            _topRefreshView=[[className alloc] initWithFrame:currentRect];
            
        }else if (self.topClass && ![_topRefreshView isKindOfClass:NSClassFromString(self.topClass)]){
            [_topRefreshView removeFromSuperview];
            _topRefreshView=nil;
            
            Class className=NSClassFromString(self.topClass);
            _topRefreshView=[[className alloc] initWithFrame:currentRect];
        }
        else{
            _topRefreshView.frame=currentRect;
        }
        [_topRefreshView layoutIfNeeded];
        
        if (self.topEnabled && !self.isDisableAddTop && ![[self.scrollView subviews] containsObject:self.topRefreshView]) {
            [self.scrollView addSubview:self.topRefreshView];
        }
        else if (self.isDisableAddTop && [[self.scrollView subviews] containsObject:_topRefreshView]) {
            [_topRefreshView removeFromSuperview];
        }
        
    }
    
}

- (void)initBottonView
{
    
    
    if (!CGRectIsNull(self.scrollView.frame))
    {
        CGFloat y=MAX(self.scrollView.bounds.size.height, self.scrollView.contentSize.height);
        
        CGRect currentRect=CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+45);
        
        if (_bottomRefreshView==nil) {
            NSString *classNameString=NSStringFromClass([DJRefreshBottomView class]);
            if (self.bottomClass) {
                classNameString=self.bottomClass;
            }
            Class className=NSClassFromString(classNameString);
            _bottomRefreshView=[[className alloc] initWithFrame:currentRect];
            
        }else if (self.bottomClass && ![self.bottomRefreshView isKindOfClass:NSClassFromString(self.bottomClass)]){
            [_bottomRefreshView removeFromSuperview];

            Class className=NSClassFromString(self.bottomClass);
            _bottomRefreshView=[[className alloc] initWithFrame:currentRect];
        }
        else{
            _bottomRefreshView.frame=currentRect;
        }
        [_bottomRefreshView layoutIfNeeded];
        
        if (self.bottomEnabled && !self.isDisableAddBottom && ![[self.scrollView subviews] containsObject:_bottomRefreshView]) {
            [self.scrollView addSubview:_bottomRefreshView];
        }
        else if (self.isDisableAddBottom && [[self.scrollView subviews] containsObject:_bottomRefreshView]) {
            [_bottomRefreshView removeFromSuperview];
        }
        
    }
    
    
}


- (void)setIsDisableAddTop:(BOOL)isDisableAddTop{
    _isDisableAddTop=isDisableAddTop;
    if (_isDisableAddTop && [[self.scrollView subviews] containsObject:self.topRefreshView]) {
        [self.topRefreshView removeFromSuperview];
    }
}

- (void)setIsDisableAddBottom:(BOOL)isDisableAddBottom{
    
    _isDisableAddBottom=isDisableAddBottom;
    if (_isDisableAddBottom && [[self.scrollView subviews] containsObject:self.bottomRefreshView]) {
        [self.bottomRefreshView removeFromSuperview];
    }
    
}


- (void)setTopEnabled:(BOOL)topEnabled
{
    _topEnabled=topEnabled;
    
    if (_topEnabled)
    {
        if (self.topRefreshView==nil)
        {
            [self initTopView];
        }

    }
    else{
        [self.topRefreshView removeFromSuperview];
        self.topRefreshView=nil;
    }
    
}

- (void)setBottomEnabled:(BOOL)bottomEnabled
{
    _bottomEnabled=bottomEnabled;
    
    if (_bottomEnabled)
    {
        if (_bottomRefreshView==nil)
        {
            [self initBottonView];
        }
    }
    else{
        [_bottomRefreshView removeFromSuperview];
        _bottomRefreshView=nil;
    }
    
}


- (void)startRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
{
    [self _startRefreshingDirection:direction animation:animation];
    
}

- (void)finishRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation{
    [self _finishRefreshingDirection:direction animation:animation];
}





@end
