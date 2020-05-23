//
//  CommentCell.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/16.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import SnapKit

class CommentCell: UITableViewCell {

    lazy var nameBtn: UIButton = {
       let btn = UIButton()
//        btn.setTitleColor(UIColor.init(r: 29, g: 203, b: 219), for: .normal)
//        btn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Light", size: 13)
//        btn.backgroundColor = .red
        return btn
    }()
    lazy var nameLab: UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 13)
        label.textColor = UIColor.init(r: 29, g: 203, b: 219)
        //label.backgroundColor = .red
        return label
    }()
    lazy var contentLab: UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 13)
        //label.backgroundColor = .cyan
        label.numberOfLines = 0
        return label
    }()
    lazy var contentBtn: UIButton = {
        let btn = UIButton()
         return btn
    }()
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Light", size: 9)
        btn.backgroundColor = .white
        btn.setTitle("删除", for: .normal)
        return btn
    }()
    lazy var timeLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 9)
        label.textColor = UIColor.init(r: 161, g: 161, b: 161)
         return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
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

        // Configure the view for the selected state
    }

    func updateUI(with data: CommentModel) {
        let nameBtnSize = textSize(text: data.username, font: UIFont.systemFont(ofSize: 13), maxSize: CGSize(width: 414, height: 20))
        let nameWidth = nameBtnSize.width + 5
        nameLab.snp.remakeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(20.fitW)
            make.width.equalTo(nameWidth)
        }
        nameBtn.snp.remakeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(20.fitW)
            make.width.equalTo(nameWidth)
        }
        let commentHeight = getTextHeight(textStr: data.comment, font: UIFont.init(name: "HelveticaNeue-Light", size: 13)!, width: screenWidth - 40.fitW - nameWidth)
        if data.user_id == "\(user.user_id)" {

            contentLab.snp.remakeConstraints { (make) in
                make.top.equalTo(self)
                make.right.equalTo(self).offset(-30.fitW)
                make.height.equalTo(commentHeight + 4)
                make.left.equalTo(nameLab.snp.right)
            }
            contentBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(self)
                make.right.equalTo(self).offset(-30.fitW)
                make.height.equalTo(commentHeight + 4)
                make.left.equalTo(nameLab.snp.right)
            }
            deleteBtn.snp.remakeConstraints { (make) in
                make.centerY.equalTo(nameBtn.snp.centerY)
                make.right.equalTo(self)
                make.width.equalTo(30.fitW)
            }
        } else {
            contentLab.snp.remakeConstraints { (make) in
                make.top.right.equalTo(self)
                make.height.equalTo(commentHeight + 4)
                make.left.equalTo(nameLab.snp.right)
            }
            contentBtn.snp.remakeConstraints { (make) in
                make.top.right.equalTo(self)
                make.height.equalTo(commentHeight + 4)
                make.left.equalTo(nameLab.snp.right)
            }
        }
        //nameBtn.setTitle(data.username + ":", for: .normal)
        nameLab.text = data.username + ":"
        contentLab.text = data.comment
        //timeLab.text = data.created_on
    }

    func setUI() {
        addSubview(nameLab)
        addSubview(contentLab)
        addSubview(nameBtn)
        addSubview(contentBtn)
        addSubview(deleteBtn)
//        timeLab.snp.makeConstraints { (make) in
//             make.left.bottom.equalTo(self)
//             make.height.equalTo(20.fitW)
//             make.width.equalTo(100)
//         }

    }

}
