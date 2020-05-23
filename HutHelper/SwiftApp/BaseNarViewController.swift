//
//  BaseNarViewController.swift
//  HutHelper
//
//  Created by 张驰 on 2020/2/18.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol BaseNarProtpcol {
    var menuView: FWMenuView { get }
}

class BaseNarViewController: UIViewController {
    let disposeBag = DisposeBag()
    // 左边返回
    lazy var leftBarButton: UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: -5, y: 0, width: 20, height: 30)
            btn.setImage(UIImage(named: "ico_menu_back"), for: .normal)
            btn.rx.tap.subscribe(onNext: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
                }).disposed(by: disposeBag)
        return btn
    }()
    // 右边功能按钮
    lazy var rightBarButton: UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: -5, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "ico_menu_menu"), for: .normal)
            btn.rx.tap.subscribe(onNext: {[weak self] in
                self?.menuView.show()
            }).disposed(by: disposeBag)
        return btn
    }()

    lazy var menuView = FWMenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        self.navigation.item.leftBarButtonItem =  UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.isShadowHidden = true
    }

    func configRightMenu(itemTitles: [String], itemIcons: [UIImage], nextController: [UIViewController]) {
        let vProperty = FWMenuViewProperty()
        vProperty.popupCustomAlignment = .topRight
        vProperty.popupAnimationType = .scale
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.4)
        vProperty.touchWildToHide = "1"
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: kStatusBarHeight + kNavBarHeight, left: 0, bottom: 0, right: 8)
        vProperty.topBottomMargin = 0
        vProperty.animationDuration = 0.1
        vProperty.popupArrowStyle = .round
        vProperty.popupArrowVertexScaleX = 1
        vProperty.backgroundColor = kPV_RGBA(r: 64, g: 63, b: 66, a: 1)
        vProperty.splitColor = kPV_RGBA(r: 64, g: 63, b: 66, a: 1)
        vProperty.separatorColor = kPV_RGBA(r: 91, g: 91, b: 93, a: 1)
        vProperty.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.backgroundColor: UIColor.clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
        vProperty.textAlignment = .left
        vProperty.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        menuView = FWMenuView.menu(itemTitles: itemTitles, itemImageNames: itemIcons, itemBlock: { (_, index, _) in
            var addVC: UIViewController?
            addVC = nextController[index]
            switch index {
                case 0:
                    addVC = nextController[0]
                case 1:
                    addVC = nextController[1]
                case 2:
                    addVC = nextController[2]
                case 3:
                    addVC = nextController[3]
                case 4:
                    addVC = nextController[4]
                default:
                    break
            }

            self.navigationController?.pushViewController(addVC!, animated: true)
        }, property: vProperty)
    }
}

//extension BaseNarViewController: BaseNarProtpcol{
//    var menuView: FWMenuView {
//        <#code#>
//    }
//
//
//}
