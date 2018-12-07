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

class AppModel: HandyJSON {
    var ico : String  = ""
    var describe : String = ""
    var title : String?
    required init() {}
}
class MainModel : HandyJSON {
    var image : String = ""
    var title : String = ""
    var describe : String = ""
    var app : AppModel?
    required init() {}
}
class MoreViewController: UIViewController {
    let url = "https://img.wxz.name/api/more.json"
    var mainModel = [MainModel]()
    var FONT : String?
    var cellHeight1 = 0
    lazy var collectionView = CollectionView()
    lazy var pageTitleCollectionView: CollectionView = {
        let cv = CollectionView()
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    var currentPage = 0 {
        didSet {
            showPageTitle(index: currentPage)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkTool()
        // Do any additional setup after loading the view.
    }
    func NetworkTool() {
        Alamofire.request(url).responseJSON{(responds) in
            guard responds.result.isSuccess else { return }
            if let value = responds.result.value {
                let json = JSON(value)
                
                let links = json["links"]
                for index in 0..<4{
                    let mainmodel = MainModel.deserialize(from: links[index].rawString()!)
                    self.mainModel.append(mainmodel!)
                }
                print(self.mainModel)
                self.configCV()
                self.configUI()
           }
      }
    }
  
    func configUI() {
        view.backgroundColor = .white
        navigationItem.title = "更多"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor(red: 29 / 255.0, green: 203 / 255.0, blue: 219 / 255.0, alpha: 1)
//        view.addSubview(pageTitleCollectionView)
//        pageTitleCollectionView.snp.makeConstraints { (make) in
//            make.height.equalTo(140)
//            make.width.equalTo(view)
//            make.top.equalTo(view)
//            make.centerX.equalTo(view)
//        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
//    func configPageTitle() {
//        let dataSource = ArrayDataSource(data: [0, 1])
//        let viewSource = ClosureViewSource(viewUpdater: { (view: PageTitleView, _: Int, index: Int) in
//            switch index {
//            case 0:
//                view.label.text = "支持开发者"
//            case 1:
//                view.label.text = "内测与问卷"
//            default:
//                assertionFailure()
//            }
//            if index == self.currentPage { view.isSelected = true }
//        })
//        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
//            return CGSize(width: 100.fit, height: 20)
//        }
//        let provider = BasicProvider<Int, PageTitleView>(
//            dataSource: dataSource,
//            viewSource: viewSource,
//            sizeSource: sizeSource
//        )
//        provider.tapHandler = { context -> Void in
////            switch context.index {
////            case 0:
////                self.jumpThing()
////            case 1:
////                self.jumpLocation()
////            case 2:
////                self.jumpCustom()
////            default:
////                assertionFailure()
////            }
//        }
//        provider.layout = RowLayout(spacing: 40, justifyContent: .center)
//        pageTitleCollectionView.backgroundColor = .white
//        pageTitleCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//        pageTitleCollectionView.provider = provider
//    }
    
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
            let normalText: NSString = textStr as NSString
            let size = CGSize(width: width, height: 1000)
            let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
            let stringSize = normalText.boundingRect(with: size,options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
                return stringSize.height
    }
    func configCV() {
        
        var cellHeight = 0
        
        let dataSource = ArrayDataSource(data: [0, 1, 2, 3])
        let viewSource = ClosureViewSource(viewUpdater: { (view: MoreCell, data: Int, index: Int) in
           
            if self.mainModel[data].image != "" {
                let urlTitleImage = URL(string: self.mainModel[data].image)
                let dataTitleImage = try? Data(contentsOf: urlTitleImage! )
                view.titleImageView.image = UIImage(data: dataTitleImage!)
            }
            if self.mainModel[data].app != nil{
                let urlIcoImage = URL(string: self.mainModel[data].app?.ico ?? "" )
                let dataIcoImage = try? Data(contentsOf: urlIcoImage!)
                view.icoImageView.image = UIImage(data: dataIcoImage!)
            }
                view.icoTitle.text = self.mainModel[data].app?.title
                view.icoType.text = self.mainModel[data].app?.describe
                view.title.text = self.mainModel[data].title
                view.describe.text = self.mainModel[data].describe
        })
        
        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
           cellHeight = Int(self.getTextHeigh(textStr: self.mainModel[data].describe, font: UIFont.boldSystemFont(ofSize: 18), width: 300))
            print("describe行高为\(cellHeight)")
            if self.mainModel[data].image == "" , self.mainModel[data].app == nil {
                flagTitleImageAndIcoImage[data] = 1
                return CGSize(width: 374.fit, height: cellHeight+80)
            }
            if self.mainModel[data].image == "" {
                flagTitleImage[data] = 1
                return CGSize(width: 374.fit, height: cellHeight+120 )
                
            }
            if self.mainModel[data].app == nil{
                flagIcoImage[data] = 1
                return CGSize(width: 374.fit, height: cellHeight+140)
            }
            return CGSize(width: 374.fit, height: cellHeight+180 )
        }
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.layout = FlowLayout(spacing: 30)
        //lastly assign this provider to the collectionView to display the content
        collectionView.provider = provider
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        print(flagIcoImage,flagTitleImage,flagTitleImageAndIcoImage)
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

extension MoreViewController {
//    @objc func jumpThing() {
//        pageCollectionView.setContentOffset(CGPoint.init(x: view.bounds.width * 0, y: 0), animated: true)
//    }
//    @objc func jumpLocation() {
//        pageCollectionView.setContentOffset(CGPoint.init(x: view.bounds.width * 1, y: 0), animated: true)
//    }
//    @objc func jumpCustom() {
//        pageCollectionView.setContentOffset(CGPoint.init(x: view.bounds.width * 2, y: 0), animated: true)
//    }
    func showPageTitle(index: Int) {
        self.pageTitleCollectionView.visibleCells.forEach {
            if let cell = $0 as? PageTitleView {
                cell.isSelected = false
            }
        }
        if let cell = self.pageTitleCollectionView.cell(at: index) as? PageTitleView {
            cell.isSelected = true
        }
    }
}

extension Int {
    public var fit: Int {
        return Int(CGFloat(self)/414.0 * UIScreen.main.bounds.width)
    }
}
