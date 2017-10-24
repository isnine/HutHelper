# HutHelper - 工大助手
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
![](https://img.shields.io/badge/lanuage-Objective--C-brightgreen.svg)
![](https://img.shields.io/badge/pod-1.1.1-red.svg)
![](https://img.shields.io/badge/license-apache-green.svg)

![海报](https://img.wxz.name/海报.jpg?imageView2/2/w/302/h/540/interlace/0/q/41)
# Description
- 工大助手是湖南工业大学计算机学院实验室为工大学子开发的一款校园App。
- 目前iOS端用户量4000人左右，Android端用户9000人左右。Web端日浏览量在3W左右。
- 本仓库为工大助手iOS端，除接口文件不同，其余与线上版本一致。
- iOS端下载: [AppStore](https://itunes.apple.com/cn/app/gong-da-zhu-shou-hu-nan-gong/id1164848835)
- Android端下载: [工大助手](https://huthelper.cn/res/index)
- Win10端下载: [工大助手](https://huthelper.cn/res/index)
- 微信小程序: [工大助手](https://huthelper.cn/res/index)
- 开发者博客:[Nine's Blog](https://www.wxz.name)

# Get Started
```
git clone https://github.com/isnine/HutHelper-Open.git --depth=1
```
接口与线上版本不同，登录界面输入任意账号和密码，即可登录，因工程较大，建议只克隆第一层
# Frame
```
.
	├── HutHelper
	│   ├── Application：接口，配置文件
	│   ├── Utils：一些工具类等
	│   ├── Vendor：一些没有通过Pod管理的三方库
	│   ├── Models：数据模型
	│   ├── View：界面，xib或者storyboard之类的文件
	│   ├── Supporting Files：一些支持文件
	│   └── Controllers
	│       ├── Main：主界面
	│       ├── Login：登录界面
	│       ├── Score：考试成绩
	│       ├── Class：平时课表
	│       ├── CourseXp：实验课表
	│       ├── Moments：校园说说
	│       ├── Exam：考试计划查询
	│       ├── User：用户界面
	│       ├── Lost：失物招领界面
	│       ├── Feedback：反馈界面
	│       └── Hand：二手市场界面
	├── Extend:课程表Widget
	└── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具
	└── JSON:接口数据
```

## Features
- [x] 成绩查询
- [x] 考试查询
- [x] 电费查询
- [x] 网上作业
- [x] 二手市场
- [x] 校园说说
- [x] 实验课表
- [x] 失物招领
- [x] 视频专栏
- [x] 图书馆
- [x] 校历
- [x] 即时聊天
- [ ] 老乡查找
- [ ] 校园活动
# Screenshot
![start-1](https://img.wxz.name/start-1.jpg?imageView2/2/w/252/h/450/interlace/0/q/41)
![9.7](https://img.wxz.name/9.7.jpg?imageView2/2/w/252/h/450/interlace/0/q/41)
![首页](https://img.wxz.name/首页.jpg?imageView2/2/w/252/h/450/interlace/0/q/41)

![IMG_2171](https://img.wxz.name/IMG_2171.PNG?imageView2/2/w/252/h/450/interlace/0/q/41)
![IMG_2173](https://img.wxz.name/IMG_2173.PNG?imageView2/2/w/252/h/450/interlace/0/q/41)
![IMG_2174](https://img.wxz.name/IMG_2174.PNG?imageView2/2/w/252/h/450/interlace/0/q/41)

![成绩](http://img.wxz.name/github/20170426151539_trlelR_IMG_0900.png?imageView2/2/w/252/h/450/interlace/0/q/41)
![成绩列表](https://img.wxz.name/成绩列表.jpg?imageView2/2/w/252/h/450/interlace/0/q/41)
![实验课表](https://img.wxz.name/实验课表.jpg?imageView2/2/w/252/h/450/interlace/0/q/41)


![](http://img.wxz.name/github/20170426151539_Z47HZw_IMG_0904.png?imageView2/2/w/252/h/450/interlace/0/q/41)
![课程表](http://img.wxz.name/github/20170426151539_FSbFF5_IMG_0898.png?imageView2/2/w/252/h/450/interlace/0/q/41)
![图书馆](http://img.wxz.name/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.41.19.png?imageView2/2/w/252/h/450/interlace/0/q/41)

![IMG_2170](https://img.wxz.name/IMG_2170.PNG?imageView2/2/w/252/h/450/interlace/0/q/41)
![](http://img.wxz.name/github/20170426151539_zK1rOn_IMG_0906.png?imageView2/2/w/252/h/450/interlace/0/q/41)
![](http://img.wxz.name/github/20170426151539_3MUsyQ_IMG_0907.png?imageView2/2/w/252/h/450/interlace/0/q/41)


# License
[LGPL](https://github.com/isnine/HutHelper-Open/blob/master/LICENSE)



