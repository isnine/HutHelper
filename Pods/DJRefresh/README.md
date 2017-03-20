DJRefresh
==============

[DJRefresh]('https://github.com/ydj/DJRefresh') 是一个下拉刷新，上拉加载更多的组件
系统支持`iOS6+`
支持横竖屏切换，支持自定义下拉`View`和加载`View`，继承自`UIScrollView`的控件都可以使用,支持`UIWebView`下拉刷新

![](/example.gif)


### 使用简单
```
	///初始化
    _refresh=[[DJRefresh alloc] initWithScrollView:tableView delegate:self];
    ///设置显示下拉刷新
    _refresh.topEnabled=YES;
    ///显示加载更多
    _refresh.bottomEnabled=YES;

```
实现代理方法，去刷新或者加载数据
```
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection) direction
```
或 设置调用方法在Block回调进行操作
```
- (void)didRefreshCompletionBlock:(DJRefreshCompletionBlock)completionBlock;
```

###自定义加载样式
支持自定义样式，只需要继承`DJRefreshView` 注册一下该类即可.
如自定义的控件是`SampleRefreshView ` ：
```
 ///注册自定义的下拉刷新view
 [_refresh registerClassForTopView:[SampleRefreshView class]];
```

####其他
  	1.设置下拉改变状态的位置`enableInsetTop` 默认65.0
  	2.设置上拉改变状态的位置`enableInsetBottom` 默认65.0
	3.下拉到指定位置自动刷新`autoRefreshTop`  默认NO
	4.上拉到指定位置自动加载`autoRefreshBottom`  默认NO
	

####协议
DJRefresh 被许可在 MIT 协议下使用。查阅 LICENSE 文件来获得更多信息。


 


