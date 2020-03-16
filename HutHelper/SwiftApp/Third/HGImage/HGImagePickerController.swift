//
//  HGImageAlbumItem.swift
//  hangge_1512
//
//  Created by hangge on 2017/1/7.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos

class SKPHAssetToImageTool: NSObject {
    @objc class func PHAssetToImage(asset:PHAsset) -> UIImage{
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
        
    }
}



//相簿列表项
struct HGImageAlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
}

//相簿列表页控制器
class HGImagePickerController: UIViewController {
    //显示相簿列表项的表格
    @IBOutlet weak var tableView:UITableView!
    
    //相簿列表项集合
    var items:[HGImageAlbumItem] = []
    
    //每次最多可选择的照片数量
    var maxSelected:Int = Int.max
    
    //照片选择完毕后的回调
    var completeHandler:((_ assets:[PHAsset])->())?
    
    //从xib或者storyboard加载完毕就会调用
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //申请权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            
            // 列出所有系统的智能相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                              subtype: .albumRegular,
                                                              options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            //列出所有用户创建的相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections
                as! PHFetchResult<PHAssetCollection>)
            
            //相册按包含的照片数量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            //异步加载表格数据,需要在主线程中调用reloadData() 方法
            DispatchQueue.main.async{
                self.tableView?.reloadData()
                
                //首次进来后直接进入第一个相册图片展示页面（相机胶卷）
                if let imageCollectionVC = self.storyboard?
                    .instantiateViewController(withIdentifier: "hgImageCollectionVC")
                    as? HGImageCollectionViewController{
                    imageCollectionVC.title = self.items.first?.title
                    imageCollectionVC.assetsFetchResults = self.items.first?.fetchResult
                    imageCollectionVC.completeHandler = self.completeHandler
                    imageCollectionVC.maxSelected = self.maxSelected
                    self.navigationController?.pushViewController(imageCollectionVC,
                                                                  animated: false)
                }
            }
        })
    }
    
    //页面加载完毕
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置标题
        title = "相簿"
        //设置表格相关样式属性
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = 55
        //添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                           action:#selector(cancel) )
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    //转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0 {
                let title = titleOfAlbumForChinse(title: c.localizedTitle)
                items.append(HGImageAlbumItem(title: title,
                                              fetchResult: assetsFetchResult))
            }
        }
    }
    
    //由于系统返回的相册集名称为英文，我们需要转换为中文
    private func titleOfAlbumForChinse(title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
    
    //取消按钮点击
    @objc func cancel() {
        //退出当前视图控制器
        self.dismiss(animated: true, completion: nil)
    }
    
    //页面跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //如果是跳转到展示相簿缩略图页面
        if segue.identifier == "showImages"{
            //获取照片展示控制器
            guard let imageCollectionVC = segue.destination
                as? HGImageCollectionViewController,
                let cell = sender as? HGImagePickerCell else{
                return
            }
            //设置回调函数
            imageCollectionVC.completeHandler = completeHandler
            //设置标题
            imageCollectionVC.title = cell.titleLabel.text
            //设置最多可选图片数量
            imageCollectionVC.maxSelected = self.maxSelected
            guard  let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            //获取选中的相簿信息
            let fetchResult = self.items[indexPath.row].fetchResult
            //传递相簿内的图片资源
            imageCollectionVC.assetsFetchResults = fetchResult
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//相簿列表页控制器UITableViewDelegate,UITableViewDataSource协议方法的实现
extension HGImagePickerController:UITableViewDelegate,UITableViewDataSource{
    //设置单元格内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HGImagePickerCell
        let item = self.items[indexPath.row]
        cell.titleLabel.text = "\(item.title ?? "") "
        cell.countLabel.text = "（\(item.fetchResult.count)）"
        return cell
    }
    
    //表格单元格数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    //表格单元格选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIViewController {
    //HGImagePicker提供给外部调用的接口，同于显示图片选择页面
    func presentHGImagePicker(maxSelected:Int = Int.max,
                              completeHandler:((_ assets:[PHAsset])->())?)
        -> HGImagePickerController?{
        //获取图片选择视图控制器
        if let vc = UIStoryboard(name: "HGImage", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "imagePickerVC")
            as? HGImagePickerController{
            //设置选择完毕后的回调
            vc.completeHandler = completeHandler
            //设置图片最多选择的数量
            vc.maxSelected = maxSelected
            //将图片选择视图控制器外添加个导航控制器，并显示
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return vc
        }
        return nil
    }
}
