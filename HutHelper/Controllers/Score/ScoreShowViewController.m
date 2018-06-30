//
//  ScoreShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/2/6.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ScoreShowViewController.h"
#import "UINavigationBar+Awesome.h"
 
#import "AppDelegate.h"
#import "Score.h"
#import "ScoreRank.h"
#import "DTKDropdownMenuView.h"
@interface ScoreShowViewController ()
@property (nonatomic,copy)NSMutableArray *rankArray;
@property (nonatomic,copy)NSMutableArray *yearMutableArray;
@property (nonatomic,copy)ScoreRank *scoreRank;
@property (nonatomic,assign)Boolean isZY;
@end

@implementation ScoreShowViewController{
    int numberView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    numberView=0;
    //设置标题
    [self setTitle];
    [self addTitleMenu];
    [self setOther];
    [self setScale];
    [self setRanks:_scoreRank.termMutableArray];
    self.isZY = false;
    //左滑手势
    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [Config pushViewController:@"ScoreData"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    //标题栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    //标题白色 导航返回按钮白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
    //标题栏透明取消
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:203/255.0 blue:219/255.0 alpha:1];
    [self.navigationController.navigationBar lt_reset];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
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
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
}
-(void)setOther{
    NSDictionary *rank =[[Config getScoreRank] objectForKey:@"rank"];
    _scoreRank=[[ScoreRank alloc]initWithArray:rank];
    self.Wtg.text=[NSString stringWithFormat:@"%@",[[Config getScoreRank] objectForKey:@"gks"]];
    self.Zjd.text=[NSString stringWithFormat:@"%@",[[Config getScoreRank] objectForKey:@"zhjd"]];
    self.Rank.text=[[Config getScoreRank] objectForKey:@"pjf"];
}

-(void)setRanks:(NSMutableArray*)rankMutableArray{
    for (int i=0; i<rankMutableArray.count;i++) {
        ScoreRank *scoreRank=rankMutableArray[i];
        //学期
        _label=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(35),SYReal(317+i*26)+iphoneX_Y(113),SYReal(200),SYReal(22))];
        _label.font=[UIFont systemFontOfSize: 10.0];
        if (scoreRank.term) {
            _label.text=[NSString stringWithFormat:@"%@第%@学期",scoreRank.year,scoreRank.term];
        }else{
            _label.text=[NSString stringWithFormat:@"%@学年",scoreRank.year];
        }
        _label.textColor=[UIColor whiteColor];
        _label.tag=200;
        [self.view addSubview:_label];
        //绩点条
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(150), SYReal(317+i*26)+iphoneX_Y(113), SYReal(180), SYReal(22))];
        _imageView.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[scoreRank.GPA doubleValue]/5.0];
        _imageView.contentMode =UIViewContentModeLeft;
        _imageView.clipsToBounds = YES;
        _imageView.alpha=0.7;
        _imageView.tag=200;
        [self.view addSubview:_imageView];
        //绩点
        _labelGPA=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(301),SYReal(317+i*26)+iphoneX_Y(113),SYReal(71),SYReal(22))];
        _labelGPA.font=[UIFont systemFontOfSize: 13.0];
        _labelGPA.text=scoreRank.GPA;
        _labelGPA.textColor=[UIColor whiteColor];
        _labelGPA.textAlignment = NSTextAlignmentRight;
        _labelGPA.tag=200;
        [self.view addSubview:_labelGPA];
        //排名
        _labelRank=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(336),SYReal(317+i*26)+iphoneX_Y(113),SYReal(71),SYReal(22))];
        _labelRank.font=[UIFont systemFontOfSize: 13.0];
        if (self.isZY == true) {
            _labelRank.text=scoreRank.zyRank;
        } else {
            _labelRank.text=scoreRank.bjRank;
        }
        _labelRank.textColor=[UIColor whiteColor];
        _labelRank.textAlignment = NSTextAlignmentRight;
        _labelRank.tag=200;
        [self.view addSubview:_labelRank];
        
        NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
        [defalut setInteger:i+1 forKey:@"sourceGrade"];
        [defalut synchronize];
    }
}
-(void)clearView{
    for(id tmpView in [self.view subviews])
    {
        UIView *imgView = (UIView *)tmpView;
        if(imgView.tag == 200 )   //判断是否满足自己要删除的子视图的条件
        {
            [imgView removeFromSuperview]; //删除子视图
        }
        
    }
}
-(void)setScale{
    _Scale.text=[NSString stringWithFormat:@"%.1f/%.1f",[[[Config getScoreRank] objectForKey:@"gks"] doubleValue],[[[Config getScoreRank] objectForKey:@"zxf"] doubleValue]];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height ));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height )];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)addTitleMenu
{
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"学期班级成绩" callBack:^(NSUInteger index, id info) {
        [self clearView];
        self.isZY = false;
        [self setRanks:_scoreRank.termMutableArray];
    }];
    DTKDropdownItem *item1,*item2,*item3;
    DTKDropdownMenuView *menuView;
    item1 = [DTKDropdownItem itemWithTitle:@"学年班级成绩" callBack:^(NSUInteger index, id info) {
        [self clearView];
        self.isZY = false;
        [self setRanks:_scoreRank.yearMutableArray];
    }];
    item2 = [DTKDropdownItem itemWithTitle:@"学期专业成绩" callBack:^(NSUInteger index, id info) {
        [self clearView];
        self.isZY = true;
        [self setRanks:_scoreRank.termMutableArray];
    }];
    item3 = [DTKDropdownItem itemWithTitle:@"学年专业成绩" callBack:^(NSUInteger index, id info) {
        [self clearView];
        self.isZY = true;
        [self setRanks:_scoreRank.yearMutableArray];
    }];
    
    menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item1,item2,item3]];
    menuView.currentNav = self.navigationController;
    menuView.dropWidth = 150.f;
    menuView.textColor = [UIColor blackColor];
    menuView.textFont = [UIFont systemFontOfSize:14.f];
    menuView.animationDuration = 0.2f;
    menuView.selectedIndex = 0;
    menuView.titleColor=RGB(233, 233, 233, 1);
    self.navigationItem.titleView = menuView;
    
}
@end
