//
//  MomentModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/15.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import HandyJSON

struct MomentModel: HandyJSON {
    var id = ""
    var user_id = ""
    var content = ""
    var pics = [String]()
    var created_on = ""
    var is_top = ""
    var likes = ""
    var view_cnt = ""
    var username = "北苑皮卡丘"
    var bio = ""
    var dep_name = ""
    var head_pic = ""
    var head_pic_thumb = ""
    var is_like = false
    var type = ""
    var dislike = ""
    var collapse = false
    var comments = [CommentModel]()
}

struct CommentModel: HandyJSON {
    var id = ""
    var moment_id = ""
    var comment = ""
    var user_id = ""
    var created_on = ""
    var username = ""
}
