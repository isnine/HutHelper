//
//  UserController.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/12.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class UserController: UIViewController {
    var classesData: [String:Any]?
    var classesDatas = [ClassModel]()
    let disposeBag = DisposeBag()
    var imgPricker:UIImagePickerController!
    
    var classSelect = ClassModel()
    
    // viewModel层
    lazy var viewModel:UseInfoViewModel = {
        let viewmodel = UseInfoViewModel()
        return viewmodel
    }()
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
    // 主体tableView
    lazy var tableView:UITableView = {
        let tableview = UITableView(frame: self.view.bounds)
        tableview.tag = 2001
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        tableview.register(UINib(nibName: "UseInfoCell", bundle: nil), forCellReuseIdentifier: "UseInfoCell")
        tableview.register(UseHeadCell.self, forCellReuseIdentifier: "UseHeadCell")
        return tableview
    }()
    // 班级选择picker
    lazy var pickerView:UIPickerView = {
       let picker = UIPickerView(frame: CGRect(x: 0, y: screenHeight+50, width: screenWidth, height: screenHeight/3))
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: true)
        picker.selectRow(0, inComponent: 1, animated: true)
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
    //班级选择按钮
    lazy var selectBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 50))
        btn.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        btn.setTitleColor(.cyan, for: .normal)
        btn.setTitle("确认班级选择",for:.normal)
        btn.rx.tap.subscribe(onNext:{[weak self] in
            let component = self!.pickerView.selectedRow(inComponent: 0)
            let row = self!.pickerView.selectedRow(inComponent: 1)
            let className = self!.viewModel.classesDatas[component].classes[row]
            let depName = self!.viewModel.classesDatas[component].depName
            self?.viewModel.alterUseInfo(type: .classes(className), callback: { (isSuccess) in
                guard isSuccess else {return}
                changeUserInfo(name: "dep_name", value: depName)
                 changeUserInfo(name: "class_name", value: className)
                self!.hiddenPicker()
                self!.tableView.reloadData()
            })
            }).disposed(by: disposeBag)
        return btn
    }()
    @objc func hiddenPicker(){
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 0.5
            //self.backView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.pickerView.frame = CGRect(x: 0, y: screenHeight+50, width: screenWidth, height: screenHeight/3)
            self.selectBtn.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 50)
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
            self.selectBtn.frame = CGRect(x: 0, y: 2*screenHeight/3-50, width: screenWidth, height: 50)
        }) { (isSuccess) in
        }
        self.pickerView.reloadAllComponents()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
            
    }
    

    func configUI(){
        self.view.backgroundColor = .white
        self.navigation.item.title = "个人信息"
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 1
        self.view.addSubview(tableView)
        self.view.addSubview(self.backView)
        self.view.addSubview(self.pickerView)
        self.view.addSubview(selectBtn)
    }
    
        
    func getUseHeadImg(){
        print("头像更换")
         let actionSheet = UIAlertController(title: "更改头像", message: "请选择图像来源", preferredStyle: .actionSheet)
         let alterUserImg = UIAlertAction(title: "相册选择", style: .default, handler: {(alters:UIAlertAction) -> Void in
             print("拍照继续更改头像中..")
             
             self.imgPricker = UIImagePickerController()
             self.imgPricker.delegate = self
             self.imgPricker.allowsEditing = true
             self.imgPricker.sourceType = .photoLibrary
             
             self.imgPricker.navigationBar.barTintColor = UIColor.gray
             self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
             
             self.imgPricker.navigationBar.tintColor = UIColor.white
             
             self.present(self.imgPricker, animated: true, completion: nil)
             
         })
         
         let alterUserImgTake = UIAlertAction(title: "拍照选择", style: .default, handler: {(alters:UIAlertAction) -> Void in
             print("继续更改头像中..")
             if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                 self.imgPricker = UIImagePickerController()
                 self.imgPricker.delegate = self
                 self.imgPricker.allowsEditing = true
                 self.imgPricker.sourceType = .camera
                 self.imgPricker.cameraDevice = UIImagePickerController.CameraDevice.rear
                 self.imgPricker.showsCameraControls = true
                 
                 self.imgPricker.navigationBar.barTintColor = UIColor.gray
                 self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                 
                 self.imgPricker.navigationBar.tintColor = UIColor.white
                 
                 self.present(self.imgPricker, animated: true, completion: nil)
             }
         })
         let cancel = UIAlertAction(title: "取消", style: .cancel, handler: {(alters:UIAlertAction) -> Void in print("取消更改头像")})
         
         actionSheet.addAction(cancel)
         actionSheet.addAction(alterUserImg)
         actionSheet.addAction(alterUserImgTake)
         
         self.present(actionSheet,animated: true){
             print("正在更改")
         }
    }

}

