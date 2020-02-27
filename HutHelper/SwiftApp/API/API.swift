//
//  API.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/11.
//  Copyright © 2020 张驰. All rights reserved.
//



import Foundation
import Moya
import HandyJSON
import Alamofire

// 服务器地址
let basicUrl = "https://api.huthelper.cn"
// 图床地址
let imageUrl = "http://images.huthelper.cn:8888"
// 注册
let registerAPI = basicUrl + "/auth/register"

func a() {
    Alamofire.download("https://httpbin.org/image/png").responseData { response in
        if let data = response.result.value {
            let image = UIImage(data: data)
        }
    }
}
// MARK: 登录
let LoginProvider = MoyaProvider<LoginAPI>()

enum LoginAPI{
    case login(String,String)
}
extension LoginAPI:TargetType{
    var baseURL: URL { return URL(string: basicUrl)! }
    var path: String { return "/api/v3/get/login/2" }
    var method: Moya.Method { return .post }
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
        case .login(let username, let password):
            parmeters = ["studentkh":username,
                         "passwd":password
                        ]
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    var headers: [String : String]? { return nil }
    // 用于单元测试
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}



// 获取所有班级
let getAllclassesAPI = basicUrl + "/api/v3/get/classes/1/1"

//let getAlterUseImg =  "\(imageUrl)/api/v3/Upload/images/\(user.studentKH)/\(user.remember_code_app)/" + env() + "/3"
// 上传图片全局方法
func getUploadImages(type:Int) -> String {
    let now = Date()
    let timeForMatter = DateFormatter()
    timeForMatter.dateFormat = "yyyy-MM"
    let id = timeForMatter.string(from: now)
    // sha1 加密
    let env = "\(user.studentKH)\(user.remember_code_app)\(id)".sha1
    let url = "\(imageUrl)/api/v3/Upload/images/\(user.studentKH)/\(user.remember_code_app)/" + env() + "/\(type)"
    return  url
}

func getPersonInfo(userId:String) -> String {
    let env = "\(user.studentKH)\(user.remember_code_app)\(userId)2020-01".sha1
    let url = "/api/v3/Set/user_info/\(user.studentKH)/\(user.remember_code_app)/\(userId)/\(env())"
    print(basicUrl+url)
    return basicUrl + url
}


// MARK: 用户
let UserInfoProvider = MoyaProvider<UserInfoAPI>()
 
enum UserInfoAPI{
    case bio(String)
    case username(String)
    case classes(String)
    
}

extension UserInfoAPI:TargetType{
    var baseURL: URL { return URL(string: basicUrl)! }
    var path: String { return "/api/v3/set/profile/\(user.studentKH)/\(user.remember_code_app)" }
    var method: Moya.Method { return .post }
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
        
        case .bio(let value):
            parmeters = [
                         "bio":value
                       ]
            
        case .username(let value):
            parmeters = [
                         "username":value
                       ]
        case .classes(let value):
            parmeters = [
                         "class_name":value
                       ]
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    var headers: [String : String]? { return nil }
    // 用于单元测试
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}


// MARK: 首页
let HomePageProvider = MoyaProvider<HomePageAPI>()

enum HomePageAPI {
    case calendar
    case weather
    case versioniOS
    
}
extension HomePageAPI:TargetType{
    var baseURL: URL {
        switch self {
        case .weather:
            return URL(string: "https://api.seniverse.com")!
        default:
            return URL(string: basicUrl)!
        }
    }
    var path: String {
        switch self {
        case .weather:
            return "/v3/weather/now.json?key=il4weiqexf5krspx&location=zhuzhou&language=zh-Hans&unit=c"
        case .calendar:
            return "/api/v1/get/calendar"
        case .versioniOS:
            return "/api/v1/get/versionIos/"
        }
    }
    var method: Moya.Method { return .get }
    var task: Task {
        let parmeters:[String:Any] = [:]
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    var headers: [String : String]? { return nil }
    // 用于单元测试
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}

/**图书馆*/
let getLibraryAPI = "http://172.16.64.7:8080/opac/m/index"

/**电费*/
//func getPowerAPI(part:String,locate:String,room:String) -> String {
//    let powerAPI = basicUrl + "/api/v3/get/power_e/" + part + "/" + locate + "/" + room + "/" + user.studentKH + "/" + user.remember_code_app + "/"
//    let enc = (locate + room + "\(user.studentKH)" + "\(user.remember_code_app)" + part).sha1()
//    return powerAPI + enc
//}

/**成绩*/
//let getScoreAPI = basicUrl + "/api/v3/get/score/" + user.studentKH + "/" + user.remember_code_app
//let good = "https://api.huthelper.cn/api/v3/trade/goods/1/2"

// MARK: 二手市场
let HandProvider = MoyaProvider<HandAPI>()

enum HandAPI {
    case all(Int,Int)
    case details(String)
    case add(String,String,Int,Int,String,String,Int,String)
    case own(Int,String)
    case delete(String)
}
extension HandAPI:TargetType {
    var baseURL: URL {
        return URL(string: basicUrl)!
    }
    
