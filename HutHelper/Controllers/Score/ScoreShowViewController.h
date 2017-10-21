//
//  ScoreShowViewController.h
//  HutHelper
//
//  Created by nine on 2017/2/6.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreShowViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *Wtg;
@property (weak, nonatomic) IBOutlet UILabel *Zjd;
@property (weak, nonatomic) IBOutlet UILabel *Rank;
@property (weak, nonatomic) IBOutlet UILabel *Scale;

@property (nonatomic,strong) IBOutlet UILabel *label;
@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) IBOutlet UILabel *labelGPA;
@property (nonatomic,strong) IBOutlet UILabel *labelRank;

@end
