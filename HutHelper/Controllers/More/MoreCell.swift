//
//  MoreCell.swift
//  HutHelper
//
//  Created by nine on 2018/12/4.
//  Copyright © 2018 nine. All rights reserved.
//

import UIKit
import Kingfisher

class MoreCell: UICollectionViewCell {
    lazy var titleImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        // iv.layer.masksToBounds = true
        return iv
    }()
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var describe: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var icoImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var icoTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var icoDescribe: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    lazy var icoCost: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.lightGray
        btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
        btn.setTitleColor(UIColor.blue, for: UIControl.State())
        btn.layer.cornerRadius = 14
        return btn
    }()
    init() {
        super.init(frame: .zero)
        configShadow()
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updataUI(with data: More) {
        if data.image != "" {
            let urlTitleImage = URL(string: data.image)
            titleImageView.kf.setImage(with: urlTitleImage)
        }
        if let icoImagUrl = data.app?.ico{
            let urlIcoImage = URL(string: icoImagUrl)
            icoImageView.kf.setImage(with: urlIcoImage)
        }
        icoTitle.text = data.app?.title
        icoDescribe.text = data.app?.describe
        title.text = data.title
        describe.text = data.describe
        
        titleImageView.snp.updateConstraints { (make) in
            make.height.equalTo(data.image == "" ? 0 :150)
        }
        let isHadApp = (data.app != nil)
        icoImageView.isHidden = !isHadApp
        icoTitle.isHidden = !isHadApp
        icoDescribe.isHidden = !isHadApp
    }
    
    func configUI() {
        addSubview(titleImageView)
        addSubview(title)
        addSubview(describe)
        addSubview(icoImageView)
        addSubview(icoTitle)
        addSubview(icoDescribe)
        titleImageView.snp.makeConstraints{(make)in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(titleImageView.snp.bottom).offset(5)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        describe.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(self).inset(20)
            make.width.equalTo(300)
        }
        icoImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(45)
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self).inset(5)
        }
        icoTitle.snp.makeConstraints { (make) in
            make.left.equalTo(icoImageView).inset(60)
            make.bottom.equalTo(self).inset(30)
        }
        icoDescribe.snp.makeConstraints{(make) in
            make.left.equalTo(icoImageView).offset(60)
            make.bottom.equalTo(self).inset(8)
        }
    }
    
    func configShadow() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor

        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.6
        self.layer.masksToBounds = false
    }
    
}
