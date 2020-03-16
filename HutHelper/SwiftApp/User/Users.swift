//
//  User.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/11.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation

class Users: NSObject {
    //*用户id
    var user_id = 0
    //*学号
    var studentKH = ""
    //*高中学校
    var school = ""
    //*姓名
    var TrueName = ""
    //*昵称
    var username = ""
    //*学院
    var dep_name = ""
    //*班级
    var class_name = ""
    //*省份
    var address = ""
    //*性别
    var active = ""
    //*最后一次登录
    var last_use = ""
    //*签名
    var bio = ""
    //*头像无压缩
    var head_pic = ""
    //*头像
    var head_pic_thumb = ""
    //*token
    var remember_code_app = ""

    
    init(dic Dic: [AnyHashable : Any]?) {
        super.init()
        TrueName = Dic?["TrueName"] as? String ?? ""
        address = Dic?["address"] as? String ?? ""
        class_name = Dic?["class_name"] as? String ?? ""
        dep_name = Dic?["dep_name"] as? String ?? ""
        head_pic = Dic?["head_pic"] as? String ?? ""
        head_pic_thumb = Dic?["head_pic_thumb"] as? String ?? ""
        last_use = Dic?["last_login"] as? String ?? ""
        studentKH = Dic?["studentKH"] as? String ?? ""
        username = Dic?["username"] as? String ?? ""
        user_id = Dic?["user_id"] as? Int ?? 0
        active = Dic?["active"] as? String ?? ""
        remember_code_app = Dic?["remember_code_app"] as? String ?? ""
        bio = Dic?["bio"] as? String ?? ""
        
    }
}
struct ClassModel {
    var depName = ""
    var classes = [""]
}
