////
////  LeftViewController.swift
////  HutHelperSwift
////
////  Created by 张驰 on 2020/1/11.
////  Copyright © 2020 张驰. All rights reserved.
////
//
//import UIKit
//import Kingfisher
//
//class LeftViewController: UIViewController {
//
//    lazy var tableView:UITableView = {
//        let tableview = UITableView(frame: self.view.bounds)
//        tableview.tag = 2001
//        tableview.separatorStyle = .none
//        tableview.delegate = self
//        tableview.dataSource = self
//        tableview.backgroundColor = UIColor.clear
//        tableview.register(UINib(nibName: "LeftHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftHeadCell")
//        tableview.register(UINib(nibName: "LeftBodyTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftBodyCell")
//        return tableview
//    }()
//
//    lazy var imageView:UIImageView = {
//        let image = UIImageView(frame: self.view.bounds)
//        image.image = UIImage(named: "leftbackiamge")
//        return image
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configUI()
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }
//
//    func configUI(){
//        self.view.backgroundColor = .white
//        self.view.addSubview(imageView)
//        self.view.addSubview(tableView)
//        self.navigation.bar.isShadowHidden = true
//        self.navigation.bar.alpha = 0
//    }
//
//}
//
//extension LeftViewController:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        8
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            if indexPath.row == 0 {
//                 let userCell = tableView.dequeueReusableCell(withIdentifier: "LeftHeadCell", for: indexPath) as! LeftHeadTableViewCell
//                 if user.TrueName != "" {
//                     userCell.headName.text = user.TrueName
//                }else {
//                     userCell.headName.text = "个人中心"
//                 }
//                let imgUrl = URL(string: imageUrl+user.head_pic_thumb )
//                userCell.headImg.kf.setImage(with: imgUrl)
//                 userCell.backgroundColor = UIColor.clear
//                 return userCell
//             }
//             else if indexPath.row == 2 {
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "LeftBodyCell", for: indexPath) as! LeftBodyTableViewCell
//                cell.updateUI(icon: "ico_left_shares", label: "分享应用")
//                 return cell
//             }else if indexPath.row == 3 {
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "LeftBodyCell", for: indexPath) as! LeftBodyTableViewCell
//                cell.updateUI(icon: "ico_left_sign-out", label: "切换用户")
//                 return cell
//             }
//             else if indexPath.row == 4 {
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "LeftBodyCell", for: indexPath) as! LeftBodyTableViewCell
//                cell.updateUI(icon: "ico_left_about", label: "关于")
//                 return cell
//             }
//             else if indexPath.row == 5{
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "LeftBodyCell", for: indexPath) as! LeftBodyTableViewCell
//                cell.updateUI(icon: "ico_left_feedback", label: "反馈")
//                 return cell
//             }
//            else if indexPath.row == 6{
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "LeftBodyCell", for: indexPath) as! LeftBodyTableViewCell
//                cell.updateUI(icon: "ico_left_im", label: "私信")
//                 return cell
//             }
//             else {
//                 let cell = tableView.dequeueReusableCell(withIdentifier: "LeftBodyCell", for: indexPath) as! LeftBodyTableViewCell
//                 cell.backgroundColor = UIColor.clear
//                 return cell
//             }
//
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 150.fit
//        }
//        return 45.fit
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        switch indexPath.row {
//        case 0: // 个人中心
//            let userVC = UserController()
//        appDelegate.mainNavigationController!.pushViewController(userVC, animated: true)
//        case 2: // 分享
//            let text = "工大助手-属于你我的校园助手\n软件商店搜索工大助手即可下载哦~"
//            let img = UIImage(named: "shared")
//            let ac = UIActivityViewController(activityItems: [text,img as Any], applicationActivities: nil)
//            self.present(ac,animated: true)
//        case 3:
//            let alert = UIAlertController(title: "切换用户", message: "是否要退出当前账号", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { action in
//            }))
//            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
//                Single.shared.logOutApp()
//            }))
//            present(alert, animated: true)
//        case 4: // 关于
//                let userVC = AboutViewController()
//                appDelegate.mainNavigationController!.pushViewController(userVC, animated: true)
//        case 5: //反馈
//            let alert = UIAlertController(title: "反馈问题", message: "哪个类型的问题", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "App卡顿/卡死等问题", style: .default, handler: { action in
//            if let url = URL(string: "15274737502") {
//                ////UIApplication.shared.openURL(url)
//                UIApplication.shared.canOpenURL(url)
//                }
//            }))
//            alert.addAction(UIAlertAction(title: "课表/成绩等数据问题", style: .default, handler: nil))
//            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { action in
//            }))
//            present(alert, animated: true)
//        case 6:
//            let webVC = BaseWebViewController(webURL: "www.baidu.com", navTitle: "私信")
//            appDelegate.mainNavigationController?.pushViewController(webVC, animated: true)
//        default:
//            break;
//        }
//    }
////    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let vi = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 128))
////        vi.backgroundColor = .clear
////        return vi
////    }
//}
