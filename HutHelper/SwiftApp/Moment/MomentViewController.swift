//
//  MomentViewController.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/15.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import JXPhotoBrowser
import HandyJSON
import SwiftyJSON
import SnapKit
//import MJRefresh
//import ProgressHUD

enum MomentType {
    case all
    case hot
    case own(String,String)
    case interactive
    case custom(String)
}



class MomentViewController: BaseNarViewController {
    

    
    // 评论View
    lazy var comment:CommentView = {
        let commentView = CommentView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 40.fitW))
        commentView.callback = { (content,indexPath) in
            let data = self.viewModel.momentDatas[indexPath.section]
            self.viewModel.getCommentSayRequst(comment: content, momentId: data.id) {
                self.viewModel.getAllMomentRequst(page: 1) {
                    (datas) in
                    self.callDataHandler(datas: datas)
                }
            }
        }
        return commentView
    }()
    var page = 1 // 页数
    // 图片数据
    var photoDatas = [UIImage]()
   

    // 右边搜索
    private lazy var rightBarButton1:UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x:-5, y:0, width:30, height: 30)
            btn.setImage(UIImage(named: "ico_im_find"), for: .normal)
        btn.backgroundColor = .red
            btn.rx.tap.subscribe(onNext:{[weak self] in
                self?.menuView.show()
            }).disposed(by: disposeBag)
        return btn
    }()


    
    lazy var tableView:UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
            tableview.separatorStyle = .none
            tableview.delegate = self
            tableview.dataSource = self
            tableview.backgroundColor = .white
            tableview.register(UseHeadCell.self, forCellReuseIdentifier: "UseHeadCell")
            tableview.register(MomentSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "cell")
            tableview.mj_footer = MJRefreshBackNormalFooter {[weak self] in
                self!.page += 1
                switch self!.type {
                case .all:
                    self!.viewModel.getAllMomentRequst(page: self!.page) { (datas) in
                        self!.callDataHandler(datas: datas)
                    }
                case .hot:
                   self!.viewModel.getHotMomentRequst(page: self!.page,day: 30) { (datas) in
                       self!.callDataHandler(datas: datas)
                   }
                case .own(let userName):
                    self!.viewModel.getOwnMomentRequst(page: self!.page, userId: self!.userId) {(datas) in
                        self!.callDataHandler(datas: datas)
                    }
                case .interactive:
                    self!.viewModel.getInteractiveMomentRequst(page: self!.page) { (datas) in
                        self!.callDataHandler(datas: datas)
                    }
                case .custom(let content):
                    self!.viewModel.getSearchMomentRequst(content: content, page: self!.page) { _ in
                        print("json 成功")
                        self!.tableView.reloadData()
                        tableview.mj_footer.endRefreshing()
                    }
                }
                
            }
            tableview.mj_header = MJRefreshNormalHeader {[weak self] in
                self!.page = 1
                switch self!.type {
                case .all:
                    self!.viewModel.getAllMomentRequst(page: 1) {
                        (datas) in
                        self!.callDataHandler(datas: datas,type: "header")
                    }
                    
                case .hot:
                   self!.viewModel.getHotMomentRequst(page: 1,day: 30) {(datas) in
                       self!.callDataHandler(datas: datas,type: "header")
                   }
                case .own(let userName,let userId):
                    self!.viewModel.getOwnMomentRequst(page: 1, userId: userId) {(datas) in
                        self!.callDataHandler(datas: datas,type: "header")
                    }
                case .interactive:
                    self!.viewModel.getInteractiveMomentRequst(page: 1) {(datas) in
                        self!.callDataHandler(datas: datas,type: "header")
                    }
                case .custom(let content):
                    self!.viewModel.getSearchMomentRequst(content: content, page: 1) { (datas) in
                        if datas.count == 0 {
                            self!.navigation.item.title = "没有关于“\(content)”的说说"
                        }else {
                            self!.callDataHandler(datas: datas)
                        }
                    }
                }
            }
        return tableview
    }()
    

    
    // viewModel
    lazy var viewModel:MomentViewModel = {
       return MomentViewModel()
    }()
    
    var type:MomentType = .all
    var userId = ""
    // oc 调
    @objc var uid = ""
    @objc var userName = ""
    
    convenience init(type:MomentType = .all) {
        self.init()
        self.type = type
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if uid != "" && userName != "" {
            self.type = .own(userName, uid);
        }
        
        configInit()
        configData()
       configRightMenu(itemTitles: ["发布说说","我的发布","我的互动","热门说说","搜索说说"], itemIcons: [UIImage(named: "adds")!,UIImage(named: "mine")!,UIImage(named: "menu_talk")!,UIImage(named: "set_new")!,UIImage(named: "ico_im_find")!], nextController: [MomentAddViewController(),MomentViewController(type:.own(user.username, "\(user.user_id)")),MomentViewController(type:.interactive),MomentViewController(type:.hot),MomentsSearchViewController()])
    }
    
    func callDataHandler(datas:[MomentModel],type:String = "footer"){
        if self.page == 1 {
            viewModel.momentDatas = datas
        }else {
            for num in datas {
                viewModel.momentDatas.append(num)
            }
        }
        tableView.reloadData()
        if(type=="footer") {
            tableView.mj_footer.endRefreshing()
        }else {
            tableView.mj_header.endRefreshing()
        }
    }
        
    
    func configInit(){
        switch type {
        case .all:
            self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
            self.navigation.item.title = "校园说说"
        case .hot:
            self.navigation.item.title = "热门说说"
        case .own(let userName,let _):
            if userName == user.username {
                self.navigation.item.title = "我的说说"
            }else {
                self.navigation.item.title = userName + "的说说"
            }
        case .interactive:
            self.navigation.item.title = "我的互动"
        case .custom(let content):
            self.navigation.item.title = "关于“\(content)”的说说"
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(screenHeight)
        }
        
        view.addSubview(comment)
        self.automaticallyAdjustsScrollViewInsets = false

        
    }
    func configData(){
        switch self.type {
        case .all:
            self.viewModel.getAllMomentRequst(page: 1) {
                (datas) in
                self.callDataHandler(datas: datas)
            }
        case .hot:
           self.viewModel.getHotMomentRequst(page: 1,day: 30) {(datas) in
               self.callDataHandler(datas: datas)
           }
        case .own(let userName,let userId):
            self.viewModel.getOwnMomentRequst(page: 1, userId: userId) {(datas) in
                self.callDataHandler(datas: datas)
            }
        case .interactive:
            self.viewModel.getInteractiveMomentRequst(page: 1) {(datas) in
                self.callDataHandler(datas: datas)
            }
        case .custom(let content):
            self.viewModel.getSearchMomentRequst(content: content, page: 1) { (datas) in
                if datas.count == 0 {
                    self.navigation.item.title = "没有关于“\(content)”的说说"
                }else {
                    self.callDataHandler(datas: datas)
                }
            }
        }
    }
}

