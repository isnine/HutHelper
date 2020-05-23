//
//  MomentCell.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/16.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import SnapKit
import JXPhotoBrowser

protocol MomentCellDelegate {

}

class MomentCell: UITableViewCell {
    // 回调闭包
    typealias Block = (_ data: CommentModel) -> Void
    var nameCallback: Block?
    var commentCallback: Block?
    var deleteCallback:((_ index: Int, _ id: String) -> Void)?
    // 数据
    var photoDatas = [String]()
    // 评论数据
    var commentDatas = [CommentModel]()
    // 用户名
    lazy var nameLab: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.init(r: 29, g: 203, b: 219)
       // label.backgroundColor = .red
        return label
    }()
    // 头像
    lazy var userImg: UIImageView = {
       let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 20.fitW
        //img.backgroundColor = .black
        return img
    }()
    // 头像按钮
    lazy var imgBtn: UIButton = {
       let btn = UIButton()
        return btn
    }()
    // 时间
    lazy var timeLab: UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 9)
        label.textColor = UIColor.init(r: 161, g: 161, b: 161)
        //label.backgroundColor = .green
        return label
    }()
    // 右边拉下菜单
    lazy var menuBtn: UIButton = {
       let btn = UIButton()
        return btn
    }()
    // 话题按钮1
    lazy var topicBtn1: UIButton = {
       let btn = UIButton()
        btn.setTitle("#求助", for: .normal)
        btn.setTitleColor(UIColor.init(r: 29, g: 203, b: 219), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    // 话题按钮2
    lazy var topicBtn2: UIButton = {
       let btn = UIButton()
        btn.setTitleColor(UIColor.init(r: 29, g: 203, b: 219), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    // 话题按钮3
    lazy var topicBtn3: UIButton = {
       let btn = UIButton()
        btn.setTitleColor(UIColor.init(r: 29, g: 203, b: 219), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    // 文字内容
    lazy var contentLab: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.init(r: 34, g: 34, b: 34)
        //label.backgroundColor = .cyan
        label.textAlignment = .left
        return label
    }()
    // 图片内容
    lazy var imgCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 7.fitW
        layout.itemSize = CGSize(width: 120.fitW, height: 120.fitW)
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        //collection.collectionViewLayout = layout
        collection.register(ImgsViewCell.self, forCellWithReuseIdentifier: "ImgsViewCell")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    // 学院
    lazy var depNameLab: UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 12)
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        //label.backgroundColor = .red
        return label
    }()
    // 评论按钮
    lazy var commentBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "comment"), for: .normal)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //btn.backgroundColor = .cyan
        btn.setTitleColor(UIColor.black, for: .normal)

        return btn
    }()
    // 点赞
    lazy var likeBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "tweet_btn_like"), for: .normal)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
               // btn.backgroundColor = .red
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    // 删除
    lazy var deleteBtn: UIButton = {
       let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        btn.setTitleColor(UIColor.red, for: .normal)
        return btn
    }()
    // 分割线
    lazy var line: UIView = {
       let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 223, g: 223, b: 223)
        return vi
    }()
    // 评论区
    lazy var tableView: UITableView = {
       let tableview = UITableView()
        //tableview.backgroundColor = .green
        tableview.tag = 2001
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
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

    func updateUI(with data: MomentModel) {
        let blank = isIphoneX ? 5.fitW : 5.fitW
        var sumHeight = 50.fitW + blank
        if data.type != "" {
            let types = data.type.components(separatedBy: "、")
            setTopicBtn(with: types, height: sumHeight)
            sumHeight += (20.fitW + blank)
        }

        // 内容布局
        var contentHeight = getTextHeight(textStr: data.content, font: UIFont.systemFont(ofSize: 15), width: screenWidth-40.fitW)
        print("contentHeight", contentHeight)
        contentLab.snp.remakeConstraints { (make) in
           make.top.equalTo(self).offset(sumHeight)
            make.height.equalTo(contentHeight+4)
            make.left.equalTo(self).offset(20.fitW)
            make.width.equalTo(screenWidth - 40.fitW)
        }
        sumHeight += (Int(contentHeight+10).fitW + blank)
        // 图片布局
        var imgHeight: Int = 0
        switch data.pics.count {
        case 1, 2, 3:
            imgHeight = 120.fitW
        case 4, 5, 6:
            imgHeight = 247.fitW
        case 7, 8, 9:
            imgHeight = 374.fitW
        default:
            break
        }
        imgCollectionView.snp.remakeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(1.fitW)
            make.height.equalTo(imgHeight)
            make.left.equalTo(self).offset(20.fitW)
            make.width.equalTo(screenWidth - 40.fitW)
        }
        sumHeight += (imgHeight + blank)
        depNameLab.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.width.equalTo(150.fitW)
            make.height.equalTo(20.fitW)
            make.top.equalTo(imgCollectionView.snp.bottom).offset(blank)
        }
        commentBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-20.fitW)
            make.width.equalTo(50.fitW)
            make.height.equalTo(20.fitW)
            make.top.equalTo(imgCollectionView.snp.bottom).offset(blank)
        }
        likeBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-75.fitW)
            make.width.equalTo(50.fitW)
            make.height.equalTo(20.fitW)
            make.top.equalTo(imgCollectionView.snp.bottom).offset(blank)
        }
        if data.user_id == "\(user.user_id)" {
            deleteBtn.setTitle("删除", for: .normal)
            deleteBtn.isUserInteractionEnabled = true
            deleteBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(self).offset(-130.fitW)
                make.width.equalTo(50.fitW)
                make.height.equalTo(20.fitW)
                make.top.equalTo(imgCollectionView.snp.bottom).offset(blank)
            }
        } else {
            deleteBtn.setTitle("", for: .normal)
            deleteBtn.isUserInteractionEnabled = false
        }
        sumHeight += (20.fitW + blank)
        if data.comments.count != 0 {
            line.isHidden = false
            tableView.isHidden = false
            line.snp.remakeConstraints { (make) in
                make.right.equalTo(self).offset(-20.fitW)
                make.left.equalTo(self).offset(20.fitW)
                make.height.equalTo(1.fitW)
                make.top.equalTo(imgCollectionView.snp.bottom).offset(2*blank+20.fitW)
            }
            sumHeight += (1.fitW + blank)
            self.commentDatas = data.comments
            var commetHeight: CGFloat = 0.0
            for comment in data.comments {
                let commentTextHeight = getTextHeight(textStr: comment.comment, font: UIFont.init(name: "HelveticaNeue-Light", size: 13)!, width: screenWidth-40.fitW)
                commetHeight += commentTextHeight
                commetHeight += 15.fitW
            }
            tableView.snp.remakeConstraints { (make) in
                make.right.equalTo(self).offset(-20.fitW)
                make.left.equalTo(self).offset(20.fitW)
                make.top.equalTo(line.snp.bottom).offset(blank)
                make.height.equalTo(Double(commetHeight))
            }

        }

        let imgUrl = URL(string: imageUrl + data.head_pic_thumb)
        self.userImg.kf.setImage(with: imgUrl)
        nameLab.text = data.username
        timeLab.text = data.created_on

        contentLab.text = data.content
        depNameLab.text = data.dep_name
        commentBtn.setTitle("\(data.comments.count)", for: .normal)
        likeBtn.setTitle(data.likes, for: .normal)

        if data.is_like {
            likeBtn.setImage(UIImage(named: "tweet_btn_liked"), for: .normal)
        }

        self.photoDatas = data.pics
        self.imgCollectionView.reloadData()
        self.tableView.reloadData()

    }
    func setUI() {
        addSubview(userImg)
        addSubview(nameLab)
        addSubview(timeLab)
        addSubview(menuBtn)
        addSubview(topicBtn1)
        addSubview(topicBtn2)
        addSubview(topicBtn3)
        addSubview(contentLab)
        addSubview(imgCollectionView)
        addSubview(depNameLab)
        addSubview(commentBtn)
        addSubview(likeBtn)
        addSubview(deleteBtn)
        addSubview(line)
        addSubview(tableView)
        addSubview(imgBtn)
        line.isHidden = true
        topicBtn1.isHidden = true
        topicBtn2.isHidden = true
        topicBtn3.isHidden = true
        tableView.isHidden = true

        userImg.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.top.equalTo(self).offset(10.fitW)
            make.width.height.equalTo(40.fitW)
        }
        imgBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.top.equalTo(self).offset(10.fitW)
            make.width.height.equalTo(40.fitW)
        }

        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(65.fitW)
            make.top.equalTo(self).offset(10.fitW)
            make.width.equalTo(250.fitW)
            make.height.equalTo(20.fitW)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(65.fitW)
            make.bottom.equalTo(userImg.snp.bottom).offset(0)
            make.width.equalTo(200.fitW)
            make.height.equalTo(15.fitW)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.width.equalTo(screenWidth - 40.fitW)
        }
        imgCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.width.equalTo(screenWidth - 40.fitW)
        }
        depNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.width.equalTo(150.fitW)
            make.height.equalTo(20.fitW)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20.fitW)
            make.width.equalTo(50.fitW)
            make.height.equalTo(20.fitW)
        }
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-75.fitW)
            make.width.equalTo(50.fitW)
            make.height.equalTo(20.fitW)
        }
        line.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20.fitW)
            make.left.equalTo(self).offset(20.fitW)
            make.height.equalTo(1.fitW)
        }
        tableView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20.fitW)
            make.left.equalTo(self).offset(20.fitW)
        }
    }
    func setTopicBtn(with data: [String], height: Int) {
        var datas = [String]()
        for da in data {
            let das = "#" + da
            datas.append(das)
        }

        let nameBtnSize1 = textSize(text: datas[0], font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: 414, height: 20))
        let nameWidth1 = nameBtnSize1.width + 5
        topicBtn1.isHidden = false
        topicBtn1.setTitle(datas[0], for: .normal)
        topicBtn1.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.fitW)
            make.top.equalTo(self).offset(55.fitW)
            make.width.equalTo(nameWidth1.fitW)
            make.height.equalTo(20.fitW)
        }

        if data.count == 2 {
            let nameBtnSize2 = textSize(text: datas[1], font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: 414, height: 20))
            let nameWidth2 = nameBtnSize2.width + 5
            topicBtn2.isHidden = false
            topicBtn2.setTitle(datas[1], for: .normal)
            topicBtn2.snp.makeConstraints { (make) in
                make.left.equalTo(topicBtn1.snp.right).offset(20.fitW)
                make.top.equalTo(self).offset(55.fitW)
                make.width.equalTo(nameWidth2.fitW)
                make.height.equalTo(20.fitW)
            }
        }
        if data.count == 3 {
            let nameBtnSize2 = textSize(text: datas[1], font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: 414, height: 20))
            let nameWidth2 = nameBtnSize2.width + 5
            topicBtn2.isHidden = false
            topicBtn2.setTitle(datas[1], for: .normal)
            topicBtn2.snp.makeConstraints { (make) in
                make.left.equalTo(topicBtn1.snp.right).offset(20.fitW)
                make.top.equalTo(self).offset(55.fitW)
                make.width.equalTo(nameWidth2.fitW)
                make.height.equalTo(20.fitW)
            }
            let nameBtnSize3 = textSize(text: datas[2], font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: 414, height: 20))
            let nameWidth3 = nameBtnSize3.width + 5
            topicBtn3.isHidden = false
            topicBtn3.setTitle(datas[2], for: .normal)
            topicBtn3.snp.makeConstraints { (make) in
                make.left.equalTo(topicBtn2.snp.right).offset(20.fitW)
                make.top.equalTo(self).offset(55.fitW)
                make.width.equalTo(nameWidth3.fitW)
                make.height.equalTo(20.fitW)
            }

        }

    }

}

