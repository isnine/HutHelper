//
//  ChatBottomContentView.h
//  BmobIMDemo
//
//  Created by Bmob on 16/2/29.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBottomContentView : UIView

@property (weak, nonatomic) IBOutlet UIButton *photoLibButton;
@property (weak, nonatomic) IBOutlet UIButton *photoTakeButton;
@property (weak, nonatomic) IBOutlet UIButton *locateButton;


-(void)setupSubviews;

@end
