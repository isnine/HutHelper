//
//  HomeFuncCell.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/26.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit

protocol HomeFuncsCellDelegate:NSObjectProtocol {
    func cellItemClick(with data:HomeFuncsModel)
}

class HomeFuncsCell: UICollectionViewCell {
    
    // 代理回调
    weak var delegate : HomeFuncsCellDelegate?
    
    var cellData = [HomeFuncsModel]()
    
    // MARK: - 懒加载九宫格分类按钮
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10.fit
        layout.itemSize = CGSize(width:(screenWidth-40.fit)/4, height:90.fit)
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(FuncCell.self, forCellWithReuseIdentifier: "FuncCell")
        
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
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(10.fit)
            make.right.equalTo(self).offset(-10.fit)
            make.height.equalTo(200.fit)
        }
    }
    
    var data:[HomeFuncsModel]?{
        didSet{
            guard let data = data else { return }
            self.cellData = data
            self.collectionView.reloadData()
        }
    }
}

extension HomeFuncsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FuncCell", for: indexPath) as! FuncCell
        
        cell.updateUI(with: cellData[indexPath.row])
        cell.backgroundColor = .cyan;
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.cellItemClick(with: cellData[indexPath.row])
    }
    

}
