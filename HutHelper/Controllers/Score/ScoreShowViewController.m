//
//  ScoreShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/2/6.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ScoreShowViewController.h"
#import "UINavigationBar+Awesome.h"
#import "UMMobClick/MobClick.h"
#import "AppDelegate.h"
#import "Score.h"
#import "ScoreRank.h"
@interface ScoreShowViewController ()
@property (nonatomic,copy)NSMutableArray *termMutableArray;
@property (nonatomic,copy)NSMutableArray *yearMutableArray;
@property (nonatomic,copy)ScoreRank *scoreRank;
@end

@implementation ScoreShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    [self setTitle];
    [self setOther];
    //[self setJd];
    [self setScale];
   [self setRank];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"成绩查询"];
    //标题栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    //标题白色 导航返回按钮白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"成绩查询"];
    //标题栏透明取消
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1];
    [self.navigationController.navigationBar lt_reset];
    
}
- (IBAction)PushScoreData:(id)sender {
    [Config pushViewController:@"ScoreData"];
}
#pragma - 其他
-(void)setTitle{
    self.title=@"成绩";
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
}
-(void)setOther{
    Score *score=[[Score alloc]init];
    _scoreRank=[[ScoreRank alloc]initWithArray:[Config getScoreRank]];
    self.Wtg.text=[NSString stringWithFormat:@"%d",[score getWtg]];
    self.Zjd.text=[NSString stringWithFormat:@"%.2lf",[score getZxf]];
    self.Rank.text=_scoreRank.rank;
}

-(void)setRank{
    for (int i=0; i<_scoreRank.termMutableArray.count;i++) {
        ScoreRank *scoreRank=_scoreRank.termMutableArray[i];
        //学期
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(35),SYReal(317+i*26),SYReal(200),SYReal(22))];
        label.font=[UIFont systemFontOfSize: 10.0];
        label.text=[NSString stringWithFormat:@"%@第%@学期",scoreRank.year,scoreRank.term];
        label.textColor=[UIColor whiteColor];
        [self.view addSubview:label];
        //绩点条
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(150), SYReal(317+i*26), SYReal(180), SYReal(22))];
        imageView.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[scoreRank.GPA doubleValue]/5.0];
        imageView.contentMode =UIViewContentModeLeft;
        imageView.clipsToBounds = YES;
        imageView.alpha=0.7;
        [self.view addSubview:imageView];
        //绩点
        UILabel *labelGPA=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(301),SYReal(317+i*26),SYReal(71),SYReal(22))];
        labelGPA.font=[UIFont systemFontOfSize: 13.0];
        labelGPA.text=scoreRank.GPA;
        labelGPA.textColor=[UIColor whiteColor];
        labelGPA.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:labelGPA];
        //排名
        UILabel *labelRank=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(336),SYReal(317+i*26),SYReal(71),SYReal(22))];
        labelRank.font=[UIFont systemFontOfSize: 13.0];
        labelRank.text=scoreRank.rank;
        labelRank.textColor=[UIColor whiteColor];
        labelRank.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:labelRank];
        
        NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
        [defalut setInteger:i+1 forKey:@"sourceGrade"];
        [defalut synchronize];
    }
}
-(void)setScale{
    Score *score=[[Score alloc]init];
    _Scale.text=[score getScale];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height ));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height )];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
