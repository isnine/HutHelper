//
//  PageTitleView.swift
//  VCFactory
//
//  Created by nine on 2018/11/3.
//

import Foundation
import SnapKit
var flagTitleImage : [Int] = [0,0,0,0,0]
var flagIcoImage : [Int] = [0,0,0,0,0]
var flagTitleImageAndIcoImage : [Int] = [0,0,0,0,0];
var cellFlag = 0

class PageTitleView: UIView {
    let label = UILabel()
    let bottom = UIImageView()
    var isSelected: Bool = false {
        didSet {
            bottom.isHidden = !isSelected
        }
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configUI()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(label)
        addSubview(bottom)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(18)
            make.top.equalTo(self).offset(1)
            make.centerX.equalTo(self)
        }
        
        bottom.snp.makeConstraints { (make) in
            make.width.equalTo(22)
            make.height.equalTo(3)
            make.centerX.equalTo(self)
            make.top.equalTo(label.snp.bottom).offset(3)
        }
        label.textAlignment = .center
        label.textColor = UIColor(red: 58, green: 63, blue: 62)
        bottom.backgroundColor = UIColor(red: 42, green: 218, blue: 213)
        isSelected = false
    }

}

