//
//  UploadimageViewController.h
//  HutHelper
//
//  Created by nine on 2016/11/21.
//  Copyright © 2016年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadimageViewController : UIViewController<UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIWebView *myWebView;
    UIImagePickerController *picker_library_;
}
//我的WebView控件
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
//相册类的变量
@property (nonatomic, retain) IBOutlet UIImagePickerController *picker_library_;

@end
