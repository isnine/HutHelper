//
//  HomeViewController+Action.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/27.
//  Copyright © 2020 nine. All rights reserved.
//

import Foundation

let LIBRARY = "图书馆"
let HAND = "二手市场"
let LOST = "失物招领"
let POWER = "查电费"
let ROOM = "空教室"
let SCROE = "成绩查询"
let EXAM = "考试查询"
let CONFERENCES = "宣讲会"

// MARK: - 功能按钮 回调
extension HomeViewController:HomeFuncsCellDelegate {
    func cellItemClick(with data: HomeFuncsModel) {
        var VC = UIViewController()
        switch data.iconName {
        case LIBRARY:
            VC = BaseWebController(webURL: getLibraryAPI, navTitle: "图书馆（需连接校园WIFI）")
        case HAND:
            VC =  HandTableViewController()
        case LOST:
            VC = LostViewController()
        case POWER:
            VC = UIViewController() // TODO
        case ROOM:
            VC = BaseWebController(webURL: getEmptyRoomAPI, navTitle: "空教室")
        case SCROE:
            VC = BaseWebController(webURL: getScoreAPI, navTitle: "成绩查询")
        case EXAM:
            VC = BaseWebController(webURL: getExamAPI, navTitle: "考试计划")
        case CONFERENCES:
            VC = UIViewController()
        default:
            break;
        }
        self.navigationController?.pushViewController(VC, animated: true);
    }
}

// MARK: - 校园新闻 回调
extension HomeViewController:HomeSchoolNewsCelldelegate {
    func cellClickCallBack(with data: HomeSchoolNewsModel) {
        print(data.name)
    }
}
