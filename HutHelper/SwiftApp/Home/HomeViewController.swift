//
//  HomeViewController.swift
//  HutHelper
//
//  Created by 张驰 on 2019/11/21.
//  Copyright © 2019 nine. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: HUTBaseViewController {

    var funcsData = [HomeFuncsModel]()
    var schoolNewsData = [HomeSchoolNewsModel]()
    
    let HeaderViewID = "HomeHeaderReusableView"
    let HomeHeaderCellID = "HomeHeaderCell"
    let HomeFuncsCellID = "HomeFuncsCell"
    let HomeSchoolNewsCellID = "HomeSchoolNewsCell"
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        // 注册头部视图
        collectionView.register(HomeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID)
        
        collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: HomeHeaderCellID)
        collectionView.register(HomeFuncsCell.self, forCellWithReuseIdentifier: HomeFuncsCellID)
        collectionView.register(HomeSchoolNewsCell.self, forCellWithReuseIdentifier: HomeSchoolNewsCellID)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Config.removeUmeng()
//        Config.removeUserDefaults()
        configUI()
        configNav()
        configLocalData()
        configNetData()
        loadSetFrist()
    }
    

    func configUI(){
        view.backgroundColor = UIColor.init(r: 248, g: 248, b: 248)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    func configNav(){
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.title = "Hi. Huter~"
        self.navigation.bar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configLocalData(){
        let iconName = ["图书馆","二手市场","失物招领","查电费",
                        "空教室","成绩查询","考试查询","宣讲会"]
        let iconImg = ["ico_main_calendar","ico_main_calendar","ico_main_calendar","ico_main_calendar","ico_main_calendar","ico_main_calendar","ico_main_calendar","ico_main_calendar"]
        for i in 0..<8  {
            let model = HomeFuncsModel(iconName: iconName[i], iconImg: iconImg[i]);
            self.funcsData.append(model)
        }
    }
    
    func configNetData(){
        let name = ["nice","nice","nice","nice"]
        for i in 0..<4  {
            let model = HomeSchoolNewsModel(name: name[i]);
            self.schoolNewsData.append(model)
        }
    }
    // 首次登陆
    func loadSetFrist(){
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "kUsers") as? [AnyHashable : Any]
        if userData == nil {
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }

    }
    
}
// MARK: - collectionView代理
extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
   func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 3
   }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section==0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCellID, for: indexPath) as! HomeHeaderCell
            return cell
        }else if(indexPath.section==1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFuncsCellID, for: indexPath) as! HomeFuncsCell
            cell.data = self.funcsData
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSchoolNewsCellID, for: indexPath) as! HomeSchoolNewsCell
            cell.data = self.schoolNewsData
            cell.delegate = self
            return cell
        }
    }
    //item 的尺寸
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 2{
            return CGSize(width: screenWidth, height: 470.fit)
        }
        return CGSize(width: screenWidth, height: 200.fit)
     }
    
    // 头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID, for: indexPath) as? HomeHeaderReusableView else {
            return UICollectionReusableView()
        }
        return headerView 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
        return CGSize(width: 0, height: 0)
        }
        if section == 2 {
            return CGSize(width: screenWidth, height: 10.fit)
        }
        return CGSize(width: 0, height: 0)
    }
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 0.fit, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0.fit, left: 0, bottom: 0, right: 0)
    }
    
}

// MARK: 滑动协议
extension HomeViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 滑动放大
        
    }
}
