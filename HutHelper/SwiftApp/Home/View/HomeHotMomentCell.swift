//
//  HomeHotMomentCell.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/26.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit

class HomeHotMomentCell: UICollectionViewCell {
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    private var moreBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("更多 ＞", for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    // MARK:
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10.fit
        layout.itemSize = CGSize(width:(screenWidth-40.fit)/2, height:200.fit)
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(NewCell.self, forCellWithReuseIdentifier: "NewCell")
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        addSubview(titleLabel)
        titleLabel.text = "校园新闻"
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10.fit)
            make.left.equalTo(self).offset(10.fit)
            make.height.equalTo(40.fit)
        }
        addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20.fit)
            make.right.equalTo(self).offset(-10.fit)
            make.height.equalTo(30.fit)
        }
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(10.fit)
            make.right.equalTo(self).offset(-10.fit)
            make.height.equalTo(410.fit)
        }
    }
}
extension HomeHotMomentCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewCell", for: indexPath) as! NewCell
        cell.backgroundColor = .cyan
        return cell
    }
    

}
