//
//  MoreCell.swift
//  HutHelper
//
//  Created by nine on 2018/12/4.
//  Copyright © 2018 nine. All rights reserved.
//

import UIKit


class MoreCell: UIView {
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
    
    lazy var icoType: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    lazy var icoCost: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.lightGray
        btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
        btn.setTitleColor(UIColor.blue, for: UIControlState())
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
    
    func configUI() {
        if flagIcoImage[cellFlag] == 0 , flagTitleImage[cellFlag] == 0 ,flagTitleImageAndIcoImage[cellFlag] == 0 {
            addSubview(titleImageView)
            addSubview(title)
            addSubview(describe)
            addSubview(icoImageView)
            addSubview(icoTitle)
            addSubview(icoType)
            titleImageView.snp.makeConstraints{(make)in
                make.top.left.equalTo(self).offset(0)
                make.width.equalTo(self)
                make.height.equalTo(80)
            }
            title.snp.makeConstraints { (make) in
                make.top.equalTo(titleImageView).offset(85)
                make.left.equalTo(self).offset(20)
                make.width.equalTo(300)
                make.height.equalTo(20)
            }
            describe.snp.makeConstraints { (make) in
                make.top.equalTo(title).offset(25)
                make.left.equalTo(self).inset(20)
                make.width.equalTo(300)
               
            }
            icoImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(45)
                make.bottom.left.equalTo(self).inset(10)
            }
            icoTitle.snp.makeConstraints { (make) in
                make.left.equalTo(icoImageView).inset(60)
                make.bottom.equalTo(self).inset(35)
            }
            icoType.snp.makeConstraints{(make) in
                make.left.equalTo(icoImageView).offset(60)
                make.bottom.equalTo(self).inset(10)
            }
        }
        //addSubview(icoCost)
        else {
        if flagTitleImageAndIcoImage[cellFlag] == 1 {

            addSubview(title)
            addSubview(describe)
            title.snp.makeConstraints { (make) in
                make.top.equalTo(self).inset(10)
                make.left.equalTo(self).offset(20)
                make.width.equalTo(300)
                make.height.equalTo(20)
            }
            describe.snp.makeConstraints { (make) in
                make.top.equalTo(title).inset(25)
                make.left.equalTo(self).inset(20)
                make.width.equalTo(300)
            }
        }
       
            if flagTitleImage[cellFlag] == 1 {
            addSubview(title)
            addSubview(describe)
            addSubview(icoImageView)
            addSubview(icoTitle)
            addSubview(icoType)
            title.snp.makeConstraints { (make) in
                make.bottom.equalTo(self).offset(10)
                make.left.equalTo(self).offset(20)
                make.width.equalTo(300)
                make.height.equalTo(20)
            }
            describe.snp.makeConstraints { (make) in
                make.bottom.equalTo(title).offset(40)
                make.right.left.equalTo(self).inset(20)
                make.height.equalTo(40)
            }
            icoImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(48)
                make.bottom.left.equalTo(self).inset(10)
            }
            icoTitle.snp.makeConstraints { (make) in
                make.left.equalTo(icoImageView).offset(60)
                make.bottom.equalTo(self).inset(38)
            }
            icoType.snp.makeConstraints{(make) in
                make.left.equalTo(icoImageView).offset(60)
                make.bottom.equalTo(self).inset(10)
            }
        }
        if flagIcoImage[cellFlag] == 1 {
            addSubview(titleImageView)
            addSubview(title)
            addSubview(describe)
            
            titleImageView.snp.makeConstraints{(make)in
                make.top.left.equalTo(self).offset(0)
                make.width.equalTo(self)
                make.height.equalTo(80)
            }
            title.snp.makeConstraints { (make) in
                make.top.equalTo(titleImageView).offset(85)
                make.left.equalTo(self).offset(20)
                make.width.equalTo(300)
                make.height.equalTo(20)
            }
            describe.snp.makeConstraints { (make) in
                make.top.equalTo(title).offset(25)
                make.left.equalTo(self).inset(20)
                make.width.equalTo(300)
            }
        }
        }
      cellFlag += 1
        if cellFlag == 4 {
            cellFlag = 0
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGFloat{
        var size = CGRect();
        var size2 = CGSize(width: 100, height: 0);//设置label的最大宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as? [String : Any] , context: nil);
        return size.height
    }
    

}
