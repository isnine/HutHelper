//
//  ImgsViewCell.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/15.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit

class ImgsViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        //self.backgroundColor = .red
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
