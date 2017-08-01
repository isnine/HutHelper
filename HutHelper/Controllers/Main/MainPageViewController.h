//
//  MainPageViewController.h
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftSortsViewController;
@interface MainPageViewController : UIViewController
typedef enum ClassStatus {
    ClassOK  = 0,
    ClassXpError,
    ClassError,
    ClassAndClassXpError
} ClassStatus;

typedef enum ScoreStatus {
    ScoreOK  = 0,
    ScoreRankError,
    ScoreError,
    ScoreAndScoreRankError
} ScoreStatus;

@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UILabel *noticetitle;
@property (weak, nonatomic) IBOutlet UILabel *noticetime;
@property (nonatomic, strong) LeftSortsViewController *leftSortsViewController;

@end
