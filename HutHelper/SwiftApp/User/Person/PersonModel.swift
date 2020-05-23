//
//  PersonModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/22.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import HandyJSON

struct PersonModel {
    var headImg = ""
    var name = ""
    var bio = ""
    var depname = ""
    var userId = ""
}

struct PeopleModel: HandyJSON {
    var studentKH = ""
    var dep_name = ""
    var class_name = ""
    var user_id = ""
    var head_pic = ""
    var username = ""
    var bio = ""
    var head_pic_thumb = ""
}
