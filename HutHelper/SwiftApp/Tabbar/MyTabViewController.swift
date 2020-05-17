//
//  MyTabViewController.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/18.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import QuartzCore



class MyTabViewController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewControllers()

    }
    
    /// 配置子控制器
    private func configViewControllers() {
        
        let homeVC = HomeViewController()
        let momentVC = MomentViewController()
        let courseVC = MainViewController()
        let messegeVC =  BaseWebController(webURL: getImWebUrl, navTitle: "消息")
        let mineVC = UserController()
        
        
        homeVC.tabBarItem = ESTabBarItem.init(YYIrregularityBasicContentView(), title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        momentVC.tabBarItem = ESTabBarItem.init(YYIrregularityBasicContentView(), title: "我听", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        courseVC.tabBarItem = ESTabBarItem.init(YYIrregularityBasicContentView(), title: "课表", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        messegeVC.tabBarItem = ESTabBarItem.init(YYIrregularityBasicContentView(), title: "发现", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        mineVC.tabBarItem = ESTabBarItem.init(YYIrregularityBasicContentView(), title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        let homeNav = YYNavigationController.init(rootViewController: homeVC)
        homeNav.navigation.configuration.isEnabled = true;
        let momentNav = YYNavigationController.init(rootViewController: momentVC)
        momentNav.navigation.configuration.isEnabled = true;
        let courseNav = YYNavigationController.init(rootViewController: courseVC)
        courseNav.navigation.configuration.isEnabled = true;
        let messegeNav = YYNavigationController.init(rootViewController: messegeVC)
        messegeNav.navigation.configuration.isEnabled = true;
        let mineNav = YYNavigationController.init(rootViewController: mineVC)
        mineNav.navigation.configuration.isEnabled = true;
        self.viewControllers = [homeNav, momentNav, courseNav, messegeNav, mineNav]
        self.selectedIndex = 0
        
    }
    

 
}


class YYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //  setNavBarAppearence()
    }
}
//    func setNavBarAppearence()
//    {
//        // 设置导航栏默认的背景颜色
//        WRNavigationBar.defaultNavBarBarTintColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
//        // 设置导航栏所有按钮的默认颜色
//        WRNavigationBar.defaultNavBarTintColor = DominantColor
//        // 设置导航栏标题默认颜色
//        WRNavigationBar.defaultNavBarTitleColor = .black
//        // 统一设置状态栏样式
////        WRNavigationBar.defaultStatusBarStyle = .lightContent
//        // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
//        WRNavigationBar.defaultShadowImageHidden = true
//
//    }
extension YYNavigationController
{
    override func pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

class YYBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class YYBouncesContentView: YYBasicContentView {
    public var duration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}
class YYIrregularityBasicContentView: YYBouncesContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YYIrregularityContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.backgroundColor = UIColor.init(red: 250/255.0, green: 48/255.0, blue: 32/255.0, alpha: 1.0)
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.borderColor = UIColor.init(white: 235 / 255.0, alpha: 1.0).cgColor
        self.imageView.layer.cornerRadius = 25
        self.insets = UIEdgeInsets(top: -23, left: 0, bottom: 0, right: 0)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        self.superview?.bringSubviewToFront(self)
        
        textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        backdropColor = .clear
        highlightBackdropColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }

    override func updateLayout() {
        super.updateLayout()
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }
}
