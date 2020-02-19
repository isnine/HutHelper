//
//  MomentViewModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/15.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON

class MomentViewModel{
    var momentDatas = [MomentModel]() 
    var page = 1
    
}
// Mark:- 请求数据
extension MomentViewModel {
    func getAllMomentRequst(page:Int,callback:@escaping () -> ()) {
        MomentProvider.request(.all(page)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json:json["statement"].description) {
                        if page == 1 {
                            self.momentDatas = datas as! [MomentModel]
                        }else {
                            for num in datas {
                                self.momentDatas.append(num!)
                            }
                        }
                        print(json)
                        callback()
                    }
                }
            }
        }
    }
    func getLikeMomentRequst(momentId:String,callback:@escaping () -> ()) {
        MomentProvider.request(.like(momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getUnLikeMomentRequst(momentId:String,callback:@escaping () -> ()) {
        MomentProvider.request(.unlike(momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getDeleteMomentRequst(momentId:String,callback:@escaping () -> ()) {
        MomentProvider.request(.delete(momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getDeleteCMomentRequst(commentId:String,callback:@escaping () -> ()) {
        MomentProvider.request(.deleteC(commentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getCommentSayRequst(comment:String,momentId:String, callback:@escaping () -> ()) {
        MomentProvider.request(.comment(comment, momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    
    func getHotMomentRequst(page:Int,day:Int,callback:@escaping () -> ()) {

        MomentProvider.request(.hot(page,day)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json:json["statement"].description) {
                        if page == 1 {
                            self.momentDatas = datas as! [MomentModel]
                        }else {
                            for num in datas {
                                self.momentDatas.append(num!)
                            }
                        }
                        callback()
                    }
                }
            }
        }
    }
    func getOwnMomentRequst(page:Int,userId:String,callback:@escaping () -> ()) {

        MomentProvider.request(.own(page,userId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    print(json)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json:json["statement"].description) {
                        if page == 1 {
                            self.momentDatas = datas as! [MomentModel]
                        }else {
                            for num in datas {
                                self.momentDatas.append(num!)
                            }
                        }
                        print(json)
                        callback()
                    }
                }
            }
        }
    }
    func getInteractiveMomentRequst(page:Int,callback:@escaping () -> ()) {

        MomentProvider.request(.interactive(page)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json:json["statement"].description) {
                        if page == 1 {
                            self.momentDatas = datas as! [MomentModel]
                        }else {
                            for num in datas {
                                self.momentDatas.append(num!)
                            }
                        }
                        callback()
                    }
                }
            }
        }
    }
    func getSearchMomentRequst(content:String,page:Int,callback:@escaping (Bool) -> ()) {

        MomentProvider.request(.search(content, page)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value{
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json:json["statement"].description) {
                        if page == 1 {
                            self.momentDatas = datas as! [MomentModel]
                        }else {
                            for num in datas {
                                self.momentDatas.append(num!)
                            }
                        }
                        if self.momentDatas.count == 0  {
                             callback(true)
                        }else{
                            callback(false)
                        }

                    }
                }
            }
        }
    }
}
