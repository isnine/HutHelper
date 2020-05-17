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
        default:
            break;
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
                print(data)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                let vc = UserShowViewController()
                    vc.dep_name = data.dep_name
                    vc.name = data.username
                    vc.user_id = data.user_id
                    vc.head_pic = data.head_pic_thumb
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break;
        }

    }
    
    
}
// cell 点击代理 评论@
extension MomentViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let data = viewModel.momentDatas[indexPath.section].comments[indexPath.row]
        self.comment.show(at: indexPath, originStr: "@\(data.username)", placeholderStr: "")
    }
    
}
// cell头部 方法
extension MomentViewController {
    
    
    func showUserCenter(with data:MomentModel){
        let vc = UserShowViewController()
            vc.dep_name = data.dep_name
            vc.name = data.username
            vc.user_id = data.user_id
            vc.head_pic = data.head_pic_thumb
        self.navigationController?.pushViewController(vc, animated: true)
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
         let actionSheet = UIAlertController(title: "选择操作", message: "", preferredStyle: .actionSheet)
         let alterUserImg = UIAlertAction(title: "屏蔽", style: .default, handler: {(alters:UIAlertAction) -> Void in
             print("举报")
            
             
         })
         let alterUserImgTake = UIAlertAction(title: "举报", style: .default, handler: {(alters:UIAlertAction) -> Void in
             print("举报")
         })
        let concern = UIAlertAction(title: "关注", style: .destructive, handler: {(alters:UIAlertAction) -> Void in
            print("举报")
        })
         let cancel = UIAlertAction(title: "取消", style: .cancel, handler: {(alters:UIAlertAction) -> Void in print("取消更改头像")})
         
         actionSheet.addAction(cancel)
         actionSheet.addAction(alterUserImg)
         actionSheet.addAction(concern)
         actionSheet.addAction(alterUserImgTake)
         
         self.present(actionSheet,animated: true){
             print("正在更改")
         }
    }
    
    func deleteMoment(indexPath:IndexPath) {
        let data = self.viewModel.momentDatas[indexPath.section]
        self.viewModel.getDeleteMomentRequst(momentId: data.id) {
            self.viewModel.momentDatas.remove(at: indexPath.section)
            self.tableView.deleteSections([indexPath.section], with: .automatic)
            self.tableView.reloadData()
            
        }
    }
}

