//
//  HomeModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/14.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import HandyJSON

struct CalendarModel: HandyJSON {
    var days = 0
    var date = ""
    var name = ""
}

class VersionModel: NSObject {
    var calendar_url = ""
    var moment_types = [String]()
    var banner_pics = [String]()
    var map_url = ""
    var school_opens = ""
    var im_msg_count = ""

    init(dic Dic: [AnyHashable: Any]?) {
        super.init()
        calendar_url = Dic?["calendar_url"] as? String ?? ""
        moment_types = Dic?["moment_types"] as? [String] ?? []
        banner_pics = Dic?["banner_pics"] as? [String] ?? []
        map_url = Dic?["map_url"] as? String ?? ""
        school_opens = Dic?["school_opens"] as? String ?? ""
        im_msg_count = Dic?["im_msg_count"] as? String ?? ""
    }
}
