//
//  CommentCell.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/16.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import SnapKit
enum CommentCallBackType{
    case username
    case delete
}
protocol CommentCellDelegate:NSObjectProtocol {
    func cellClickCallBack(with data:CommentModel,type:CommentCallBackType,indexPath:IndexPath)
}

class CommentCell: UITableViewCell {
    weak var delegate:CommentCellDelegate?
    var indexPath = IndexPath()
    var cellData = CommentModel()
    // 评论信息及内容
    lazy var commentView:ZCTextView = {
       let textView = ZCTextView()
        textView.font = UIFont.init(name: "HelveticaNeue-Light", size: 13)
        textView.textColor = UIColor.init(r: 34, g: 34, b: 34)
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
        
        // 解决向下偏移问题
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0;
        textView.delegate = self
        return textView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       configUI()
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
    
    func configUI(){
        addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.right.equalTo(self).offset(-20.fitW)
            make.top.bottom.equalTo(self)
        }
    }
    
    func update(with data:CommentModel) {
        self.cellData = data
        let attrStr1 = commentView.appendLinkString(string: data.username + "：", withURLString: "user:comment")
        let attrStr2 = commentView.appendLinkString(string: data.comment)
        var attrStr3 = NSMutableAttributedString()

        if data.user_id == "\(user.user_id)" {
            attrStr3 = commentView.appendLinkString(string: " 删除", withURLString: "delete:comment")
        }
        let attrString = NSMutableAttributedString()
        attrString.append(attrStr1)
        attrString.append(attrStr2)
        attrString.append(attrStr3)
        commentView.attributedText = attrString
    }
    
    

}

extension CommentCell:UITextViewDelegate {
    //链接点击响应方法
     func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                   in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
         if let scheme = URL.scheme {
             switch scheme {
             case "user" :
                self.delegate?.cellClickCallBack(with: cellData, type: .username, indexPath: indexPath)
             case "delete" :
                self.delegate?.cellClickCallBack(with: cellData, type: .delete, indexPath: indexPath)
             default:
                 print("这个是普通的url")
             }
         }
          
         return true
     }
}

class ZCTextView:UITextView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var location = point
        location.x -= self.textContainerInset.left
        location.y -= self.textContainerInset.top
        
        // find the character that's been tapped
        let characterIndex = self.layoutManager.characterIndex(for: location, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < self.textStorage.length {
            // if the character is a link, handle the tap as UITextView normally would
            if (self.textStorage.attribute(NSAttributedString.Key.link, at: characterIndex, effectiveRange: nil) != nil) {
                return self
            }
        }
        
        // otherwise return nil so the tap goes on to the next receiver
        return nil
    }
}
