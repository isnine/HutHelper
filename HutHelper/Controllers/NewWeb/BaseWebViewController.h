//
//  BaseWebViewController.h
//  HutHelper
//
//  Created by 张驰 on 2019/11/14.
//  Copyright © 2019 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebViewController : UIViewController
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *centerTitle;
@end

NS_ASSUME_NONNULL_END
