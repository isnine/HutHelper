# EachNavigationBar

[![License](https://img.shields.io/cocoapods/l/EachNavigationBar.svg?style=flat)](http://cocoapods.org/pods/EachNavigationBar)
[![Platform](https://img.shields.io/cocoapods/p/EachNavigationBar.svg?style=flat)](https://cocoapods.org/pods/EachNavigationBar)

注意，该版本为原作者EachNavigationBar （https://github.com/Pircate/EachNavigationBar） V1.11.0 版本进行修改。  
注意，该版本为原作者EachNavigationBar （https://github.com/Pircate/EachNavigationBar） V1.11.0 版本进行修改。  
注意，该版本为原作者EachNavigationBar （https://github.com/Pircate/EachNavigationBar） V1.11.0 版本进行修改。

-------（该版本只在1.11.0上修改了对iOS13的支持，原作者后续的特性更新在该副本是没有的，如需使用新特性，请移步上面GitHub原作者地址，使用最新版本。谢谢。）（如有侵权，及时联系，我马上删除，谢谢）


   由于原作者在1.11.0之后发布的版本移除了对OC的支持，后续版本不支持OC进行编译，只支持swift。  
   由于此前我接入该项目时候使用的是OC，所以只能在版本上停留在1.11.0，由于iOS13的更新，1.11.0使用会Crash，所以修改了原1.11.0代码，使项目支持iOS13。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 9.0
* Swift 4.2

## Installation

EachNavigationBar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile or Cartfile:

#### Podfile

```ruby
//pod 最新版本 原作者版本（https://github.com/Pircate/EachNavigationBar）
pod 'EachNavigationBar'

//使用修改版 
pod 'EachNavigationBar_Objc'
```

## Overview

![](https://github.com/Pircate/EachNavigationBar/blob/master/demo_new.gif)
![](https://github.com/Pircate/EachNavigationBar/blob/master/demo_push.gif)

## Usage

### Import

Swift
``` swift
import EachNavigationBar
```
Objective-C
``` ObjC
@import EachNavigationBar;
```

### Enable

Swift
``` swift
let nav = UINavigationController(rootViewController: vc)
nav.navigation.configuration.isEnabled = true
```

Objective-C
``` ObjC
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
nav.navigation_configuration.isEnabled = YES;
```

### Setting
#### Global

Swift
``` swift
nav.navigation.configuration.titleTextAttributes = [.foregroundColor: UIColor.blue]

nav.navigation.configuration.barTintColor = UIColor.red

nav.navigation.configuration.shadowImage = UIImage(named: "shadow")

nav.navigation.configuration.backBarButtonItem = .init(style: .image(UIImage(named: "back")), tintColor: UIColor.red)

nav.navigation.configuration.setBackgroundImage(UIImage(named: "nav"), for: .any, barMetrics: .default)
```

Objective-C
``` ObjC
nav.navigation_configuration.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blueColor};

nav.navigation_configuration.barTintColor = UIColor.redColor;

nav.navigation_configuration.shadowImage = [UIImage imageNamed:@"shadow"];

nav.navigation_configuration.backBarButtonItem = [[BackBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]];

[nav.navigation_configuration setBackgroundImage:[UIImage imageNamed:@"nav"] for:UIBarPositionAny barMetrics:UIBarMetricsDefault];
```

#### Each view controller
##### Normal

Swift
``` swift
navigation.bar  -> EachNavigationBar -> UINavigationBar
navigation.item -> UINavigationItem

// hide navigation bar
navigation.bar.isHidden = true

// set bar alpha
navigation.bar.alpha = 0.5

// set title alpha
navigation.bar.setTitleAlpha(0.5)

// set barButtonItem alpha
navigation.bar.setTintAlpha(0.5)
// if barButtonItem is customView
navigation.item.leftBarButtonItem?.customView?.alpha = 0.5
// if barButtonItem customized tintColor
navigation.item.leftBarButtonItem?.tintColor = navigation.item.leftBarButtonItem?.tintColor?.withAlphaComponent(0.5)

// remove blur effect
navigation.bar.isTranslucent = false

// hides shadow image
navigation.bar.isShadowHidden = true

// set status bar style
navigation.bar.statusBarStyle = .lightContent

// set back bar button item
navigation.bar.backBarButtonItem = .init(style: .title("Back"), tintColor: .red)

// allow back
navigation.bar.backBarButtonItem.shouldBack = { item in
    // do something
    return false
}

// handler before back
navigation.bar.backBarButtonItem.willBack = {
    // do something
}

// handler after back
navigation.bar.backBarButtonItem.didBack = {
    // do something
}

// if you want change navigation bar position
navigation.bar.automaticallyAdjustsPosition = false

// navigation bar additional height
navigation.bar.additionalHeight = 14

// navigation bar additional view
navigation.bar.additionalView = UIView()

// item padding
navigation.bar.layoutPaddings = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

// shadow
navigation.bar.shadow = Shadow(
    color: UIColor.black.cgColor,
    opacity: 0.5,
    offset: CGSize(width: 0, height: 3))
```

Objective-C
``` ObjC
self.navigation_bar.xxx
self.navigation_item.xxx
```

##### LargeTitle(iOS 11.0+)

UINavigationController
``` swift
// enable
nav.navigation.prefersLargeTitles()
```
UIViewController
```swift
// show or hide
navigation.bar.prefersLargeTitles = true

// alpha
navigation.bar.setLargeTitleAlpha(0.5)
```

## Author

原作者信息：
Pircate, gao497868860@163.com

## License

EachNavigationBar is available under the MIT license. See the LICENSE file for more info.
