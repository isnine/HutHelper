//
//  CommentView.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/10.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CommentView: UIView {
    // 对外接口调用
    public func show(at indexPath:IndexPath,originStr:String = "",placeholderStr:String = "写下评论吧~") {
        self.indexPath = indexPath
        self.placeholderLabel.text = placeholderStr
        self.textView.text = originStr
        UIApplication.shared.keyWindow?.addSubview(overView)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.textView.becomeFirstResponder()
        
    }
    // 保留cell的indexPath 回调用到
    private var indexPath = IndexPath()
    // 对外回调闭包
    typealias Block = (_ content:String,_ section:IndexPath) -> Void
    var callback:Block?
    
    // 对内方法
    @objc private func dismiss(){
        overView.removeFromSuperview()
        self.removeFromSuperview()
        UITextView.animate(withDuration: 0.1, animations: {
            var frame = self.frame
            frame.origin.y = screenHeight
            self.frame = frame
        })
        self.textView.resignFirstResponder()
    }
    
    let maxHeight:CGFloat = 300.fitW
    lazy var overView:UIControl = {
        let overView = UIControl.init(frame: UIScreen.main.bounds)
        overView.backgroundColor = UIColor.init(r: 33, g: 33, b: 33,alpha: 0.5)
        overView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return overView
    }()
    let disposeBag = DisposeBag()
    // 背景视图
    private lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var placeholderLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.fitW)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        return label
    }()
    private lazy var textView : UITextView = {
       let textView = UITextView()
        textView.text = ""
        textView.textColor = UIColor.black
        textView.delegate = self
        textView.backgroundColor = UIColor.init(r: 248, g: 248, b: 248)
        textView.font = UIFont.systemFont(ofSize: 15.fitW)
        return textView
    }()
    private lazy var sendBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.init(r: 29, g: 203, b: 219)
        btn.setTitle("发送", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.rx.tap.subscribe(onNext:{[weak self] in
            self!.dismiss()
            self!.callback!(self!.textView.text,self!.indexPath)
        }).disposed(by: disposeBag)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        configUI()
        initKeyBoardObserver()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configUI(){
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.right.equalTo(self)
            make.left.equalTo(self)
            make.top.equalTo(self)
        }
        addSubview(textView)
        addSubview(sendBtn)
        sendBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-5.fitW)
            make.right.equalTo(self).offset(-5.fitW)
            make.height.equalTo(30.fitW)
            make.width.equalTo(60.fitW)
        }
        textView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(10.fitW)
            make.right.equalTo(self).offset(-70.fitW)
            make.top.equalTo(self)
        }
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in

            make.left.equalTo(self).offset(12.fitW)
            make.right.equalTo(self).offset(-70.fitW)
            make.top.equalTo(self)
            make.height.equalTo(30.fitW)
        }
    }
    func initKeyBoardObserver(){
        // 注册键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)

    }
    //MARK: 当键盘显示时
    @objc func handleKeyboardDisShow(notification: NSNotification) {
        let keyboardAnimationDur = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let animationDur = keyboardAnimationDur?.floatValue ?? 0.0
        //得到键盘frame
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
        let keyboardRec = (value as AnyObject).cgRectValue

        let height = keyboardRec?.size.height

        //让textView bottom位置在键盘顶部
        UIView.animate(withDuration: TimeInterval(animationDur), animations: {
            self.frame.origin.y = screenHeight - height! - self.frame.size.height
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CommentView:UITextViewDelegate{
    
    // 高度自适应
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            self.placeholderLabel.text = "写下评论吧~"
        }else {
            self.placeholderLabel.text = ""
        }
        let frame = textView.frame
        let constrainSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        var size = textView.sizeThatFits(constrainSize)
        if size.height >= maxHeight {
            size.height = maxHeight
            textView.isScrollEnabled = true
        }else {
            textView.isScrollEnabled = false
        }
        var height = 40.0.fitW
        if(size.height>=40.0.fitW){
            height = size.height
        }
        let originY =  self.frame.origin.y + self.frame.size.height
        self.frame.origin.y =  originY - height
        self.frame.size.height = height
    }
    

}
