//
//  MainViewModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/13.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import HandyJSON
import SwiftyJSON

class MainViewModel {
    var calendarData = [CalendarModel]()
}

// MARK: 网络请求

extension MainViewModel {
    func getCalender(callback: @escaping () -> ()){
        HomePageProvider.request(.calendar) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<CalendarModel>.deserializeModelArrayFrom(json:json.description) {
                        self.calendarData = datas as! [CalendarModel]
                        callback()
                    }
                }
            }
        }
    }
    // 版本请求
    func getVersionIOS(callback: @escaping (JSON) -> ()) {
        HomePageProvider.request(.versioniOS) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                   // print(json)
                    if json["code"] == "200" {
                        callback(json["data"])
                    }
                }
            }
        }
    }
    // 暂时弃用
    func getClass(callback: @escaping () -> ()) {
        HomePageProvider.request(.course) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if json["code"] == 200 {
                        Config.saveCourse(json["data"].arrayValue)
                        Config.saveWidgetCourse(json["data"].arrayValue)
                        callback()
                    }
                }
            }
        }
    }
}
