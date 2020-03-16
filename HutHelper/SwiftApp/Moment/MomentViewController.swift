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
    lazy var commentView :AlterSginView = {
        let commentView = AlterSginView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            commentView.delegate = self
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
        let tableview = UITableView()
            tableview.tag = 2001
            tableview.separatorStyle = .none
            tableview.allowsSelection = false
            tableview.delegate = self
            tableview.dataSource = self
            tableview.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
            tableview.register(UseHeadCell.self, forCellReuseIdentifier: "UseHeadCell")
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
        UIApplication.shared.windows[0].addSubview(commentView)
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
extension MomentViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.momentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let now = Date()
        let timeForMatter = DateFormatter()
        timeForMatter.dateFormat = "yyyy年MM月dd:HH点mm分:EE"
        let id = timeForMatter.string(from: now)
        let identifier = "\(id)MomentCell\(indexPath.section)\(indexPath.row)"
        
        self.tableView.register(MomentCell.self, forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MomentCell
        cell.updateUI(with: viewModel.momentDatas[indexPath.section])
        cell.commentBtn.addTarget(self, action: #selector(commentBtn(_:event:)), for: .touchUpInside)
        cell.likeBtn.addTarget(self, action: #selector(likeBtn(_:event:)), for: .touchUpInside)
        cell.imgBtn.addTarget(self, action: #selector(imgBtn(_:event:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtn(_:event:)), for: .touchUpInside)
        cell.nameCallback = {[weak self] (data) in
            print("callback 昵称",data)
//            let vc = PersonViewController(userid: data.user_id)
//            self?.navigationController?.pushViewController(vc, animated: true)
            print(self?.type as Any)
        }
        cell.commentCallback = {[weak self] (data) in
            print("callback 内容",data)
            self!.commentView.indexPath = indexPath
            self!.commentView.textField.text = "@\(data.username)"
            self!.commentView.showAddView()
        }
        cell.deleteCallback = {[weak self] (index,momentId) in
            self!.viewModel.getDeleteCMomentRequst(commentId: momentId) {
                cell.commentDatas.remove(at: index)
                let indexSet = NSIndexSet(index: index)
                cell.tableView.deleteSections(indexSet as IndexSet, with: .right)
                self!.viewModel.momentDatas[indexPath.section].comments.remove(at: index)
                self!.tableView.reloadData()
                //cell.tableView.reloadData()
                //self!.configData()
//            self!.viewModel.momentDatas[indexPath.row].comments.remove(at: index)
//                let indexSet = NSIndexSet(index: indexPath.section)
//                self!.tableView.reloadSections(indexSet as IndexSet, with: .automatic)
//                self!.tableView.reloadData()
               // ProgressHUD.showSuccess("删除成功")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = viewModel.momentDatas[indexPath.section]
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
        for comment in data.comments {
            let commentTextHeight = getTextHeight(textStr: comment.comment, font: UIFont.init(name: "HelveticaNeue-Light", size: 13)!, width: screenWidth-40.fitW)
            height += commentTextHeight
            height += 15.fitW
        }
        height += contentHeight
        height += imgHeight
        if data.type != "" { height += 20.fitW }
        return CGFloat(height+10.0)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 233, g: 238, b: 238)
        return vi
    }
    @objc func imgBtn(_ sender: UIButton?, event: UIEvent?) {
        let touches = event?.allTouches
        let touch = touches?.first
        let currentTouchPosition = touch?.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: currentTouchPosition ?? CGPoint.zero)
        if let indexPath = indexPath {
            let data = viewModel.momentDatas[indexPath.section]
            let vc = UserShowViewController()
            vc.dep_name = data.dep_name
            vc.name = data.username
            vc.user_id = data.user_id
            vc.head_pic = data.head_pic_thumb
        self.navigationController?.pushViewController(vc, animated: true)
        print("头像btn",data)
        }
    }
    @objc func deleteBtn(_ sender: UIButton?, event: UIEvent?) {
        let touches = event?.allTouches
        let touch = touches?.first
        let currentTouchPosition = touch?.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: currentTouchPosition ?? CGPoint.zero)
        if let indexPath = indexPath {
            let data = self.viewModel.momentDatas[indexPath.section]
            self.viewModel.getDeleteMomentRequst(momentId: data.id) {
                self.viewModel.momentDatas.remove(at: indexPath.section)
                let indexSet = NSIndexSet(index: indexPath.section)
                self.tableView.deleteSections(indexSet as IndexSet, with: .right)
                
                self.tableView.reloadData()
//                let cell = self.tableView.cellForRow(at: indexPath) as! MomentCell
//                cell.deleteBtn .isHidden = true
               // ProgressHUD.showSuccess("删除成功")
            }
        }
    }
    
    @objc func commentBtn(_ sender: UIButton?, event: UIEvent?) {
        let touches = event?.allTouches
        let touch = touches?.first
        let currentTouchPosition = touch?.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: currentTouchPosition ?? CGPoint.zero)
        if let indexPath = indexPath {
            commentView.indexPath = indexPath
            commentView.showAddView()
        }
    }
    @objc func likeBtn(_ sender: UIButton?, event: UIEvent?) {
        let touches = event?.allTouches
        let touch = touches?.first
        let currentTouchPosition = touch?.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: currentTouchPosition ?? CGPoint.zero)
        //let cell = tableView.cellForRow(at: indexPath)
        if let indexPath = indexPath {
            let data = viewModel.momentDatas[indexPath.section]
            let cell = tableView.cellForRow(at: indexPath) as! MomentCell
            viewModel.getLikeMomentRequst(momentId: data.id) {
                self.viewModel.momentDatas[indexPath.section].is_like = !self.viewModel.momentDatas[indexPath.section].is_like
                if data.is_like {
                    cell.likeBtn.setImage(UIImage(named: "tweet_btn_like"), for: .normal)
                    cell.likeBtn.setTitle("\(Int(data.likes)!-1)", for:.normal)
                    self.viewModel.momentDatas[indexPath.section].likes = "\(Int(data.likes)!-1)"
                    
                }else {
                    cell.likeBtn.setImage(UIImage(named: "tweet_btn_liked"), for: .normal)
                    cell.likeBtn.setTitle("\(Int(data.likes)!+1)", for:.normal)
                        self.viewModel.momentDatas[indexPath.section].likes = "\(Int(data.likes)!+1)"
                }
            }

        }
    }
}

// MARK: 空白页处理
extension MomentViewController {
    
}

extension MomentViewController:AlterSginDelegate{
    
    func commentCallback(content: String, indexPath: IndexPath) {
        let data = self.viewModel.momentDatas[indexPath.section]
        viewModel.getCommentSayRequst(comment: content, momentId: data.id) {
            self.viewModel.getAllMomentRequst(page: 1) {
                (datas) in
                self.callDataHandler(datas: datas)
            }
//            let commentdata = CommentModel(id: "1", moment_id: data.id, comment: content, user_id: "\(user.user_id)", created_on: "11", username: user.username)
//        self.viewModel.momentDatas[indexPath.section].comments.append(commentdata)
//            let indexSet = NSIndexSet(index: indexPath.section)
//            self.tableView.reloadSections(indexSet as IndexSet, with: .automatic)
        }
    }
    
}
