//
//  TestViewController.swift
//  HutHelper
//
//  Created by 张驰 on 2020/4/2.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let textView = UITextView(frame: CGRect(x: 50, y: 300, width: 300, height: 300))
        textView.textColor = .black
        textView.dataDetectorTypes = .link
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        //设置展示文本框的代理
        //textView.delegate = self
//        let subjectString1 = NSAttributedString(string: "CLUD:  ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red, NSAttributedString.Key.font : UIFont.init(name: "Quicksand-Bold", size: 14)])
//        let subjectString2 = NSAttributedString(string: "CCCC", attributes: [NSAttributedString.Key.foregroundColor:UIColor.cyan, NSAttributedString.Key.font: UIFont.init(name: "Quicksand-Bold", size: 14)])
//        var message = NSMutableAttributedString(attributedString: subjectString1)
//        message.append(subjectString2)

        
        //textView.text = "欢迎访问http://www.hangge.com"
//        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
        //textView.appendLinkString(string: "欢迎使用航歌APP!:")
//        textView.appendLinkString(string: "(1）")
//        textView.appendLinkString(string: "查看详细说明", withURLString: "user:name")
//        //textView.appendLinkString(string: "\n(2）")
//        textView.appendLinkString(string: " 删除", withURLString: "delete:comment")
        self.view.addSubview(textView)
        //textView.attributedText = message
    }
    //链接点击响应方法
     func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                   in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
         if let scheme = URL.scheme {
             switch scheme {
             case "about" :
                 showAlert(tagType: "about",
                           payload: (URL as NSURL).resourceSpecifier!.removingPercentEncoding!)
             case "feedback" :
                 showAlert(tagType: "feedback",
                           payload: (URL as NSURL).resourceSpecifier!.removingPercentEncoding!)
             default:
                 print("这个是普通的url")
             }
         }
          
         return true
     }
      
     //显示消息
     func showAlert(tagType:String, payload:String){
         let alertController = UIAlertController(title: "检测到\(tagType)标签",
             message: payload, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
     }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UITextView {

    func appendLinkString(string:String, withURLString:String = "") -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : self.font!]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
            appendString.addAttribute(NSAttributedString.Key.strokeWidth, value:-4.0, range:range)
            if withURLString == "user:comment" {
                appendString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.init(r: 29, g: 203, b: 219), range: range)
            }else if withURLString == "delete:comment"{
                appendString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.red, range: range)
            }

            appendString.endEditing()
        }

        return appendString
    }
}
