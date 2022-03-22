# HutHelper - 工大助手
[![Build Status](https://travis-ci.com/isnine/HutHelper.svg?branch=master)](https://travis-ci.com/isnine/HutHelper)
![](https://img.shields.io/badge/lanuage-Objective--C-brightgreen.svg)
![](https://img.shields.io/badge/license-apache-green.svg)
# Description
- 工大助手是湖南工业大学计算机学院实验室为工大学子开发的一款校园App。
- 目前iOS端用户量4000人左右，Android端用户9000人左右。Web端日浏览量在3W左右。
- 本仓库为工大助手iOS端源码仓库，任何人都可以发起PR，CI会自动编译发布到TestFlight
- iOS端下载: [AppStore](https://itunes.apple.com/cn/app/gong-da-zhu-shou-hu-nan-gong/id1164848835)
- 开发者博客:[Nine's Blog](https://www.wxz.name)

# Get Started
```
git clone https://github.com/isnine/HutHelper-Open.git --depth=1
```
master为线上代码，安全原因暂不提供测试账号。
建议切换到PublicDemo分支，有本地的假数据可以浏览

# 开发流程
## 团队内成员
1. 从master拉出新分支feature/xxxx开发，开发完毕后提交上来git push origin feature/xxxx
2. 在页面发起合并至master，ci会自动打包出Test Flight版本内测
3. 从master拉出release/{版本号},ci会自动打包发布至App Store。
# 团队外成员
1. fork仓库，在自己仓库开发，然后发起pull request合并至master
2. 后面步骤和之前一样
	
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
![image](https://user-images.githubusercontent.com/16702489/159399734-5f5a117f-b17a-41e1-8eca-d6691a3d3123.png)

# License
[LGPL](https://github.com/isnine/HutHelper-Open/blob/master/LICENSE)



