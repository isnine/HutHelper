//
//  MomentViewController+Action.swift
//  HutHelper
//
//  Created by 张驰 on 2020/4/1.
//  Copyright © 2020 nine. All rights reserved.
//

import Foundation


extension MomentViewController:MomentCellDelegate {
    func cellClickCallBack(with data: MomentModel, type: MomentCallBackType,indexPath:IndexPath) {
        switch type {
        case .Comment:
            self.comment.show(at: indexPath)
        case .MoreTips:
            moretips(indexPath: indexPath)
        case .UserImgClick:
            showUserCenter(with: data)
        case .Like:
            changeLikeStatu(with: data, indexPath: indexPath)
        case .delete:
            deleteMoment(indexPath: indexPath)
            
        case .Topic:
            break;
        case .fold:
            self.handlerFold(at: indexPath)
        case .contentFold:
            self.handlerContentFold(at: indexPath)
        }
    }
}
extension MomentViewController:CommentCellDelegate {
    func cellClickCallBack(with data: CommentModel, type: CommentCallBackType, indexPath: IndexPath) {
        print(data,type,indexPath)
        switch type {
        case .delete:
            self.viewModel.getDeleteCMomentRequst(commentId: data.id) {
                //self.tableView.dele
                self.viewModel.momentDatas[indexPath.section].comments.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()

            }
        case .username:
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "加载中"
            self.viewModel.getUserInfo(id: data.user_id) { (data) in
                //print(data)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                let vc = UserShowViewController()
                    vc.dep_name = data.dep_name
                    vc.name = data.username
                    vc.user_id = data.user_id
                    vc.head_pic = data.head_pic_thumb
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
        }

    }
    
    
}
// cell 点击代理 评论@
extension MomentViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = viewModel.momentDatas[indexPath.section].comments[indexPath.row]
        self.comment.show(at: indexPath, originStr: "@\(data.username)：", placeholderStr: "")
    }
    
}


// cell头部 方法
extension MomentViewController {
    
    func handlerContentFold(at indexPath:IndexPath){
        //viewModel.momentDatas[indexPath.section].isFold = !viewModel.momentDatas[indexPath.section].isFold
        viewModel.momentDatas[indexPath.section].conntentIsFold = !viewModel.momentDatas[indexPath.section].conntentIsFold
       // self.tableView.deleteRows(at: [indexPath], with: .automatic

        //self.tableView.reloadSections(at: [indexPath.section], with: .fade)
        self.tableView.reloadSections([indexPath.section], with: .fade)
        
        
    }
    
    func handlerFold(at indexPath:IndexPath){
        viewModel.momentDatas[indexPath.section].isFold = !viewModel.momentDatas[indexPath.section].isFold
        
       // self.tableView.deleteRows(at: [indexPath], with: .automatic

        self.tableView.reloadSections([indexPath.section], with: .fade)
        
        
    }
    
    func showUserCenter(with data:MomentModel){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "加载中"
        self.viewModel.getUserInfo(id: data.user_id) { (data) in
            //print(data)
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            let vc = UserShowViewController()
                vc.dep_name = data.dep_name
                vc.name = data.username
                vc.user_id = data.user_id
                vc.head_pic = data.head_pic_thumb
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func changeLikeStatu(with data:MomentModel,indexPath:IndexPath){
        let data = viewModel.momentDatas[indexPath.section]
        let header = tableView.headerView(forSection: indexPath.section) as? MomentSectionHeaderView
        if let headerView = header {
        
        viewModel.getLikeMomentRequst(momentId: data.id) {
            self.viewModel.momentDatas[indexPath.section].is_like = !self.viewModel.momentDatas[indexPath.section].is_like
            if data.is_like {
                headerView.likeBtn.setImage(UIImage(named: "tweet_btn_like"), for: .normal)
                headerView.likeBtn.setTitle("\(Int(data.likes)!-1)", for:.normal)
                self.viewModel.momentDatas[indexPath.section].likes = "\(Int(data.likes)!-1)"
                
            }else {
                headerView.likeBtn.setImage(UIImage(named: "tweet_btn_liked"), for: .normal)
                headerView.likeBtn.setTitle("\(Int(data.likes)!+1)", for:.normal)
                self.viewModel.momentDatas[indexPath.section].likes = "\(Int(data.likes)!+1)"
            }
        }
        }
        
    }
    
    func moretips(indexPath:IndexPath) {
         let data = viewModel.momentDatas[indexPath.section]
         let actionSheet = UIAlertController(title: "选择操作", message: "", preferredStyle: .actionSheet)
         let alterUserImg = UIAlertAction(title: "屏蔽", style: .default, handler: {(alters:UIAlertAction) -> Void in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            self.viewModel.getUnLikeMomentRequst(momentId: data.id) {
                hud.label.text = "屏蔽成功"
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
             }
            
             
         })
         let alterUserImgTake = UIAlertAction(title: "举报", style: .default, handler: {(alters:UIAlertAction) -> Void in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
//            let version =  Config.getCurrentVersion()
//            let content = "来源：\(user.username) \(user.dep_name) \(user.studentKH)\n版本：iOS \(version)\n说说id:\(data.id) \n说说内容:\(data.content)"
//            self.viewModel.PostHandRequst(email: "", content: content) { (json) in
//                hud.label.text = "举报成功"
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//            }
            sleep(UInt32(1))
            hud.label.text = "举报成功"
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
         })
        let concern = UIAlertAction(title: "关注", style: .destructive, handler: {(alters:UIAlertAction) -> Void in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            self.viewModel.getUnconcernMomentRequst(userId:data.user_id) {
                hud.label.text = "关注成功"
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
        })
         let cancel = UIAlertAction(title: "取消", style: .cancel, handler: {(alters:UIAlertAction) -> Void in print("取消更改头像")})
         
         actionSheet.addAction(cancel)
         actionSheet.addAction(concern)
         actionSheet.addAction(alterUserImg)
         actionSheet.addAction(alterUserImgTake)

        
         self.present(actionSheet,animated: true){
         }
    }
    
    func deleteMoment(indexPath:IndexPath) {
        let data = self.viewModel.momentDatas[indexPath.section]
        self.viewModel.getDeleteMomentRequst(momentId: data.id) {
            self.viewModel.momentDatas.remove(at: indexPath.section)
            self.tableView.deleteSections([indexPath.section], with: .automatic)
            self.tableView.reloadSections([indexPath.section], with: .fade)
            
        }
    }
}