    var path: String {
        switch self {
        case  .all(let page, let type):
            return "/api/v3/trade/goods/\(page)/\(type)"
        case .details(let id):
            return "/api/v3/trade/details/\(user.studentKH)/\(user.remember_code_app)/\(id)"
        case .add(_, _, _, _, _, _, _, _):
            return "/api/v3/trade/create/\(user.studentKH)/\(user.remember_code_app)"
        case .own(let page,let userId):
            return "/api/v3/trade/own/\(user.studentKH)/\(user.remember_code_app)/\(page)/\(userId)"
        case .delete(let goodId):
            return "/api/v3/trade/delete/\(user.studentKH)/\(user.remember_code_app)/\(goodId)"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .add(_, _, _, _, _, _, _, _):
            return .post
        default:
            return .get
        }
    }
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
        case .add(let tit, let content, let price, let attr, let phone, let address, let type, let hidden):
            parmeters = [
                         "tit":tit,
                         "content":content,
                         "prize":price,
                         "attr":attr,
                         "phone":phone,
                         "address":address,
                         "type":type,
                         "hidden":hidden
                       ]
            
        default:
            break;
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    var headers: [String : String]? { return nil }
    // 用于单元测试
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    
}

// MARK: 校园说说
let MomentProvider = MoyaProvider<MomentAPI>()

enum MomentAPI {
    case add(String,String,String)
    case comment(String,String)
    case all(Int)
    case hot(Int,Int)
    case own(Int,String)
    case interactive(Int)
    case search(String,Int)
    case like(String)
    case delete(String)
    case unlike(String)
    case deleteC(String)
}
extension MomentAPI:TargetType {
    var baseURL: URL {
        return URL(string: basicUrl)!
    }
    
    var path: String {
        switch self {
        case .add(_, _, _):
            return "/api/v3/statement/create/\(user.studentKH)/\(user.remember_code_app)"
        case .comment(_, _):
            return "/api/v3/statement/comment/\(user.studentKH)/\(user.remember_code_app)"
        case .all(let page):
            return "/api/v3/statement/statement/\(user.studentKH)/\(page)"
        case .hot(let page,let day):
            return "/api/v3/statement/fire/\(user.studentKH)/\(day)/\(page)"
        case .own(let page, let userId):
            return "/api/v3/statement/own/\(user.studentKH)/\(user.remember_code_app)/\(page)/\(userId)"
        case .interactive(let page):
        print("/api/v3/statement/interactive/\(user.studentKH)/\(user.remember_code_app)/\(page)")
            return "/api/v3/statement/interactive/\(user.studentKH)/\(user.remember_code_app)/\(page)"
        case .search(let content,let page):
           return "/api/v3/statement/search/\(user.studentKH)/\(user.remember_code_app)/\(content)/\(page)"

        case .like(let mid):
            return "/api/v3/statement/like/\(user.studentKH)/\(user.remember_code_app)/\(mid)"
        case .delete(let mid):
            return "/api/v3/statement/delete/\(user.studentKH)/\(user.remember_code_app)/\(mid)"
        case .unlike(let mid):
            return "/api/v3/statement/dislike/\(user.studentKH)/\(user.remember_code_app)/\(mid)"
        case .deleteC(let commentId):
            return "/api/v3/statement/deleteC/\(user.studentKH)/\(user.remember_code_app)/\(commentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .add(_, _, _):
            return .post
        case .comment(_, _):
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
        case .add(let content, let hidden, let type):
            parmeters = [
                         "content" : content,
                         "hidden" : hidden,
                         "type" : type
                       ]
        case .comment(let comment, let moment_id):
            parmeters = [
                         "comment": comment,
                         "moment_id": moment_id
                       ]
        default:
            break;
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)

    }
    var headers: [String : String]? { return nil }
    // 用于单元测试
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
}


// MARK: 失误招领
let LostProvider = MoyaProvider<LostAPI>()


enum LostAPI {
    case create(String,String,String,String,String,String,Int)
    case all(Int)
    case own(Int,String)
    case search(Int,String)
    case delete(String)
}
extension LostAPI:TargetType {
    var baseURL: URL {
        return URL(string: basicUrl)!
    }
    
    var path: String {
        switch self {
        case .create(_, _, _, _, _, _, _):
            return "api/v3/loses/create/\(user.studentKH)/\(user.remember_code_app)"
        case .all(let page):
            return "api/v3/loses/goods/\(page)/0"
        case .own(let page, let user_id):
            return "api/v3/loses/own/\(user.studentKH)/\(user.remember_code_app)/\(page)/\(user_id)"
        case .search(let page, _):
            return "api/v3/loses/search/\(user.studentKH)/\(user.remember_code_app)/\(page)"
        case .delete(let id):
            return "api/v3/loses/delete/\(user.studentKH)/\(user.remember_code_app)/\(id)"
        default:
            break
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create(_, _, _, _, _, _, _):
            return .post
        case .search(_, _):
            return .post
        default:
            return .get
        }
    }
    
    
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
        case .create(let tit, let locate, let time, let content, let hidden, let phone, let type):
            parmeters = [
                         "tit" : tit,
                         "locate" : locate,
                         "time" : time,
                         "content" : content,
                         "hidden" : hidden,
                         "phone" : phone,
                         "type" : type
                       ]
        case .search(_, let like):
            parmeters = [
                         "like":like
                       ]
        default:
            break;
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }

    var headers: [String : String]? { return nil }
    // 用于单元测试
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    
}
