//
//  MomentAddViewModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/16.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import HandyJSON
import SwiftyJSON
import Alamofire

class MomentAddViewModel {
//    // 输出
//    let goodNameValid: Observable<Bool>
//    let goodDescribeValid: Observable<Bool>
//    let goodPriceValid: Observable<Bool>
//    let goodFinenessValid: Observable<Bool>
//    let goodPhoneValid: Observable<Bool>
//    let goodAreaValid: Observable<Bool>
//    
//    
//    let everythingValid: Observable<Bool>
//    
//    // 输入 -> 输出
//    init(goodName: Observable<String>,
//         goodDescribe: Observable<String>,
//         goodPrice:Observable<String>,
//         goodFineness: Observable<String>,
//         goodPhone: Observable<String>,
//         goodArea: Observable<String>
//    ) {
//        
//        goodNameValid = goodName
//            .map { $0.count >= 1 }
//            .share(replay: 1)
//
//        goodDescribeValid = goodDescribe
//            .map { $0.count >= 1 }
//            .share(replay: 1)
//        goodPriceValid = goodPrice
//            .map { $0.count >= 1 && $0.count <= 5 }
//            .share(replay: 1)
//
//        goodFinenessValid = goodFineness
//            .map { $0.count >= 1 }
//            .share(replay: 1)
//        goodPhoneValid = goodPhone
//            .map { $0.count >= 1 }
//            .share(replay: 1)
//
//        goodAreaValid = goodArea
//            .map { $0.count >= 1 }
//            .share(replay: 1)
//        
//        everythingValid = Observable.combineLatest( goodNameValid,goodDescribeValid,goodPriceValid,goodFinenessValid,goodPhoneValid,goodAreaValid) { $0 && $1 && $2 && $3 && $4 && $5 }
//            .share(replay: 1)
//
//    }
}
// MARK:- 网络请求
extension MomentAddViewModel {
    func PostHandRequst(content: String, hidden: String, type: String, callback: @escaping (_ result: JSON) -> Void) {
        //print(tit,content,price,attr,phone,adderss,type,hidden)
        MomentProvider.request(.add(content, hidden, type)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback(json)
                }
            }
        }
    }
    func UploadImgs(images: [UIImage], callback: @escaping (_ result: String?) -> Void) {
        guard images.count != 0 else {
            callback("")
            return
        }

        var value = ""
        var item = 0
        for (index, image) in images.enumerated() {
            print(image, 1)
            let imageData = UIImage.jpegData(image)(compressionQuality: 0.5)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let now = Date()
            let timeForMatter = DateFormatter()
            timeForMatter.dateFormat = "yyyyMMddHHmmss"
            let id = timeForMatter.string(from: now)
            multipartFormData.append(imageData!, withName: "file", fileName: "\(id).jpg", mimeType: "image/jpeg")
        }, to: getUploadImages(type: 0)) { (encodingResult) in
            print("个人图片上传地址：\(getUploadImages(type: 0))")
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                    if let data = response.data {
                        let json = JSON(data)
                        print(json)
                            if json["code"] == 200 {
                                //callback(json["data"].stringValue)
                                value += "//" +  json["data"].stringValue
                                item += 1
                                if item == images.count {
                                    callback(value)
                                }
                        }
                    }
                }
            case .failure:
                 print("上传失败")
            }
        }

      }
    }
}