extension UserController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellHead = tableView.dequeueReusableCell(withIdentifier: "UseHeadCell", for: indexPath) as! UseHeadCell
            cellHead.updateUI(imageUrl: imageUrl+user.head_pic_thumb)
            return cellHead
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UseInfoCell", for: indexPath) as! UseInfoCell
        switch indexPath.section {
        case 1:
            cell.updateUI(headlab: "昵称", infolab: user.username)
        case 2:
            cell.updateUI(headlab: "签名", infolab: user.bio)
        case 3:
            cell.updateUI(headlab: "密码", infolab: "点击修改")
        case 4:
            cell.updateUI(headlab: "学院", infolab: user.dep_name)
        case 5:
            cell.updateUI(headlab: "班级", infolab: user.class_name)
        case 6:
            cell.updateUI(headlab: "QQ", infolab: "通过QQ联系他人")
        case 7:
            cell.updateUI(headlab: "姓名", infolab: user.TrueName)
        case 8:
            cell.updateUI(headlab: "性别", infolab: user.active)
        case 9:
            cell.updateUI(headlab: "学号", infolab: user.studentKH)
        default:
            break;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65.fit
        }
        return 45.fit
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        // [tempAppDelegate.LeftSlideVC closeLeftView];
        

//        let leftVC = UIApplication.shared.windows[0].rootViewController as! LeftSlideViewController
//        leftVC.closeLeftView()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        switch indexPath.section {
        case 0:
            self.getUseHeadImg()
        case 1:
            self.alterMethod(name: "修改昵称") { (value) in
                let cell = tableView.cellForRow(at: indexPath) as! UseInfoCell
                self.viewModel.alterUseInfo(type: .username(value)) { (isSuccess) in
                    guard isSuccess else { return }
                    cell.infoLab.text = value
                    changeUserInfo(name: "username", value: value)
                }
            }
        case 2:
            self.alterMethod(name: "修改签名") { (value) in
                let cell = tableView.cellForRow(at: indexPath) as! UseInfoCell
                self.viewModel.alterUseInfo(type: .bio(value)) { (isSuccess) in
                    guard isSuccess else { return }
                    cell.infoLab.text = value
                    changeUserInfo(name: "bio", value: value)
                }
            }
        case 3:
            print("改密码请联系管理员")
        case 4:
            guard viewModel.classesDatas.isEmpty else {
                self.showPicker();return  }
            viewModel.getAllClassesRequst { self.showPicker() }
        case 5 :
            guard viewModel.classesDatas.isEmpty else {
                self.showPicker();return  }
            viewModel.getAllClassesRequst { self.showPicker() }
        case 6:
            print("qq还不能")
        default:
            break;
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
        vi.backgroundColor = UIColor.init(r: 223, g: 223, b: 223)
        return vi
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 || section == 7 {
            return 10
        }
        return 1
    }

}

extension UserController{
    
    func alterMethod(name:String,  callback: @escaping(_ result:String) -> ()){
        let alert = UIAlertController.init(title: name, message: "请输入", preferredStyle: .alert)
            
                let yesAction = UIAlertAction.init(title: "确定", style: .default) { (yes) in
                    callback((alert.textFields?.first?.text!)!)
                }
                let noAction = UIAlertAction.init(title: "取消", style: .default) { (no) in
                    print("取消",no.style)
                }
                alert.addAction(noAction)
                alert.addAction(yesAction)

                alert.addTextField { (text) in
                }
            
                self.present(alert, animated: true, completion: nil)
    }
}

extension UserController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if viewModel.classesDatas.isEmpty {
            return 0
        }else {
            if component == 0 {
                return viewModel.classesDatas.count
            }
            let row = pickerView.selectedRow(inComponent: 0)
            let classCurrnt = viewModel.classesDatas[row]
            self.classSelect = classCurrnt
            return classCurrnt.classes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if component == 0 {
            return viewModel.classesDatas[row].depName
        }
        let pRow = pickerView.selectedRow(inComponent: 0)
        
        return viewModel.classesDatas[pRow].classes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        if component == 0 {
            self.pickerView.reloadComponent(1)
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 14)
            pickerLabel?.textAlignment = .center
        }
        if component == 0 {
            pickerLabel?.text = viewModel.classesDatas[row].depName
        }else {
            pickerLabel?.text = classSelect.classes[row]
        }
        return pickerLabel!
    }
}
extension UserController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let HelperHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
         HelperHUD.label.text = "上传中"
        viewModel.alterUseHeadImg(image: img) { (result) in
            guard let value = result else { return }
            changeUserInfo(name: "head_pic_thumb", value: value)
            self.tableView.reloadData()
            HelperHUD.hide(animated: true)
        }
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
