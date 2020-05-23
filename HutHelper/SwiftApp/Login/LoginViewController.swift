//
//  LoginViewController.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/10.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var UtfSecCode: UITextField!

    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var idValid: UILabel!

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var pwdValid: UILabel!

    @IBOutlet weak var registerBtn: UIButton!

    @IBOutlet weak var loginBtn: UIButton!

    // 左边返回
    lazy var leftBarButton: UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: -5, y: 0, width: 20, height: 30)
        btn.setTitle("", for: .normal)
        return btn
    }()

    let disposeBag = DisposeBag()
    var viewModel: LoginViewModel!
    let tap = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configUI()
        rxMethod()
        keyboard()
    }
    func configViewModel() {
        viewModel = LoginViewModel(
            username: userId.rx.text.orEmpty.asObservable(),
            password: password.rx.text.orEmpty.asObservable()
        )
    }
    func configUI() {
        self.view.addGestureRecognizer(tap)
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.userId.placeholder = "学 号（新用户学号前加XH）"
        self.password.placeholder = "密 码"
    }

    func rxMethod() {
        viewModel.usernameValid.bind(to: password.rx.isEnabled).disposed(by: disposeBag)
        viewModel.usernameValid.bind(to: idValid.rx.isHidden).disposed(by: disposeBag)
        viewModel.passwordValid.bind(to: pwdValid.rx.isHidden).disposed(by: disposeBag)

        viewModel.everythingValid.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)

        self.loginBtn.rx.tap.subscribe(onNext: {[weak self] in
            let hud = MBProgressHUD.showAdded(to: self!.view, animated: true)
            hud.label.text = "加载中"
            self?.viewModel.loginRequest(username: self?.userId.text ?? "", password: self?.password.text ?? "", callback: { (value) in
                print(value)
                if value["code"] == 200 {
                    saveUserInfo(value["data"].dictionaryObject)
                    saveRememberCodeApp(token: value["data"].dictionaryObject!["remember_code_app"] as! String)
                     MBProgressHUD.hideAllHUDs(for: self!.view, animated: true)

                Config.saveUser(value["data"].dictionaryObject)
                    Config.saveRememberCodeApp((value["data"].dictionaryObject!["remember_code_app"] as! String))
                    Config.saveCurrentVersion((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String))

                    MBProgressHUD.hideAllHUDs(for: self!.view, animated: true)
                self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    // 错误处理
                }
            })
        }).disposed(by: disposeBag)

        self.registerBtn.rx.tap.subscribe(onNext: {[weak self] in
            let registerVC = BaseWebController(webURL: registerAPI, navTitle: "注册账号")
            self?.navigationController?.pushViewController(registerVC, animated: true)
            }).disposed(by: disposeBag)
    }

}
extension LoginViewController {
    func keyboard() {
        // 键盘显示通知
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).subscribe { (_) in
            UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: -120, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }

        }.disposed(by: disposeBag)

        // 键盘收起通知
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).subscribe { (_) in
            UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }.disposed(by: disposeBag)

        //键盘收起
        tap.rx.event.subscribe { (_) in
            print("点击了view并收起键盘")
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
}

extension LoginViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
