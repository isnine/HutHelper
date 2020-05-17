//
//  MomentSectionHeaderView.swift
//  HutHelper
//
//  Created by 张驰 on 2020/4/3.
//  Copyright © 2020 nine. All rights reserved.
//


import UIKit
import SnapKit
import JXPhotoBrowser
import RxSwift
import RxCocoa

enum MomentCallBackType {
    case UserImgClick
    case MoreTips
    case Like
    case Comment
    case Topic
    case delete
}

protocol MomentCellDelegate:NSObjectProtocol {
    func cellClickCallBack(with data:MomentModel,type:MomentCallBackType,indexPath:IndexPath)
}

class MomentSectionHeaderView: UITableViewHeaderFooterView {
    // 回收rx
    let disposeBag = DisposeBag()
    
    // 代理
    weak var delegate : MomentCellDelegate?
    
    // indexpath
    var indexPath = IndexPath()
    
    // Cell数据
    var cellData = MomentModel()
    // 计算属性更新Cell 与数据
    var data:MomentModel?{
        didSet{
            guard let data = data else { return }
            self.cellData = data
            self.updateUI(with: data)
        }
    }
    
    // 回调闭包
    typealias Block = (_ data:CommentModel) -> Void
    var nameCallback:Block?
    var commentCallback:Block?
    var deleteCallback:((_ index:Int,_ id:String) -> Void)?
    // 数据
    var photoDatas = [String]()
    // 评论数据
    var commentDatas = [CommentModel]()
    // 用户名
    lazy var nameLab:UILabel = {
       let label = UILabel()
        label.textColor = UIColor.init(r: 29, g: 203, b: 219)
       // label.backgroundColor = .red
        return label
    }()
    // 头像
    lazy var userImg:UIImageView = {
       let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 20.fitW
        //img.backgroundColor = .black
        return img
    }()
    // 头像按钮
    lazy var imgBtn: UIButton = {
       let btn = UIButton()
        btn.rx.tap.subscribe(onNext:{[weak self] in
            self!.delegate?.cellClickCallBack(with: self!.cellData, type: .UserImgClick,indexPath: self!.indexPath)
            }).disposed(by: disposeBag)
        return btn
    }()
    // 时间
    lazy var timeLab:UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 9)
        label.textColor = UIColor.init(r: 161, g: 161, b: 161)
        //label.backgroundColor = .green
        return label
    }()
    // 右边拉下菜单
    lazy var menuBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("……", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.backgroundColor = .red
        btn.rx.tap.subscribe(onNext:{[weak self] in
            self!.delegate?.cellClickCallBack(with: self!.cellData, type: .MoreTips,indexPath: self!.indexPath)
            }).disposed(by: disposeBag)
        return btn
    }()
    // 话题按钮1
    lazy var topicBtn1:UIButton = {
       let btn = UIButton()
        btn.setTitle("#求助", for: .normal)
        btn.setTitleColor(UIColor.init(r: 29, g: 203, b: 219), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    // 话题按钮2
    lazy var topicBtn2:UIButton = {
       let btn = UIButton()
        btn.setTitleColor(UIColor.init(r: 29, g: 203, b: 219), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    // 话题按钮3
    lazy var topicBtn3:UIButton = {
       let btn = UIButton()
        btn.setTitleColor(UIColor.init(r: 29, g: 203, b: 219), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    // 文字内容
    lazy var contentLab:UITextView = {
       let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.init(r: 34, g: 34, b: 34)
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        // 解决向下偏移问题
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0;
        return textView
    }()
    // 图片内容
    lazy var imgCollectionView:UICollectionView = {
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
    lazy var depNameLab:UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 12)
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        //label.backgroundColor = .red
        return label
    }()
    // 评论按钮
    lazy var commentBtn:UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "comment"), for: .normal)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            self!.delegate?.cellClickCallBack(with: self!.cellData, type: .Comment,indexPath: self!.indexPath)
            }).disposed(by: disposeBag)
        btn.setTitleColor(UIColor.black, for: .normal)
        
        return btn
    }()
    // 点赞
    lazy var likeBtn:UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "tweet_btn_like"), for: .normal)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            self!.delegate?.cellClickCallBack(with: self!.cellData, type: .Like,indexPath: self!.indexPath)
            }).disposed(by: disposeBag)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    // 删除
    lazy var deleteBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        btn.setTitleColor(UIColor.red, for: .normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            self!.delegate?.cellClickCallBack(with: self!.cellData, type: .delete,indexPath: self!.indexPath)
            }).disposed(by: disposeBag)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    // 分割线
    lazy var line:UIView = {
       let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 223, g: 223, b: 223)
        return vi
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        setUI()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateUI(with data:MomentModel){
        let blank = isIphoneX ? 5.fitW : 5.fitW
        var sumHeight = 50.fitW + blank
        if data.type != "" {
            let types = data.type.components(separatedBy: "、")
            setTopicBtn(with: types, height: sumHeight)
            sumHeight += (20.fitW + blank)
        }
        
        // 内容布局
        var contentHeight = getTextHeight(textStr: data.content, font: UIFont.systemFont(ofSize: 15), width: screenWidth-40.fitW)
        print("contentHeight",contentHeight)
        contentLab.snp.remakeConstraints { (make) in
           make.top.equalTo(self).offset(sumHeight)
            make.height.equalTo(contentHeight+4)
            make.left.equalTo(self).offset(20.fitW)
            make.width.equalTo(screenWidth - 40.fitW)
        }
        
        sumHeight += (Int(contentHeight+10).fitW + blank)
        // 图片布局
        var imgHeight:Int = 0
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
        }else {
            deleteBtn.setTitle("", for: .normal)
            deleteBtn.isUserInteractionEnabled = false
        }
        sumHeight += (20.fitW + blank)
        if data.comments.count != 0 {
            line.isHidden = false
            
            line.snp.remakeConstraints { (make) in
                make.right.equalTo(self).offset(-20.fitW)
                make.left.equalTo(self).offset(20.fitW)
                make.height.equalTo(1.fitW)
                make.top.equalTo(imgCollectionView.snp.bottom).offset(2*blank+20.fitW)
            }
        } else {
            line.isHidden = true
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
        } else {
            likeBtn.setImage(UIImage(named: "tweet_btn_like"), for: .normal)
        }
        
        self.photoDatas = data.pics
        self.imgCollectionView.reloadData()


    }
    func setUI(){
        
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
        addSubview(imgBtn)
        line.isHidden = true
        topicBtn1.isHidden = true
        topicBtn2.isHidden = true
        topicBtn3.isHidden = true
        
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
        menuBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20.fitW)
            make.top.equalTo(self).offset(15.fitW)
            make.width.height.equalTo(20.fitW)
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
    }
    func setTopicBtn(with data:[String],height:Int) {
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

extension MomentSectionHeaderView:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate{
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
            let url = self.photoDatas[index].replacingOccurrences(of:"_thumb", with: "")
            return  imageUrl + url
        }
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
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
extension MomentSectionHeaderView { }
