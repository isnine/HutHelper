//
//  MainViewController.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/11.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var courseBtn: UIButton!
    @IBOutlet weak var handBtn: UIButton!
    @IBOutlet weak var powerBtn: UIButton!
    @IBOutlet weak var calenderBtn: UIButton!
    @IBOutlet weak var lostBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var momentBtn: UIButton!
    @IBOutlet weak var exam: UIButton!
    @IBOutlet weak var emptyRoomBtn: UIButton!

    @IBOutlet weak var noticeBtn: UIButton!

    @IBOutlet weak var noticeTitleLab: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!

    //@IBOutlet weak var lineUIView: LineUIView!

    let disposeBag = DisposeBag()
    // banner 照片选取
    var imgPricker: UIImagePickerController!
    // 左边菜单按钮
    private lazy var leftBarButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: -5, y: 0, width: 20, height: 30)
        btn.setImage(UIImage(named: "menu"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] in
            let leftVC = UIApplication.shared.windows[0].rootViewController as! LeftSlideViewController
            guard leftVC.closed else {
                leftVC.closeLeftView()
                return
            }
            leftVC.openLeftView()
            self!.navigation.item.leftBarButtonItem?.badgeValue = ""
        }).disposed(by: disposeBag)
        return btn
    }()
    // 右边更多按钮
    private lazy var rightBarButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 5, y: 0, width: 20, height: 30)
        btn.setImage(UIImage(named: "ico_menu_more"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] in
            let moreVC = MoreViewController()
            self?.navigationController?.pushViewController(moreVC, animated: true)
        }).disposed(by: disposeBag)
        return btn
    }()

    // viewModel
    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configBanner()
        loadSetFrist()
        getHomePageData()
        rxMethod()
        Config.addNotice()
        Config.saveUmeng()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let leftVC = UIApplication.shared.windows[0].rootViewController as! LeftSlideViewController
        leftVC.closeLeftView()
        leftVC.setPanEnabled(false)
        UIApplication.shared.statusBarStyle = .default

    }
    override func viewWillAppear(_ animated: Bool) {
        let leftVC = UIApplication.shared.windows[0].rootViewController as! LeftSlideViewController
        leftVC.setPanEnabled(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func configUI() {
        self.view.backgroundColor = UIColor.init(r: 235, g: 235, b: 235)
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.leftBarButtonItem =  UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
    }
    func configBanner() {
        let date = Date()
        let num = getNumWeek(nowYear: date.years(), nowMouth: date.months(), nowDay: date.days())
        let week = date.getWeekDay()
        self.timeLab.text = "第\(num)周 \(week)"

        Config.saveNowWeek(Math.getWeek())
        let lineView = LineUIView(frame: CGRect(x: 50.fit, y: Int(AdaptX(220.5)), width: 334.fit, height: 30.fit))
        lineView.backgroundColor = .clear
        self.view.addSubview(lineView)

        // 加载本地bg
        if Config.getBanner() != nil {
            let img = UIImage(data: Config.getBanner())
            bannerImg.image = img
        }
        // 添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(bannerTap))
        tap.numberOfTapsRequired = 1
        bannerImg.addGestureRecognizer(tap)
        // 通知
        noticeTitleLab.text = "私信红点通知"
        noticeLabel.text = "左上角私信提醒...."
    }

    @objc func bannerTap() {
        self.getUseHeadImg()
    }

    // 首次登陆
    func loadSetFrist() {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "kUsers") as? [AnyHashable: Any]
        if userData == nil {
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }

    }

    func getHomePageData() {
        viewModel.getCalender {
            self.drawCalendar()
        }
        viewModel.getVersionIOS { (value) in
            let data = getVersioniOS()
            print(data)
            if let old = Int(data.im_msg_count),
                let new = Int(value["im_msg_count"].string!) {
                print(old, new)
                if old < new {
                    self.navigation.item.leftBarButtonItem?.badgeValue = " "
                    self.navigation.item.leftBarButtonItem?.badgeOriginY = 0.fit
                } else {
                    self.navigation.item.leftBarButtonItem?.badgeValue = ""
                }
            }
            saveVersioniOS(value.dictionaryObject)

        }
    }

    // 状态栏
    func configStatu() {

    }

}

