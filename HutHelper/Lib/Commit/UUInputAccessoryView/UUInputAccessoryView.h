//
//  inputAccessoryView.h
//  InputAccessoryView-WindowLayer
//
//  Created by shake on 14/11/14.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUInputConfiger;

// Block
typedef void(^UUInputAccessoryBlock) (NSString * _Nonnull contentStr);

typedef void(^UUInputAccessoryConfige) (UUInputConfiger *_Nonnull configer);


@interface UUInputAccessoryView : NSObject

+ (void)dimiss;

+ (void)showBlock:(UUInputAccessoryBlock _Nullable)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                   Block:(UUInputAccessoryBlock _Nullable)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                 content:(NSString * _Nullable)content
                   Block:(UUInputAccessoryBlock _Nullable)block;

// more flexible config
+ (void)showKeyboardConfige:(UUInputAccessoryConfige _Nullable)confige
                      block:(UUInputAccessoryBlock _Nullable)block;

@end


@interface UUInputConfiger : NSObject

// default UIKeyboardTypeDefault
@property (assign, nonatomic) UIKeyboardType keyboardType;
// default nil
@property (copy, nonatomic, nullable) NSString *content;
// default YES
@property (assign, nonatomic) BOOL backgroundUserInterface;
// default clearColor
@property (strong, nonatomic, nullable) UIColor *backgroundColor;

@end
