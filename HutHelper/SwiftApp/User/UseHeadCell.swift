//
//  UseHeadCell.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/13.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class UseHeadCell: UITableViewCell {

    lazy var lab:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "头像"
        label.textColor = .black
        return label
    }()
    
    lazy var headImg:UIImageView = {
       let iamge = UIImageView()
        return iamge
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func updateUI(imageUrl:String){
        let imgUrl = URL(string: imageUrl)
        self.headImg.kf.setImage(with: imgUrl)
    }
    
    func setUI(){
        addSubview(lab)
        addSubview(headImg)
        headImg.clipsToBounds = true
        headImg.layer.cornerRadius = 25
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
        }
        headImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self.snp.centerY)
        }
    }

}
