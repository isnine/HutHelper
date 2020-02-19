//
//  HGImageCollectionViewCell.swift
//  hangge_1512
//
//  Created by hangge on 2017/1/7.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit

//图片缩略图集合页单元格
open class HGImageCollectionViewCell: UICollectionViewCell {
    //显示缩略图
    @IBOutlet weak var imageView:UIImageView!
    
    //显示选中状态的图标
    @IBOutlet weak var selectedIcon:UIImageView!
    
    //设置是否选中
    open override var isSelected: Bool {
        didSet{
            if isSelected {
                selectedIcon.image = UIImage(named: "hg_image_selected")
            }else{
                selectedIcon.image = UIImage(named: "hg_image_not_selected")
            }
        }
    }
    
    //播放动画，是否选中的图标改变时使用
    func playAnimate() {
        //图标先缩小，再放大
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                               animations: {
                self.selectedIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4,
                               animations: {
                self.selectedIcon.transform = CGAffineTransform.identity
            })
            }, completion: nil)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
