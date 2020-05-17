//
//  Const.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/11.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import UIKit

let kWhite       = UIColor.white
let kRed         = UIColor.red
let kOrange      = UIColor.orange
let kBlack       = UIColor.black
let kGreen       = UIColor.green
let kPurple      = UIColor.purple
let kBlue        = UIColor.blue

// 状态栏高度
let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
// 导航栏高度
let kNavBarHeight: CGFloat = 44.0
// 顶部高度 （状态栏+导航栏）
let topBarHeight:CGFloat = kStatusBarHeight+kNavBarHeight


let isIphoneX = screenHeight >= 812 ? true : false
// 设备宽度
let screenWidth = UIScreen.main.bounds.width
// 设备高度
let screenHeight = UIScreen.main.bounds.height
// 自定义索引值
let kBaseTarget : Int = 1000
// 宽度比
let kWidthRatio = screenWidth / 414.0
// 高度比
let kHeightRatio = screenHeight / 896.0
// 自适应
func Adapt(_ value : CGFloat) -> CGFloat {
    
    return AdaptW(value)
}
// 自适应宽度
func AdaptW(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kWidthRatio
}
// 自适应高度
func AdaptH(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kHeightRatio
}
func AdaptX(_ value: CGFloat) -> CGFloat {
    return isIphoneX ? (value.fit + 48.fit):(value.fit)
}
// 常规字体
func FontSize(_ size : CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: AdaptW(size))
}
// 加粗字体
func BoldFontSize(_ size : CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: AdaptW(size))
}
// 随机颜色
let romdomColor = [UIColor.init(r: 176, g: 194, b: 225),UIColor.init(r: 156, g: 202, b: 171),UIColor.init(r: 193, g: 185, b: 226),UIColor.init(r: 152, g: 205, b: 222)]
