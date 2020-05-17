//
//  MomentTipsView.swift
//  HutHelper
//
//  Created by 张驰 on 2020/4/3.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit

class MomentTipsView: UIView {

    lazy var cancleBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        return btn
    }()
    // 举报
    lazy var denoncerBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        return btn
    }()
    // 屏蔽
    lazy var bindageBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        return btn
    }()
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
    }

}
