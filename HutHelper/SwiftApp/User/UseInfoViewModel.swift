//
//  UseInfoViewModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/13.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import HandyJSON
import SwiftyJSON

class UseInfoViewModel {
    var classesDatas: [ClassModel] = []

}
// - MARK: 网络请求
extension UseInfoViewModel {
    // 获取所有班级
    func getAllClassesRequst(callback: @escaping () -> Void) {
        Alamofire.request(getAllclassesAPI).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            let value = response.value
            let json = JSON(value!)
            if json["code"] == 200 {
                if let datas = json["data"].dictionaryObject {
                    for (key, value) in datas {
                        var data = ClassModel()
                        data.depName = key
                        data.classes = value as! [String]
                        self.classesDatas.append(data)
                        callback()
                    }
                }
            }
        }
    }
    // 修改个人信息
    func alterUseInfo(type: UserInfoAPI, callback: @escaping (_ result: Bool) -> Void) {

        UserInfoProvider .request(type) { (result) in
            if case let .success(response) = result {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                print(json)
                if json["code"] == 200 {
                    callback(true)
                } else if json["code"] == -1 {

                }
            }
        }
    }
    // 修改头像
    func alterUseHeadImg(image: UIImage, callback: @escaping (_ result: String?) -> Void) {
        let imageData = UIImage.jpegData(image)(compressionQuality: 0.5)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let now = Date()
            let timeForMatter = DateFormatter()
            timeForMatter.dateFormat = "yyyyMMddHHmmss"
            let id = timeForMatter.string(from: now)
            multipartFormData.append(imageData!, withName: "file", fileName: "\(id).jpg", mimeType: "image/jpeg")
        }, to: getUploadImages(type: 3)) { (encodingResult) in
            print("个人图片上传地址：\(getUploadImages(type: 3))")
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                    if let data = response.data {
                        let json = JSON(data)
                            if json["code"] == 200 {
                                callback(json["data"].stringValue)
                        }
                    }
                }
            case .failure:
                 print("上传失败")
            }
        }
    }
}
