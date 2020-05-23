//
//  MomentsSearchViewController.swift
//  HutHelper
//
//  Created by 张驰 on 2019/11/18.
//  Copyright © 2019 nine. All rights reserved.
//

import UIKit
import TagListView
import SwiftMessages

class MomentsSearchViewController: BaseNarViewController {

    @IBAction func deleteAllTgsBtn(_ sender: UIButton) {

        for tag in tagView.tagViews {
            if let ta = tag.titleLabel?.text {
                if DataBase.shared.deleteNotesById(id: ta) {

                }
            }
        }
        self.tagView.removeAllTags()
        print("删除成功")
    }

    @IBOutlet weak var tagView: TagListView!

    lazy var search: UISearchBar = {
           let search = UISearchBar()
           // search.backgroundColor = .red
            search.placeholder = "找到你想要了解的内容~"
            search.delegate = self
            return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
            configNav()
            configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        tagView.removeAllTags()
        configTags()
    }

    func configNav() {
        self.navigation.item.titleView = search
        self.navigation.bar.isShadowHidden = true
    }
    func configTags() {
        tagView.delegate = self
        let items = DataBase.shared.queryNotesByTime()
        for item in items {
            tagView.addTag(item).onTap = { [weak self] tagView in
                    //self?.tagView.removeTagView(tagView)
            }
        }
    }
    func configUI() {
            self.view.backgroundColor = .white
            let dismissKetboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            self.view.addGestureRecognizer(dismissKetboardTap)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationController?.navigationBar.tintColor = UIColor(red: 29 / 255.0, green: 203 / 255.0, blue: 219 / 255.0, alpha: 1)

    }
    @objc func dismissKeyboard() {
            print("键盘成功关闭")
            self.view.endEditing(false)
    }

}

/// MRAK - 输入监听
extension MomentsSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchContent = searchBar.text!
        print(searchContent)
        let string = searchContent.components(separatedBy: " ")
        let str = string.joined(separator: "")
        print(str)
        if str != "" {
            _ = DataBase.shared.insertNotes(with: searchContent)
            let vc = MomentViewController(type: .custom(str))
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
            warning.configureContent(title: "错误提示❎", body: "输入的内容为空", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
    }

}

extension MomentsSearchViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {

        tagView.isSelected = !tagView.isSelected
        let vc = MomentViewController(type: .custom(title))
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {

        //print("1111Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        if DataBase.shared.deleteNotesById(id: title) {
                print("删除成功")
        }
    }
}
