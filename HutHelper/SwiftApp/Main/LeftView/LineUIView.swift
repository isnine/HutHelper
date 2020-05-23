//
//  LineUIView.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/14.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit

@IBDesignable class LineUIView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        // 设置线条的样式
        if let context = context {
            context.setLineCap(.round)
        }
        // 绘制线的宽度
        context?.setLineWidth(0.5)
        // 线的颜色
        context?.setStrokeColor(UIColor.white.cgColor)
        // 开始绘制
        context?.beginPath()
        // 设置虚线绘制起点
        context?.move(to: CGPoint(x: 0, y: 15.0))
        // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
        let lengths: [CGFloat] = [2.0, 3.0]
        // 虚线的起始点
        context?.setLineDash(phase: 0, lengths: lengths)
        // 绘制虚线的终点
        context?.addLine(to: CGPoint(x: 350.0, y: 15.0))
        // 绘制
        context?.strokePath()
        // Drawing code
    }

}
