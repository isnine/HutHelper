//
//  Extension.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/12.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CommonCrypto

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        let newData = NSData.init(data: data)
        CC_SHA1(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
        }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }

    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }

    class func globalCyanColor() -> UIColor {
        return UIColor(r: 7, g: 216, b: 243)
    }
}

extension Double {
    var fit: CGFloat {
        return CGFloat(self/414.0) * UIScreen.main.bounds.width
    }
    var fitW: CGFloat {
        return CGFloat(self/414.0) * UIScreen.main.bounds.width
    }
    var fitH: CGFloat {
        return CGFloat(self/896.0) * UIScreen.main.bounds.width
    }
}
extension Int {
//    var fit: Int {
//        return Int(CGFloat(self)/414.0 * UIScreen.main.bounds.width)
//    }
    var fitW: Int {
        return Int(CGFloat(self)/414.0 * UIScreen.main.bounds.width)
    }
    var fitH: Int {
        return Int(CGFloat(self)/896.0 * UIScreen.main.bounds.width)
    }
}
extension CGFloat {
    var fitScreen: CGFloat {
        return CGFloat(self/414.0 * UIScreen.main.bounds.size.width)
    }
    var fit: CGFloat {
        return CGFloat(self/414.0) * UIScreen.main.bounds.width
    }
    var fitW: CGFloat {
        return CGFloat(self/414.0) * UIScreen.main.bounds.width
    }
    var fitH: CGFloat {
        return CGFloat(self/896.0) * UIScreen.main.bounds.width
    }
}

extension CGRect {
    var fit: CGRect {
        return CGRect(x: self.minX.fitScreen, y: self.minY.fitScreen, width: self.width.fitScreen, height: self.height.fitScreen)
    }
}
extension CGSize {
    var fit: CGSize {
        return CGSize(width: self.width.fitScreen, height: self.height.fitScreen)
    }
}

//extension UIView{
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
//    @IBInspectable
//    var shadowOpacity:Float{
//        get{
//            return layer.shadowOpacity
//        }
//        set{
//            layer.shadowOpacity = newValue
//        }
//    }
//    @IBInspectable
//    var shadowColor:UIColor{
//        get{
//            return (layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) :nil)!
//        }
//        set{
//            layer.shadowColor = newValue.cgColor
//        }
//    }
//
//    @IBInspectable
//    var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//    @IBInspectable
//    var borderColor: UIColor {
//        get {
//            return (layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) :nil)!
//        }
//        set {
//            layer.borderColor = newValue.cgColor
//        }
//    }
//
//}

extension UIView {

    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

    }
}
extension UIImage {
    /**
     根据传入的宽度生成一张图片
     按照图片的宽高比来压缩以前的图片
     :param: width 制定宽度
     */
    func imageWithScale(width: CGFloat) -> UIImage {
        // 1.根据宽度计算高度
        let height = width *  size.height / size.width
        // 2.按照宽高比绘制一张新的图片
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        draw(in: CGRect(origin: CGPoint.zero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension UIView {

    /// 快速创建 View 并使用 SnapKit 布局
    ///
    /// - Parameters:
    ///   - bgClor: View 的背景颜色
    ///   - supView: 父视图
    ///   - closure: 约束
    /// - Returns:  View
    class func tk_createView(bgClor: UIColor, supView: UIView?, closure:(_ make: ConstraintMaker) ->Void) -> UIView {
        let view = UIView()
        view.backgroundColor = bgClor
        if supView != nil {
            supView?.addSubview(view)
            view.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return view
    }

    /// 快速创建一个 UIImageView,可以设置 imageName,contentMode,父视图,约束
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - contentMode: 填充模式
    ///   - supView: 父视图
    ///   - closure: 约束
    /// - Returns:  UIImageView
    class func tk_createImageView(imageName: String?, contentMode: UIView.ContentMode? = nil, supView: UIView?, closure:(_ make: ConstraintMaker) ->Void) -> UIImageView {

        let imageV = UIImageView()

        if imageName != nil {
            imageV.image = UIImage(named: imageName!)
        }

        if contentMode != nil {
            imageV.contentMode = contentMode!
        }

        if supView != nil {
            supView?.addSubview(imageV)
            imageV.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return imageV
    }

    /// 快速创建 Label,设置文本, 文本颜色,Font,文本位置,父视图,约束
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - font: 字体大小
    ///   - textAlignment: 文本位置
    ///   - supView: 父视图
    ///   - closure: 越是
    /// - Returns:  UILabel
    class func tk_createLabel(text: String?, textColor: UIColor?, font: UIFont?, textAlignment: NSTextAlignment = .left, supView: UIView?, closure:(_ make: ConstraintMaker) ->Void) -> UILabel {

        let label = UILabel()
        label.text = text
        if textColor != nil { label.textColor = textColor }
        if font != nil { label.font = font }
        label.textAlignment = textAlignment

        if supView != nil {
            supView?.addSubview(label)
            label.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return label
    }

    /// 快速创建 UIButton,设置标题,图片,父视图,约束
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleStatu: 标题状态模式
    ///   - imageName: 图片名
    ///   - imageStatu: 图片状态模式
    ///   - supView: 父视图
    ///   - closure: 约束
    /// - Returns:  UIButton
    class func tk_createButton(title: String?, titleStatu: UIControl.State?, titleColor: UIColor? = nil, imageName: String?, imageStatu: UIControl.State?, font: UIFont? = FontSize(14), supView: UIView?, closure:(_ make: ConstraintMaker) ->Void) -> UIButton {
        let btn = UIButton()

        if title != nil {
            btn.setTitle(title, for: .normal)
        }

        if title != nil && titleStatu != nil {
            btn.setTitle(title, for: titleStatu!)
        }

        if imageName != nil {
            btn.setImage(UIImage(named: imageName!), for: .normal)
        }

        if imageName != nil && imageStatu != nil {
            btn.setImage(UIImage(named: imageName!), for: imageStatu!)
        }

        if titleColor != nil {
            btn.setTitleColor(titleColor, for: .normal)
        }
        btn.titleLabel?.font = font
        if supView != nil {
            supView?.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return btn
    }

    /// 快速创建 UITextField,设置文本,文本颜色,placeholder,字体大小,文本位置,边框样式, 自动布局
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - placeholder: placeholder
    ///   - font: 字体大小
    ///   - textAlignment: 文本位置
    ///   - borderStyle: 边框样式
    ///   - supView: 父视图
    ///   - closure:  make
    /// - Returns: UITextField
    class func tk_createTextField(text: String?, textColor: UIColor?, placeholder: String, font: UIFont?, textAlignment: NSTextAlignment = .left, borderStyle: UITextField.BorderStyle = .none, supView: UIView?, closure:(_ make: ConstraintMaker) ->Void) -> UITextField {

        let textField = UITextField()
        textField.text = text
        textField.placeholder = placeholder
        textField.borderStyle = borderStyle
        if textColor != nil { textField.textColor = textColor }
        if font != nil { textField.font = font }

        textField.textAlignment = textAlignment

        if supView != nil {
            supView?.addSubview(textField)
            textField.snp.makeConstraints { (make) in
                closure(make)
            }
        }
        return textField
    }

    
}
extension UITextView {

    func appendLinkString(string:String, withURLString:String = "") -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : self.font!]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
            appendString.addAttribute(NSAttributedString.Key.strokeWidth, value:-4.0, range:range)
            if withURLString == "user:comment" {
                appendString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.init(r: 29, g: 203, b: 219), range: range)
            }else if withURLString == "delete:comment"{
                appendString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.red, range: range)
            }

            appendString.endEditing()
        }

        return appendString
    }
}
