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
    case concern
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
                    if self.page == 1 {
                        self.viewModel.momentDatas = datas
                    }else {
                        for num in datas {
                            self.viewModel.momentDatas.append(num)
                        }
                    }
                    self.calulateHeight()
                    self.handlerFold(at: indexPath)
                    //self.tableView.reloadSections([indexPath.section], with: .fade)
                    
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
                case .concern:
                    self!.viewModel.getConcernMomentRequst(page: self!.page) { (datas) in
                        self!.callDataHandler(datas: datas)
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
                case .concern:
                    self!.viewModel.getConcernMomentRequst(page: 1) { (datas) in
                        self!.callDataHandler(datas: datas)
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
        if uid != "" || userName != "" {
            self.type = .own(userName, uid);
            self.userId = uid
            
        }
        
        configInit()
        configData()
        configRightMenu(itemTitles: ["发布说说","我的发布","我的互动","热门说说","搜索说说","我的关注"],
                        itemIcons: [UIImage(named: "adds")!,
                                    UIImage(named: "mine")!,
                                    UIImage(named: "menu_talk")!,
                                    UIImage(named: "set_new")!,
                                    UIImage(named: "ico_im_find")!,
                                    UIImage(named: "menu_talk")!],
                        nextController: [MomentAddViewController(),
                                         MomentViewController(type:.own(user.username, "\(user.user_id)")),
                                         MomentViewController(type:.interactive),
                                         MomentViewController(type:.hot),
                                         MomentsSearchViewController(),
                                         MomentViewController(type: .concern)])
    }
    
    func callDataHandler(datas:[MomentModel],type:String = "footer"){
        if self.page == 1 {
            viewModel.momentDatas = datas
        }else {
            for num in datas {
                viewModel.momentDatas.append(num)
            }
        }
        calulateHeight()
        tableView.reloadData()
        if(type=="footer") {
            tableView.mj_footer.endRefreshing()
        }else {
            tableView.mj_header.endRefreshing()
        }
    }
    
    func calulateHeight(){
        for index in 0..<viewModel.momentDatas.count {
            // 计算header 高度
            if Int(viewModel.momentDatas[index].height) == 0 {
                let contentHeight = getTextHeight(textStr: viewModel.momentDatas[index].content, font: UIFont.systemFont(ofSize: 15.fit), width: screenWidth-40.fitW)

                viewModel.momentDatas[index].height = getHeaderHeight(data: viewModel.momentDatas[index]) + contentHeight
                if contentHeight >= 250.fitW {
                    viewModel.momentDatas[index].height += 25.fitW
                }
                viewModel.momentDatas[index].contentHeight = contentHeight
            }
            for i in 0..<viewModel.momentDatas[index].comments.count {
                // 计算cell 高度
                if Int(viewModel.momentDatas[index].comments[i].height) == 0 {
                    viewModel.momentDatas[index].comments[i].height = getCellHeight(data: viewModel.momentDatas[index].comments[i])
                }
            }
        }
    }
    
    func getHeaderHeight(data:MomentModel) -> CGFloat {
        
        var height = 0.0 + 88.fitW


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
        height += imgHeight
        if data.type != "" { height += 25.fitW }
        return height + 5.fitW
    }
    
    func getCellHeight(data:CommentModel) -> CGFloat {
        var contentStr = data.username + "：" + data.comment
        if data.user_id == "\(user.user_id)" {
                contentStr += " 删除"
        }
        let commentTextHeight = getTextHeight(textStr: contentStr, font: UIFont.init(name: "HelveticaNeue-Light", size: 13.fitW)!, width: screenWidth-40.fitW)
        return commentTextHeight + 5.fitW
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
        case .concern:
            self.navigation.item.title = "我的关注"
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
        case .concern:
            self.viewModel.getConcernMomentRequst(page: 1) {(datas) in
                self.callDataHandler(datas: datas)
            }
        }
    }
}

// MARK: 代理 数据源
extension MomentViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let isFold = viewModel.momentDatas[section].isFold
        
        return  isFold ? 0 : viewModel.momentDatas[section].comments.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.momentDatas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = viewModel.momentDatas[indexPath.section].comments[indexPath.row]
        
        var cells = tableView.dequeueReusableCell(withIdentifier: "UseHeadCell") as? CommentCell
        if cells == nil {
            cells = CommentCell.init(style: .default, reuseIdentifier: "UseHeadCell")

        }else{
            while(cells?.contentView.subviews.last != nil) {
                cells?.contentView.subviews.last?.removeFromSuperview()
            }
        }
        
        cells?.update(with: data)
        cells?.indexPath = indexPath
        cells?.selectionStyle = .none
        cells?.delegate = self

        return cells!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = viewModel.momentDatas[indexPath.section].comments[indexPath.row]

        return data.height
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let data = viewModel.momentDatas[section]
        if data.contentHeight >= 250.fitW && data.conntentIsFold {
            return data.height + 250.fit - data.contentHeight
        }
        return data.height
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
