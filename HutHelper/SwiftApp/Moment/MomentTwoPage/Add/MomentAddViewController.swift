//
//  MomentAddViewController.swift
//  HutHelperSwift
//
//  Created by Cone on 2020/1/15.
//  Copyright © 2020 Cone. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import JXPhotoBrowser
import HandyJSON
import SwiftyJSON
//import ProgressHUD

class MomentAddViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    @IBOutlet weak var tagBtn1: UIButton!
    @IBOutlet weak var tagBtn2: UIButton!
    @IBOutlet weak var tagBtn3: UIButton!
    
    var controlBtn = 0
    
    var typeDatas = ["生活","运动","问答","游戏","情感"]
    
    // 图片数据
    var photoDatas = [UIImage]()
    var tags = [String]()
    // rx销毁
    let disposeBag = DisposeBag()
    // 左边返回
    private lazy var leftBarButton:UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x:-5, y:0, width:20, height: 30)
            btn.setImage(UIImage(named: "ico_menu_back"), for: .normal)
            btn.rx.tap.subscribe(onNext:{[weak self] in
            self?.navigationController?.popViewController(animated: true)
                }).disposed(by: disposeBag)
        return btn
    }()
    
    // 右边菜单
    private lazy var rightBarButton:UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x:5, y:0, width:20, height: 30)
            btn.setImage(UIImage(named: "ok"), for: .normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            let content = self!.textView.text
            // 处理标签
//            self!.tags = ["生活","问答"]//["问答","生活","学习","游戏","运动"];
            
            var type = ""
            if self!.tags.count == 0 {
                type = ""
            }else  {
                type = self!.tags[0]
            }
            let hud = MBProgressHUD.showAdded(to: self!.view, animated: true)
            hud.label.text = "发布中..."
            self!.viewModel.UploadImgs(images: self!.photoDatas) { (hidden) in
                print("hidden:",hidden!)
                self?.viewModel.PostHandRequst(content: content!, hidden: hidden!, type: type, callback: { (value) in
                    if value["code"] == 200 {
                         hud.label.text = "发布成功"
                         hud.hide(animated: true,afterDelay: 0.5)
                    self?.navigationController?.popToRootViewController(animated: true)
                     }else {
                         hud.label.text = "发布失败,请检查是否符合条件"
                         hud.hide(animated: true,afterDelay: 1)
                     }
                })
            }
            }).disposed(by: disposeBag)
        return btn
    }()
    
    lazy var viewModel: MomentAddViewModel = {
       let viewmodel = MomentAddViewModel()
        return viewmodel
    }()
    
    let tap = UITapGestureRecognizer()
    // 班级选择picker
    lazy var pickerView:UIPickerView = {
       let picker = UIPickerView(frame: CGRect(x: 0, y: screenHeight+50, width: screenWidth, height: screenHeight/3))
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: true)
        //picker.selectRow(0, inComponent: 1, animated: true)
        picker.backgroundColor = .white
        return picker
    }()
    // picker阴影背景
    lazy var backView:UIView = {
        let vi = UIView(frame: self.view.bounds)
        vi.backgroundColor = UIColor.init(r: 33, g: 33, b: 33)
        vi.alpha = 0.5
        vi.isHidden = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(hiddenPicker))
        vi.addGestureRecognizer(tap)
        return vi
    }()
    // 标签选择按钮
    lazy var selectBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: screenWidth/2, y: screenHeight, width: screenWidth/2, height: 50))
        btn.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        btn.setTitleColor(.cyan, for: .normal)
        btn.setTitle("确认",for:.normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            let row = self!.pickerView.selectedRow(inComponent: 0)
            let tag = self!.typeDatas[row]
            self!.tags.append(tag)
            self!.tagBtn1.setTitle("#"+self!.tags[0], for: .normal)
//            guard !self!.tags.contains(tag) else {
//                // 失败提示处理
//                self!.hiddenPicker()
//                //ProgressHUD.showError("标签存在,请重选")
//                return
//            }
            
//            if self!.controlBtn == 1{
//                if self!.tags.count == 0 {
//                    self!.tags.append(tag)
//                }else {
//                    self!.tags[0] = tag
//                }
//                self!.tagBtn1.setTitle("#"+self!.tags[0], for: .normal)
//                self!.tagBtn2.isHidden = false
//            }else if self!.controlBtn == 2{
//                if self!.tags.count == 1 {
//                    self!.tags.append(tag)
//                }else {
//                    self!.tags[1] = tag
//                }
//                self!.tagBtn2.setTitle("#"+self!.tags[1], for: .normal)
//                self!.tagBtn3.isHidden = false
//            }else if self!.controlBtn == 3{
//                if self!.tags.count == 2{
//                    self!.tags.append(tag)
//                }else {
//                    self!.tags[2] = tag
//                }
//                self!.tagBtn3.setTitle("#"+self!.tags[2], for: .normal)
//            }
            self!.hiddenPicker()
            }).disposed(by: disposeBag)
        return btn
    }()
    // 标签取消按钮
    lazy var typeCancelBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: screenHeight, width: screenWidth/2, height: 50))
        btn.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        btn.setTitleColor(.red, for: .normal)
        btn.setTitle("删除",for:.normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            let row = self!.pickerView.selectedRow(inComponent: 0)
            let tag =  self!.typeDatas[row]
            self!.tags.removeAll()
            self!.tagBtn1.setTitle("#添加标签", for: .normal)
//            if self!.controlBtn == 1{
//                if self!.tags.count == 3 {
//
//                    self!.tags.remove(at: 0)
//
//                    self!.tagBtn1.setTitle(self!.tags[0], for: .normal)
//                    self!.tagBtn2.setTitle(self!.tags[1], for: .normal)
//                    self!.tagBtn3.setTitle("#添加标签", for: .normal)
//                }else if self!.tags.count == 2 {
//                    self!.tags.remove(at: 0)
//
//                    self!.tagBtn1.setTitle(self!.tags[0], for: .normal)
//                    self!.tagBtn2.setTitle("#添加标签", for: .normal)
//                        self!.tagBtn3.isHidden = true
//                }else if self!.tags.count == 1{
//                    self!.tags.remove(at: 0)
//                    self!.tagBtn1.setTitle("#添加标签", for: .normal)
//                    self!.tagBtn2.isHidden = true
//                }
//            }else if self!.controlBtn == 2{
//                if self!.tags.count == 3 {
//
//                    self!.tags.remove(at: 1)
//
//                    self!.tagBtn1.setTitle(self!.tags[0], for: .normal)
//                    self!.tagBtn2.setTitle(self!.tags[1], for: .normal)
//                    self!.tagBtn3.setTitle("#添加标签", for: .normal)
//                }else if self!.tags.count == 2 {
//                    self!.tags.remove(at: 1)
//                    self!.tagBtn1.setTitle(self!.tags[0], for: .normal)
//                    self!.tagBtn2.setTitle("#添加标签", for: .normal)
//                        self!.tagBtn3.isHidden = true
//                }
//            }else if self!.controlBtn == 3{
//                if self!.tags.count == 3{
//                    self!.tags.remove(at: 1)
//                    self!.tagBtn3.setTitle("#添加标签", for: .normal)
//                }
//            }
            self!.hiddenPicker()
            }).disposed(by: disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configImgCollection()
        rxMethod()
    }

    func configUI(){
        //self.view.backgroundColor = UIColor.init(r: 234, g: 235, b: 236)
        self.navigation.item.title = "发布说说"
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.leftBarButtonItem =  UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        textView.delegate = self
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        self.view.addSubview(self.backView)
        self.view.addSubview(self.pickerView)
        self.view.addSubview(selectBtn)
        self.view.addSubview(typeCancelBtn)
        self.tagBtn2.isHidden = true
        self.tagBtn3.isHidden = true
        
    }
    
    @objc func hiddenPicker(){
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 0.5
            //self.backView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.pickerView.frame = CGRect(x: 0, y: screenHeight+50, width: screenWidth, height: screenHeight/3)
            self.selectBtn.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 50)
            self.typeCancelBtn.frame = CGRect(x: 0, y: screenHeight, width: screenWidth/2, height: 50)
        }) { (isSuccess) in
            self.backView.isHidden = true
        }
    }
    
    func showPicker(){
        self.backView.isHidden = false
        //self.backView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 0.5
            //self.backView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.pickerView.frame = CGRect(x: 0, y: 2*screenHeight/3, width: screenWidth, height: screenHeight/3)
            self.selectBtn.frame = CGRect(x: screenWidth/2, y: 2*screenHeight/3-50, width: screenWidth/2, height: 50)
            self.typeCancelBtn.frame = CGRect(x: 0, y: 2*screenHeight/3-50, width: screenWidth/2, height: 50)
        }) { (isSuccess) in
        }
        self.pickerView.reloadAllComponents()
    }
    
    func rxMethod() {
        addPhotoBtn.rx.tap.subscribe(onNext:{[weak self] in
            
            _ = self!.presentHGImagePicker(maxSelected: 9 - self!.photoDatas.count, completeHandler: { (assets) in
                for asset in assets {
                    let img = SKPHAssetToImageTool.PHAssetToImage(asset: asset)
                    self!.photoDatas.append(img)
                }
                self!.imgCollectionView.reloadData()
            })
            
            }).disposed(by: disposeBag)
        
        //键盘收起
        tap.rx.event.subscribe { (event) in
            print("点击了view并收起键盘")
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        tagBtn1.rx.tap.subscribe(onNext:{[weak self] in
            self!.controlBtn = 1
            self!.showPicker()
            
            }).disposed(by: disposeBag)
        tagBtn2.rx.tap.subscribe(onNext:{[weak self] in
            self!.showPicker()
            self!.controlBtn = 2
            }).disposed(by: disposeBag)
        tagBtn3.rx.tap.subscribe(onNext:{[weak self] in
            self!.showPicker()
            self!.controlBtn = 3
            }).disposed(by: disposeBag)
    }

}
extension MomentAddViewController: UITextViewDelegate,UIGestureRecognizerDelegate {
    func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
        if (content.text == "请输入要发表的内容~") {
            content.text = ""
        }
        return true
    }
    
    // 手势冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.imgCollectionView))!{
            return false
        }
        return true
    }


}

extension MomentAddViewController{
    func configImgCollection(){
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 7.fit
        layout.itemSize = CGSize(width: 120.fit, height:120.fit)
        layout.scrollDirection = .vertical
        
        self.imgCollectionView.collectionViewLayout = layout
        imgCollectionView.register(ImgsViewCell.self, forCellWithReuseIdentifier: "ImgsViewCell")
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
        imgCollectionView.backgroundColor = .clear
        imgCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension MomentAddViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgsViewCell", for: indexPath) as! ImgsViewCell
        cell.imageView.image = photoDatas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
            self.removePhoto(at: indexPath.row)

    }
    func removePhoto(at index:Int) {
        let alert = UIAlertController.init(title: "确定要移除这张图片吗？", message: "请选择", preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "确定", style: .default) { (yes) in
                self.photoDatas.remove(at: index)
                self.imgCollectionView.reloadData()
        }
        let noAction = UIAlertAction.init(title: "取消", style: .default) { (no) in }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    func showMessge(messge:String) {
        let alert = UIAlertController.init(title: "警告！", message: messge, preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "确定", style: .default) { (yes) in
        }
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MomentAddViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int) {
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 14)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = typeDatas[row]
        return pickerLabel!
    }
}
