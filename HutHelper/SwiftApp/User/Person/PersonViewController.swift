//
//  PersonViewController.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/22.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Alamofire
import SwiftyJSON
import HandyJSON
import Kingfisher


class PersonViewController: UIViewController {
    
    // rx销毁
    let disposeBag = DisposeBag()
    // 左边返回
    private lazy var leftBarButton:UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x:-5, y:0, width:20, height: 30)
            btn.setImage(UIImage(named: "ico_menu_back"), for: .normal)
            btn.rx.tap.subscribe(onNext:{[weak self] in
                self?.navigationController?.popViewController(animated: true)
                }).disposed(by: disposeBag)
        return btn
    }()
    
    // 白色背景
    lazy var whiteBackView:UIView = {
        let vi = UIView(frame: CGRect(x: 20.fitW, y: 200.fitW, width: 374.fitW, height: 300.fitW))
        vi.backgroundColor = .white
        return vi
    }()
    // 头像
    lazy var headImg:UIImageView = {
        let img = UIImageView(frame: CGRect(x: screenWidth/2 - 65.fitW, y: 200.fitW - 65.fitW, width: 130.fitW, height: 130.fitW))
        img.cornerRadius = 65.fitW
        img.clipsToBounds = true
        return img
    }()
    // 名称
    lazy var nameLab:UILabel = {
        let label = UILabel(frame: CGRect(x: screenWidth/2-100.fitW, y: 275.fitW, width: 200.fitW, height: 30.fitW))
        label.font = FontSize(18)
        label.textAlignment = .center
        label.textColor = UIColor.init(r: 29, g: 203, b: 219)
        return label
    }()
    // 签名
    lazy var bioLab:UILabel = {
        let label = UILabel(frame: CGRect(x: screenWidth/2-100.fitW, y: 315.fitW, width: 200.fitW, height: 30.fitW))
        label.font = FontSize(16)
        label.textAlignment = .center
        label.textColor = UIColor.init(r: 173, g: 173, b: 173)
        return label
    }()
    // 签名
    lazy var depLab:UILabel = {
        let label = UILabel(frame: CGRect(x: screenWidth/2-100.fitW, y: 355.fitW, width: 200.fitW, height: 30.fitW))
        label.font = FontSize(14)
        label.textAlignment = .center
        label.textColor = UIColor.init(r: 173, g: 173, b: 173)
        return label
    }()
    // 聊天btn
    lazy var chartBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: screenWidth/2-110.fitW, y: 400.fitW, width: 220.fitW, height: 40.fitW))
        btn.setBackgroundImage(UIImage(named: "img_user_imbtn"), for: .normal)
        return btn
    }()
    // 校园说说Btn
    lazy var momentBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: screenWidth/2-140.fitW, y: 471.fitW, width: 60.fitW, height: 60.fitW))
        btn.setBackgroundImage(UIImage(named: "img_user_saybtn"), for: .normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            let vc = MomentViewController(type: .own(self!.userInfo.username, self!.userInfo.user_id))
            self!.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        return btn
    }()
    // 二手市场Btn
    lazy var handBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: screenWidth/2-30.fitW, y: 471.fitW, width: 60.fitW, height: 60.fitW))
        btn.setBackgroundImage(UIImage(named: "img_user_handbtn"), for: .normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            let vc = HandTableViewController()
            self!.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        return btn
    }()
    // 失物招领Btn
    lazy var lostBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: screenWidth/2+80.fitW, y: 471.fitW, width: 60.fitW, height: 60.fitW))
        btn.setBackgroundImage(UIImage(named: "img_user_lostbtn"), for: .normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            let vc = LostViewController()
            self!.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        return btn
    }()
    var userInfo = PeopleModel()
    var userid = ""
    convenience init(userInfo:PeopleModel) {
        self.init()
        self.userInfo = userInfo
    }
    convenience init(userid:String) {
        self.init()
        self.userid = userid
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        updateUI()
    }
    
    func configUI(){
        if let image = UIImage(named: "img_user_bcg") {
            view.backgroundColor = UIColor(patternImage: image)
        }
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.leftBarButtonItem =  UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.item.title = "个人信息"
        view.addSubview(whiteBackView)
        view.addSubview(headImg)
        view.addSubview(nameLab)
        view.addSubview(bioLab)
        view.addSubview(depLab)
        view.addSubview(chartBtn)
        view.addSubview(momentBtn)
        view.addSubview(handBtn)
        view.addSubview(lostBtn)
    }
    func updateUI(){

        
        Alamofire.request(getPersonInfo(userId: self.userid)).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            let value = response.value
            let json = JSON(value!)
            if let data = JSONDeserializer<PeopleModel>.deserializeFrom(json: json["data"].description) {
                self.userInfo = data
                self.nameLab.text = data.username
                self.bioLab.text = data.bio
                self.depLab.text = data.dep_name
                let imgUrl = URL(string: imageUrl + data.head_pic)
                self.headImg.kf.setImage(with: imgUrl)
            }
        }
    }

}
