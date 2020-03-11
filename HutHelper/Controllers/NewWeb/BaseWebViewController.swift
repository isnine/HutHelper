//
//  BaseWebViewController.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/11.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

class BaseWebController: UIViewController{
    var webURL = ""
    var navTitle = ""
    
    // 左边返回
    private lazy var leftBarButton:UIButton = {
        let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x:-5, y:0, width:20, height: 30)
            btn.setImage(UIImage(named: "ico_menu_back"), for: .normal)
            btn.rx.tap.subscribe(onNext:{[weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        return btn
    }()
    
    convenience init(webURL:String,navTitle:String){
        self.init()
        self.webURL = webURL
        self.navTitle = navTitle
    }
    //web页面
    lazy private var webview: WKWebView = {
        self.webview = WKWebView.init(frame: self.view.bounds)
        self.webview.uiDelegate = self
        self.webview.navigationDelegate = self
        return self.webview
    }()
    // 进度条
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(65), width: UIScreen.main.bounds.width, height: 10))
        self.progressView.tintColor = UIColor.green      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        return self.progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configWeb()
    }
    func configWeb(){
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webview.load(URLRequest.init(url: URL.init(string: webURL)!))
    }
    func configUI(){
        view.addSubview(webview)
        self.navigation.item.title = navTitle
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.isShadowHidden = true
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            
            if keyPath == "estimatedProgress"{
                progressView.alpha = 1.0
                
                DispatchQueue.main.async {
                    print(self.webview.estimatedProgress)
                    self.progressView.setProgress(Float(self.webview.estimatedProgress), animated: true)
                }

                print(webview.estimatedProgress)
                if webview.estimatedProgress >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                        self.progressView.alpha = 0
                    }, completion: { (finish) in
                        self.progressView.setProgress(0.0, animated: false)
                    })
                }
            }
    }
    deinit {
            webview.removeObserver(self, forKeyPath: "estimatedProgress")
            webview.uiDelegate = nil
            webview.navigationDelegate = nil
    }

}

extension BaseWebController:WKUIDelegate,WKNavigationDelegate  {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "加载中"
    }
        
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("开始获取网页内容")
    }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
        
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("加载失败")
    }
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow);
    }
}
