//
//  MoreViewController.swift
//  HutHelper
//
//  Created by nine on 2018/12/3.
//  Copyright © 2018 nine. All rights reserved.
//

import UIKit
import SnapKit
import CollectionKit
import Alamofire
import SwiftyJSON
import HandyJSON

class MoreViewController: UIViewController {
    fileprivate let url = "https://img.wxz.name/api/more.json"
    fileprivate var dataSource = ArrayDataSource(data: [More]())
    fileprivate lazy var collectionView = CollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCV()
        configUI()
        configData()
    }
}

// MARK: - Config
extension MoreViewController {
    fileprivate func configData() {
        Alamofire.request(url).responseJSON{(responds) in
            guard responds.result.isSuccess else { return }
            if let value = responds.result.value {
                let json = JSON(value)
                
                let links = json["links"]
                for link in links{
                    if let mainmodel = More.deserialize(from: link.1.rawString()) {
                        self.dataSource.data.append(mainmodel)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func configUI() {
        view.backgroundColor = .white
        navigationItem.title = "更多"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor(red: 29 / 255.0, green: 203 / 255.0, blue: 219 / 255.0, alpha: 1)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    fileprivate func configCV() {
        let viewSource = ClosureViewSource(viewUpdater: { (view: MoreCell, data: More, index: Int) in
            view.updataUI(with: data)
        })
        
        let sizeSource = { (index: Int, data: More, collectionSize: CGSize) -> CGSize in
            var cellHeight = CGFloat(self.getTextHeigh(textStr: data.describe, font: UIFont.boldSystemFont(ofSize: 18), width: 300))
            cellHeight += 55
            if data.image != "" {
                cellHeight += 150
            }
            if data.app != nil {
                cellHeight += 40
            }
            return CGSize(width: collectionSize.width, height: cellHeight)
        }
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.layout = FlowLayout(spacing: 30)
        provider.tapHandler = { context -> Void in
            guard context.data.url != "" else { return }
            if context.data.url.hasPrefix("huthelperBuy://") {
                StoreHelper.buy(productId: context.data.url.replacingOccurrences(of: "huthelperBuy://", with: ""))
            } else if let u = URL.init(string: context.data.url) {
                UIApplication.shared.open(u, options: [:], completionHandler: nil)
            }
        }
        collectionView.provider = provider
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
}
// MARK: - Tool
extension MoreViewController {
    fileprivate func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size,options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
}

extension Int {
    public var fit: Int {
        return Int(CGFloat(self)/414.0 * UIScreen.main.bounds.width)
    }
}
