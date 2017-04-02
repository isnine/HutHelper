# 湖南工业大学校园助手iOS端
![76@2x](https://o90qqsid7.qnssl.com/76@2x-1.png)
# 项目总体概况
- 截止到17年3月18日，iOS端用户量已经达到3000人，另外Android端用户量已过8000,主要使用对象为湖南工业大学学生，覆盖全校60%以上人群。
- iOS端开发语言采用Objective-C，开发软件为Xcode，适配iOS8以上系统。
- 此仓库为工大助手开源版本，与线上版本除了HUTAPI.h接口文件不同，其他全部一样。
- 目前大二在读，代码将实时更新在Github，目前正在努力重构，如果有建议希望能在Issues中指出

- iOS端下载方式: [AppStore](https://itunes.apple.com/cn/app/gong-da-zhu-shou-hu-nan-gong/id1164848835)
- Android端下载: [工大助手](http://hugongda.top:8888/res/app/)
- Win10端下载: [工大助手](http://hugongda.top:8888/res/app/)
- Web端:[工大导航](http://hugongda.top:8888/)
- 开发者博客:[Nine's Blog](http://www.wxz.name)

# 近期更新
## V1.9.9   2017.3.20
- 修改了校园说说配色
- 修改了校园说说相同课程相同颜色
- 新增了切换用户提示语

## V1.9.8   2017.3.8
- 重构了校园说说，流畅度提升160%
- 若干小的Bug

## V1.9.7   2017.2.23
- 增加了二手市场-我的发布
- 增加了校园说说-我的说说
- 增加了失物招领-我的发布
- 修复了实验课表切换时的Bug
- 修复了二手市场超过页数的Bug
- 修复了通知栏课表时间问题



# 项目框架
```
.
	├── HutHelper
	│   ├── 3rd：因为各种原因没有用Pods管理的第三方库
	│   ├── Utils：一些工具类等
	│   ├── Request：网络请求
	│   ├── Models：数据模型
	│   ├── View：界面，xib或者storyboard之类的文件
	│   ├── Supporting Files：一些支持文件
	│   └── Controllers
	│       ├── Main：主界面
	│       ├── Login：登录界面
	│       ├── Class：课程表
	│       ├── Score：考试成绩
	│       ├── Exam：考试计划查询
	│       ├── User：用户界面
	│       ├── FeedBack：反馈界面
	│       ├── Power：寝室电费查询
	│       ├── Set：用户设置界面
	│       ├── Lost：失物招领界面
	│       ├── Day：校历界面
	│       ├── HomeWork：网上作业界面
	│       ├── Hand：二手市场界面
	│       ├── Library：图书馆界面
	│       ├── Other：其他
	└── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具
	└── json:请求的示例数据
```
## 下载
因文件比较大，建议挂代理Clone，或者只Clone最新版本。
```
git clone --depth=1 https://github.com/isnine/HutHelper-Open.git
```

## 注意事项
- 考虑到在校用户信息的安全性,**App的接口地址全部换成了镜像接口,与线上版本不同**
- 除此之外，一切和上线版本代码全部一致
- 同时因为镜像接口的数据是固定的,所以测试时，**登录界面，无论输入什么，点登录就可以**
- 课程数据,考试数据,用户数据,课表数据,说说数据,二手数据这些也都是固定的
- 请求的数据可以在json文件夹中查看

**如果要进行二次开发，可以直接把请求的地址改成自己后端的地址，然后把接受的数据改一下即可.**

# 上架情况
![](https://o90qqsid7.qnssl.com/14853135352743.jpg)
# 功能介绍
## 登录界面
登录界面采用简洁的方式展示。
用户输入学号和密码后，将通过JSON连接网络，得到Msg信息
如果成功--->存储Json至NSUserDefault
如果失败--->返回Msg提示信息

![登录界面](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2018.56.58.png?imageView2/2/w/400/h/800/interlace/0/q/41)
## 主界面
主界面是直接用xib做的,图片直接使用UI给的图片,另外的话有很多数据是在这个界面初始化的

- viewDidLoad()方法中，需要计算APP打开的此时的周数，并且通过NSUserDefaults类将其数据存储到plist文件中
- 判断是否为第一次登陆，是的话跳转到登陆界面
- 判断设置中是否设置自动打开课程表，是的话跳转到课程表
- 判断用户信息的标签是否上传
- 初始化抽屉界面
- ...

![主界面](https://o90qqsid7.qnssl.com/IMG_1364.png?imageView2/2/w/400/h/800/interlace/0/q/41)


## 成绩查询
- 总体成绩显示

![曲线成绩](https://o90qqsid7.qnssl.com/%E6%88%90%E7%BB%A9%E6%9F%A5%E8%AF%A2.png?imageView2/2/w/400/h/800/interlace/0/q/41)

- 成绩查询

![所有成绩查询](https://o90qqsid7.qnssl.com/%E6%88%90%E7%BB%A9%E6%9F%A5%E8%AF%A2-%E9%80%89%E6%8B%A9%E5%AD%A6%E6%9C%9F.png?imageView2/2/w/400/h/800/interlace/0/q/41)
## 课程表
这里使用了[GWPCourseListView - 课程表界面](https://github.com/GanWenpeng/GWPCourseListView)开源项目，做了一些调整，并且修复了一些bug，开发者已经接受了我的pull。
同时自己集成了[LGPlusButtonsView - 按钮控件](https://github.com/Friend-LGA/LGPlusButtonsView)开源项目的按钮控件，使课程表数据可以上下周的调整。
- 另外加入了实验课程表，可以单独显示，也可以在设置里面设置成一起显示

![课程表](https://o90qqsid7.qnssl.com/IMG_1365.png?imageView2/2/w/400/h/800/interlace/0/q/41)

## 考试计划
考试计划中将显示教务处正在计划和已经确定的考试
用的自定义tableview做的，很简单的绘制一个cell，然后将Json的数据与之交互

![IMG_1366](https://o90qqsid7.qnssl.com/IMG_1366.png?imageView2/2/w/400/h/800/interlace/0/q/41)

## 电费查询
简单的调用接口查询，没什么技术含量

![IMG_1367](https://o90qqsid7.qnssl.com/IMG_1367.png?imageView2/2/w/400/h/800/interlace/0/q/41)

## 校园说说
这个部分最大的问题就是适配的问题,有的图片多，有的文字多，怎么决定这个长度呢
所以我把每条说说分为四个部分，从上往下依次是  用户信息和文字/图片部分/评论数目部分/评论部分
这样首先根据文字的长度，分配第一个cell也就是文字的高度
然后根据图片的部分，分配第二个cell也就是图片的高度

![IMG_1371](https://o90qqsid7.qnssl.com/IMG_1371.png?imageView2/2/w/400/h/800/interlace/0/q/41)
## 二手市场
每个cell显示两个商品，很简单的做法

![IMG_1372](https://o90qqsid7.qnssl.com/IMG_1372.png?imageView2/2/w/400/h/800/interlace/0/q/41)
## 图书馆/校园说说/二手市场/网上作业
这两个部分因为没有接口，所以直接用web端做的

![图书馆](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.41.19.png?imageView2/2/w/400/h/800/interlace/0/q/41)

![网上作业](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.41.41.png?imageView2/2/w/400/h/800/interlace/0/q/41)

# 项目使用的开源项目
- [LeftSlide - 主界面框架](https://github.com/chennyhuang/LeftSlide)
- [MBProgressHUD - 等待框动画](https://github.com/jdg/MBProgressHUD)
- [GWPCourseListView - 课程表界面](https://github.com/GanWenpeng/GWPCourseListView)
- [LGPlusButtonsView - 按钮控件](https://github.com/Friend-LGA/LGPlusButtonsView)
- [UUCharView - 成绩曲线图标](https://github.com/ZhipingYang/UUChartView)
- [SKSTableView - 成绩列表](https://github.com/sakkaras/SKSTableView)
- [TZImagePickerController - 照片选择器]
- [SDWebImage - 异步多图加载]
- [MJRefresh - 上拉下拉刷新]
- [YYModel - Json转Model]
- [AFNetworking - 请求异步加载]
- [UMengUShare - 友盟分享]
- [ASIHTTPRequest - 照片同步上传]

# 最后
这是本人刚进大二,在湖南工业大学实验室写的一款App，目的主要是为湖南工业大学的学生提供一些便利,同时也是湖南省省级项目,App中有很多不足的地方,代码的可读性也不是很好,甚至于最开始的版本，网络请求都是同步请求，没有加载框，很容易卡死。但是不管如何，我都在完善。
这是开源的第一个版本,在后续每当上线版本有大的更新后，我都会同步发布在这里
其目的是，如果有其他学校的同学也需要开发一个服务于自己母校的iOS App，可以从这得到一定的参考
如果有任何问题也可以在issues留言

我的个人网站是[www.wxz.name](www.wxz.name)

**求一个Star鼓励**
# License
[Apache Licene 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)


