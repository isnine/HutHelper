//
//  HomeHeaderCell.swift
//  HutHelper
//
//  Created by 张驰 on 2020/3/26.
//  Copyright © 2020 nine. All rights reserved.
//

import UIKit
import FSPagerView

class HomeHeaderCell: UICollectionViewCell {
    
    var imgsData = [String]()
    
    // MARK: - 轮播图浏览器
    private lazy var pagerView : FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.automaticSlidingInterval =  3
        pagerView.isInfinite = true
        pagerView.interitemSpacing = 15
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.itemSize = CGSize(width: screenWidth, height: topBarHeight+200.fit )
        
        return pagerView
    }()
    
    // MARK: - 标记点
    private lazy var pageControl: FSPageControl = {
       let pageControl = FSPageControl()
        pageControl.numberOfPages = 3;
        pageControl.contentHorizontalAlignment = .center
        pageControl.setStrokeColor(.none, for: .normal)
        pageControl.setStrokeColor(.white, for: .selected)
        pageControl.setFillColor(.none, for: .normal)
        pageControl.setFillColor(.white, for: .selected)
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.addSubview(self.pagerView)
        self.pagerView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(-topBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(topBarHeight+200.fit)
        }
        self.addSubview(pageControl)
        self.pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(20)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
extension HomeHeaderCell: FSPagerViewDelegate, FSPagerViewDataSource {
    // MARK:- FSPagerView Delegate
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3 //self.focus?.data?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: "Main")
        //cell.imageView?.kf.setImage(with: URL(string:(self.focus?.data?[index].cover)!))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        //let url:String = self.focus?.data?[index].link ?? ""
        //delegate?.recommendHeaderBannerClick(url: url)
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}
