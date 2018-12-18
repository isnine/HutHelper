//
//  RedDotManager.swift
//  HutHelper
//
//  Created by nine on 2018/12/18.
//  Copyright © 2018 nine. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class RedDotManager: NSObject {
    static let hashKey = "kMoreDataHash"
    static func saveVersion(_ Version: Int) {
//        print("保存\(Version)")
        UserDefaults.standard.set(Version, forKey: hashKey)
    }
    static public func getHash(_ handle: ((Bool)->Void)?) {
        Alamofire.request("https://img.wxz.name/api/more.json").responseJSON{(responds) in
            guard responds.result.isSuccess else { return }
            if let value = responds.result.value {
                handle?(UserDefaults.standard.integer(forKey: hashKey) == JSON(value)["version"].intValue)
//                print(JSON(value)["version"].intValue)
//                print(UserDefaults.standard.integer(forKey: hashKey))
            }
    }
}
}
