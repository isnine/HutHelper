//
//  FuncCell.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/26.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit

class FuncCell: UICollectionViewCell {
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI(){
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
    
    func updateUI(with data:HomeFuncsModel) {
        self.imageView.image = UIImage(named: data.iconImg)
        self.titleLabel.text = data.iconName
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
