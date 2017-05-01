//
//  ChatBottomControlView.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/21.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatBottomContolViewDelegate;

@interface ChatBottomControlView : UIView

@property (weak, nonatomic) id<ChatBottomContolViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *emojiButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *voiceRecordButton;

@end

@protocol ChatBottomContolViewDelegate <NSObject>
@optional

-(void)recordCompletedWithData:(NSData *)data duration:(NSTimeInterval)duration localPath:(NSString *)localPath;


@end