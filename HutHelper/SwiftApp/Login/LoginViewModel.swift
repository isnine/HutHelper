//
//  LoginViewModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/11.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import HandyJSON
import SwiftyJSON

class LoginViewModel {
    // 输出
    let usernameValid: Observable<Bool>
    let passwordValid: Observable<Bool>
    let everythingValid: Observable<Bool>
    
    // 输入 -> 输出
    init(username: Observable<String>,password: Observable<String>) {

        usernameValid = username
            .map { $0.count >= 1 }
            .share(replay: 1)

        passwordValid = password
            .map { $0.count >= 5 }
            .share(replay: 1)

        everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

    }
}
// Mark:- 请求数据
extension LoginViewModel {
    func loginRequest(username:String,password:String,callback: @escaping(_ result:JSON) -> ()){
        LoginProvider.request(.login(username, password)) { (result) in
            if case let .success(response) = result {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                print(json)
                callback(json)
            }
        }
    }
}
