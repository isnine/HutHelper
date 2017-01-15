//
//  inputAccessoryView.m
//  InputAccessoryView-WindowLayer
//
//  Created by shake on 14/11/14.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputAccessoryView.h"

#define UUIAV_MAIN_W    CGRectGetWidth([UIScreen mainScreen].bounds)
#define UUIAV_MAIN_H    CGRectGetHeight([UIScreen mainScreen].bounds)
#define UUIAV_Edge_Hori 5
#define UUIAV_Edge_Vert 7
#define UUIAV_Btn_W    40
#define UUIAV_Btn_H    35


@interface UUInputAccessoryView ()<UITextViewDelegate>
{
    UUInputAccessoryBlock inputBlock;

    UIButton *btnBack;
    UITextView *inputView;
    UITextField *assistView;
    UIButton *BtnSave;
    
    // dirty code for iOS9
    BOOL shouldDismiss;
}
@end

@implementation UUInputAccessoryView

+ (UUInputAccessoryView*)sharedView {
    static dispatch_once_t once;
    static UUInputAccessoryView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUInputAccessoryView alloc] init];
        
        UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backgroundBtn.frame = CGRectMake(0, 0, UUIAV_MAIN_W, UUIAV_MAIN_H);
        [backgroundBtn addTarget:sharedView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UUIAV_MAIN_W, UUIAV_Btn_H+2*UUIAV_Edge_Vert)];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_MAIN_W-UUIAV_Btn_W-4*UUIAV_Edge_Hori, UUIAV_Btn_H)];
        textView.returnKeyType = UIReturnKeyDone;
        textView.enablesReturnKeyAutomatically = YES;
        textView.delegate = sharedView;
        textView.font = [UIFont systemFontOfSize:14];
        textView.layer.cornerRadius = 5;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.layer.borderWidth = 0.5;
        [toolbar addSubview:textView];
        
        UITextField *assistTxf = [UITextField new];
        assistTxf.returnKeyType = UIReturnKeyDone;
        assistTxf.enablesReturnKeyAutomatically = YES;
        [backgroundBtn addSubview:assistTxf];
        assistTxf.inputAccessoryView = toolbar;
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(UUIAV_MAIN_W-UUIAV_Btn_W-2*UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_Btn_W, UUIAV_Btn_H);
        saveBtn.backgroundColor = [UIColor clearColor];
        [saveBtn setTitle:@"发送" forState:UIControlStateNormal];
        [saveBtn setTitle:@"取消" forState:UIControlStateSelected];
        [saveBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:220/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateSelected];
        [saveBtn addTarget:sharedView action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:saveBtn];

        sharedView->btnBack = backgroundBtn;
        sharedView->inputView = textView;
        sharedView->assistView = assistTxf;
        sharedView->BtnSave = saveBtn;
    });

    return sharedView;
}

+ (void)showBlock:(UUInputAccessoryBlock _Nullable)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    [[UUInputAccessoryView sharedView] show:block configer:configer];
}

+ (void)showKeyboardType:(UIKeyboardType)type
                   Block:(UUInputAccessoryBlock _Nullable)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    configer.keyboardType = type;
    [[UUInputAccessoryView sharedView] show:block configer:configer];
}

+ (void)showKeyboardType:(UIKeyboardType)type
                 content:(NSString * _Nullable)content
                   Block:(UUInputAccessoryBlock _Nullable)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    configer.keyboardType = type;
    configer.content = content;
    [[UUInputAccessoryView sharedView] show:block configer:configer];
}

+ (void)showKeyboardConfige:(UUInputAccessoryConfige _Nullable)confige
                      block:(UUInputAccessoryBlock _Nullable)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    !confige?:confige(configer);
    [[UUInputAccessoryView sharedView] show:block configer:configer];
}

- (void)show:(UUInputAccessoryBlock)block configer:(UUInputConfiger *_Nullable)configer
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:btnBack];
    
    shouldDismiss = NO;
    
    inputBlock = block;
    inputView.text = configer.content;
    assistView.text = configer.content;
    inputView.keyboardType = configer.keyboardType;
    assistView.keyboardType = configer.keyboardType;
    BtnSave.selected = configer.content.length==0;
    btnBack.userInteractionEnabled = configer.backgroundUserInterface;
    btnBack.backgroundColor = configer.backgroundColor ?: [UIColor clearColor];
    [assistView becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (!shouldDismiss) {
                                                          [inputView becomeFirstResponder];
                                                      }
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self dismiss];
                                                  }];

}

- (void)btnClick
{
    [inputView resignFirstResponder];
    if (!BtnSave.selected) {
        !inputBlock ?: inputBlock(inputView.text ?: @"");
    }
    [self dismiss];
}

- (void)dismiss
{
    shouldDismiss = YES;
    [inputView resignFirstResponder];
    [btnBack removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// textView's delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self btnClick];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    BtnSave.selected = textView.text.length==0;
}

@end



@implementation UUInputConfiger

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundUserInterface = YES;
    }
    return self;
}

@end