// MARK: 代理 数据源
extension MomentViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.momentDatas[section].comments.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.momentDatas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let now = Date()
        let timeForMatter = DateFormatter()
        timeForMatter.dateFormat = "yyyy年MM月dd:HH点mm分:EE"
        let id = timeForMatter.string(from: now)
        let identifier = "\(id)1CommentCell\(indexPath.section)\(indexPath.row)"
        
        self.tableView.register(CommentCell.self, forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CommentCell
        let data = viewModel.momentDatas[indexPath.section].comments[indexPath.row]
        
        cell.update(with: data)
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = viewModel.momentDatas[indexPath.section].comments[indexPath.row]
        var contentStr = data.username + "：" + data.comment
        if data.user_id == "\(user.user_id)" {
                contentStr += " 删除"
        }
        let commentTextHeight = getTextHeight(textStr: contentStr, font: UIFont.init(name: "HelveticaNeue-Light", size: 13)!, width: screenWidth-40.fitW)
        return commentTextHeight + 10.fitW
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let data = viewModel.momentDatas[section]
        var height = 0.0 + 92.fitW
        let contentHeight = getTextHeight(textStr: data.content, font: UIFont.systemFont(ofSize: 15), width: screenWidth-40.fitW)

        var imgHeight:CGFloat = 0.0
        switch data.pics.count {
        case 1,2,3:
            imgHeight = 120.fitW
        case 4,5,6:
            imgHeight = 247.fitW
        case 7,8,9:
            imgHeight = 374.fitW
        default:
            break;
        }
        height += contentHeight
        height += imgHeight
        if data.type != "" { height += 20.fitW }
        return height + 5.fitW
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cell") as! MomentSectionHeaderView
        headerView.data = viewModel.momentDatas[section]
       
        headerView.delegate = self
        let indexpath = IndexPath(row: 0, section: section)
        headerView.indexPath = indexpath
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.fitW
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 248, g: 248, b: 248)
        return vi
    }

    
}

// MARK: 空白页处理
extension MomentViewController:UIGestureRecognizerDelegate {
    
}
// MARK: 空白页处理
extension MomentViewController {
    
}

