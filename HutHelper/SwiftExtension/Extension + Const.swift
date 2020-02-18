//
//  Extension + Const.swift
//  HutHelper
//
//  Created by 张驰 on 2019/11/19.
//  Copyright © 2019 nine. All rights reserved.
//

import Foundation

public extension Array {
    
    /**
     Returns a random element from the array. Can be used to create a playful
     message that cycles randomly through a set of emoji icons, for example.
     */
    func sm_random() -> Iterator.Element? {
        guard count > 0 else { return nil }
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}

extension UIView{
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOpacity:Float{
        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable
    var shadowColor:UIColor{
        get{
            return (layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) :nil)!
        }
        set{
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor {
        get {
            return (layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) :nil)!
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
}
