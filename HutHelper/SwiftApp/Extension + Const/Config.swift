//
//  Config.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/12.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation


// 根据文字 获取 content 高度
 func getTextHeight(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
    let normalText: NSString = textStr as NSString
    let size = CGSize(width: width, height: 3000)
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    let stringSize = normalText.boundingRect(with: size,options: .usesLineFragmentOrigin, attributes: (dic as! [NSAttributedString.Key : Any]) , context:nil).size
    return stringSize.height
}
//方法
func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
    return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }

