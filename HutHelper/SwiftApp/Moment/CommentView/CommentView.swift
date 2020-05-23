//
//  CommentView.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/10.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CommentView: UIView {

    // 回调闭包
    typealias Block = (_ content: String) -> Void
    var callback: Block?

    public var indexPath = IndexPath()

    // 背景视图
    private lazy var bgView = UIView()
    lazy var textField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "在这里写下评论~"
//        tf.delegate = self
        return tf
    }()
    // 键盘
    var keyboardTap = UITapGestureRecognizer()

}
