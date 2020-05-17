//
//  HomeHeaderReusableView.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/27.
//  Copyright © 2020 nine. All rights reserved.
//


import UIKit

class HomeHeaderReusableView: UICollectionReusableView {
    // 标题
     var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        label.textColor = UIColor.init(r: 56, g: 56, b: 56 )
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setUpUI()
        self.backgroundColor = UIColor.init(r: 237, g: 243, b: 241)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "推荐城市"
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(20)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
    }
}