extension MomentCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgsViewCell", for: indexPath) as! ImgsViewCell
        let imgUrl = URL(string: imageUrl + photoDatas[indexPath.row])
        cell.imageView.kf.setImage(with: imgUrl)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("11")
        // 网图加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return self.photoDatas.count
        }, placeholder: { index -> UIImage? in
            let cell = self.imgCollectionView.cellForItem(at: indexPath) as? ImgsViewCell
            return cell?.imageView.image
        }) { index -> String? in
            // 去掉_thumb 获取高清图url
            let url = self.photoDatas[index].replacingOccurrences(of: "_thumb", with: "")
            return  imageUrl + url
        }
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (_, index, _) -> UIView? in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = self.imgCollectionView.cellForItem(at: indexPath) as? ImgsViewCell
            return cell?.imageView
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: indexPath.row)
    }
}

// MARK: 代理 数据源
extension MomentCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.commentDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let now = Date()
        let timeForMatter = DateFormatter()
        timeForMatter.dateFormat = "yyyy年MM月dd:HH点mm分:EE"
        let id = timeForMatter.string(from: now)
        let identifier = "\(id)Comment\(indexPath.section)\(indexPath.row)"

        self.tableView.register(CommentCell.self, forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CommentCell
        cell.updateUI(with: commentDatas[indexPath.section])
        cell.selectionStyle = .none
        cell.nameBtn.addTarget(self, action: #selector(nameButton(_:event:)), for: .touchUpInside)
        cell.contentBtn.addTarget(self, action: #selector(cellButton(_:event:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteButton(_:event:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = commentDatas[indexPath.section]
        let commentHeight = getTextHeight(textStr: data.comment, font: UIFont.init(name: "HelveticaNeue-Light", size: 13)!, width: screenWidth - 40.fitW)
        return 15.fitW + commentHeight
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
        print(indexPath)
    }
    @objc func nameButton(_ sender: UIButton?, event: UIEvent?) {
        let touches = event?.allTouches
        let touch = touches?.first
        let currentTouchPosition = touch?.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: currentTouchPosition ?? CGPoint.zero)
        if let indexPath = indexPath {
            self.nameCallback!(self.commentDatas[indexPath.section])
            print("姓名btn", indexPath)
        }
    }
    @objc func cellButton(_ sender: UIButton?, event: UIEvent?) {
        let touches = event?.allTouches
        let touch = touches?.first
        let currentTouchPosition = touch?.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: currentTouchPosition ?? CGPoint.zero)
        if let indexPath = indexPath {
            self.commentCallback!(self.commentDatas[indexPath.section])
            print("cellBtn", indexPath)
        }
    }
    @objc func deleteButton(_ sender: UIButton?, event: UIEvent?) {
        let touches = event?.allTouches
        let touch = touches?.first
        let currentTouchPosition = touch?.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: currentTouchPosition ?? CGPoint.zero)
        if let indexPath = indexPath {
            self.deleteCallback!(indexPath.section, commentDatas[indexPath.section].id)
            print("deleteBtn", indexPath)
        }
    }
}
