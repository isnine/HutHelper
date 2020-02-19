//
//  UserDefualt.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/11.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation

let defaults = UserDefaults.standard
var user = getUser()
// 读数据
func getUser() -> Users {
    let userData = defaults.object(forKey: "kUsers") as? [AnyHashable : Any]
    let user = Users(dic: userData)
    return user
}
func changeUserInfo(name:String,value:String) {
    var userData = defaults.object(forKey: "kUsers") as? [AnyHashable : Any]
    userData![name] = value
    saveUserInfo(userData)
    user = getUser()
}
func getRememberCodeApp() -> String? {
    return  defaults.string(forKey: "remember_code_apps")
}

// 数据持久化

func saveRememberCodeApp(token:String) {
    print("token存储成功为：\(token)")
    defaults.set(token, forKey: "remember_code_apps")
    defaults.synchronize()
}
func saveUserPassword(Password:String?){
    defaults.set(Password, forKey: "saveUserPasswords")
    defaults.synchronize()
}
func saveUserInfo(_ userData: [AnyHashable : Any]?) {
    defaults.set(userData, forKey: "kUsers")
    defaults.synchronize()
    print("User信息存储成功")
}

