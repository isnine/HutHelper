//
//  PointView.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/14.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit

class PointView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        context?.addArc(center: CGPoint(x: 10.fit, y: 10.fit), radius: 3.fit, startAngle: 0, endAngle: 3.fit * 3.14, clockwise: false) //添加一个圆
        context?.setFillColor(UIColor.white.cgColor) //填充颜色
        context?.drawPath(using: .fill) //绘制填充
    }
    

}