// - MARK: RxMethod
extension MainViewController {
    func rxMethod() {
        // 图书馆
        libraryBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                let webVC = BaseWebController(webURL: getLibraryAPI, navTitle: "图书馆（需连接校园WIFI）")
                self?.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 电费查询
        powerBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.pushController(with: "Power")
            })
            .disposed(by: disposeBag)
        // 二手市场
        handBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                let handVC = HandTableViewController()
                self?.navigationController?.pushViewController(handVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 说说
        momentBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                let momentVC = MomentViewController(type: .all)
                self?.navigationController?.pushViewController(momentVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 失物招领
        lostBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                let lostVC = LostViewController()
                self?.navigationController?.pushViewController(lostVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 课程表
        courseBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard Config.getCourse() == nil else {
                    Config.setIs(0)
                    self?.pushController(with: "Class")
                    return
                }
                Config.getClass()

            })
            .disposed(by: disposeBag)
        // 空教室
        emptyRoomBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let webVC = BaseWebController(webURL: getEmptyRoomAPI, navTitle: "空教室")
                self?.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 考试查询
        exam.rx.tap
            .subscribe(onNext: { [weak self] in
                let webVC = BaseWebController(webURL: getExamAPI, navTitle: "考试计划")
                self?.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 成绩查询
        scoreBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let webVC = BaseWebController(webURL: getScoreAPI, navTitle: "成绩查询")
                self?.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 校历
        calenderBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let dayVC = DayViewController()
                self?.navigationController?.pushViewController(dayVC, animated: true)
            })
            .disposed(by: disposeBag)
        // 通知
        noticeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pushController(with: "Notice")
            })
            .disposed(by: disposeBag)
    }
}

// - MARK: 界面绘制
extension MainViewController {
    /**倒计时绘制*/
    func drawCalendar() {
        let num = viewModel.calendarData.count
        var pointX = 70
        for index in 0..<num {
            let dateLab = UILabel(frame: CGRect(x: (pointX-30).fit, y: Int(AdaptX(210)), width: 90.fit, height: 20.fit))
            dateLab.textColor = .white
            dateLab.font = UIFont.systemFont(ofSize: 12)
            dateLab.textAlignment = .center

            let pointView = PointView(frame: CGRect(x: pointX.fit, y: Int(AdaptX(226)), width: 30.fit, height: 30.fit))

            let daysLab = UILabel(frame: CGRect(x: (pointX-30).fit, y: Int(AdaptX(243)), width: 90.fit, height: 20.fit))

            daysLab.textColor = .white
            daysLab.font = UIFont.systemFont(ofSize: 12)
            daysLab.textAlignment = .center

            dateLab.text = viewModel.calendarData[index].date
            daysLab.text = "\(viewModel.calendarData[index].name) \(viewModel.calendarData[index].days)天"

            pointX += 90

            self.view.addSubview(dateLab)
            self.view.addSubview(pointView)
            self.view.addSubview(daysLab)
        }
    }
}

// MARK: push 方法
extension MainViewController {
    func pushController(with data: String) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let noticeVC = mainStoryBoard.instantiateViewController(withIdentifier: data)
        self.navigationController?.pushViewController(noticeVC, animated: true)
    }
}

// MARK: banner 图片选取
extension MainViewController {
    func getUseHeadImg() {
        print("头像更换")
        let actionSheet = UIAlertController(title: "更改头像", message: "请选择图像来源", preferredStyle: .actionSheet)
        let alterUserImg = UIAlertAction(title: "相册选择", style: .default, handler: {(_: UIAlertAction) -> Void in
            print("拍照继续更改头像中..")

            self.imgPricker = UIImagePickerController()
            self.imgPricker.delegate = self
            self.imgPricker.allowsEditing = true
            self.imgPricker.sourceType = .photoLibrary

            self.imgPricker.navigationBar.barTintColor = UIColor.gray
            self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            self.imgPricker.navigationBar.tintColor = UIColor.white

            self.present(self.imgPricker, animated: true, completion: nil)

        })

        let alterUserImgTake = UIAlertAction(title: "拍照选择", style: .default, handler: {(_: UIAlertAction) -> Void in
            print("继续更改头像中..")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.imgPricker = UIImagePickerController()
                self.imgPricker.delegate = self
                self.imgPricker.allowsEditing = true
                self.imgPricker.sourceType = .camera
                self.imgPricker.cameraDevice = UIImagePickerController.CameraDevice.rear
                self.imgPricker.showsCameraControls = true

                self.imgPricker.navigationBar.barTintColor = UIColor.gray
                self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

                self.imgPricker.navigationBar.tintColor = UIColor.white

                self.present(self.imgPricker, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: {(_: UIAlertAction) -> Void in print("取消更改头像")})

        actionSheet.addAction(cancel)
        actionSheet.addAction(alterUserImg)
        actionSheet.addAction(alterUserImgTake)

        self.present(actionSheet, animated: true) {
            print("正在更改")
        }
    }

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage

        let imgData = UIImage.jpegData(img)(compressionQuality: 1.0)
        Config.saveBannerImg(imgData)
        self.bannerImg.image = img

        self.dismiss(animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
