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
@interface ScoreShowViewController ()

@end

@implementation ScoreShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    [self setTitle];
    [self setOther];
    [self setJd];
    [self setScale];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScoreShowViewController *Score      = [main instantiateViewControllerWithIdentifier:@"ScoreData"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Score animated:YES];
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
    _Wtg.text=[NSString stringWithFormat:@"%d",[score getWtg]];
    _Zjd.text=[NSString stringWithFormat:@"%.2lf",[score getZxf]];
}
-(void)setJd{
    Score *score=[[Score alloc]init];
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSString *xf_2013_1=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2013-2014第1学期"]];
    NSString *xf_2013_2=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2013-2014第2学期"]];
    NSString *xf_2014_1=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2014-2015第1学期"]];
    NSString *xf_2014_2=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2014-2015第2学期"]];
    NSString *xf_2015_1=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2015-2016第1学期"]];
    NSString *xf_2015_2=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2015-2016第2学期"]];
    NSString *xf_2016_1=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2016-2017第1学期"]];
    NSString *xf_2016_2=[NSString stringWithFormat:@"%.2lf",[score getZxf:@"2016-2017第2学期"]];
    int grade;
    if([score getZxf:@"2013-2014第1学期"] != 0.0){  //大四
        _D11.text=xf_2013_1;
        _D12.text=xf_2013_2;
        _D21.text=xf_2014_1;
        _D22.text=xf_2014_2;
        _D31.text=xf_2015_1;
        _D32.text=xf_2015_2;
        _D41.text=xf_2016_1;
        _D42.text=xf_2016_2;
        _P11.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2013-2014第1学期"]/5.0];
        _P12.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2013-2014第2学期"]/5.0];
        _P21.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2014-2015第1学期"]/5.0];
        _P22.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2014-2015第2学期"]/5.0];
        _P31.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2015-2016第1学期"]/5.0];
        _P32.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2015-2016第2学期"]/5.0];
        _P41.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2017第1学期"]/5.0];
        _P42.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2016第2学期"]/5.0];
        _D11.hidden=false, _T11.hidden=false,_P11.hidden=false;
        _D12.hidden=false, _T12.hidden=false,_P12.hidden=false;
        _D21.hidden=false, _T21.hidden=false,_P21.hidden=false;
        _D22.hidden=false, _T22.hidden=false,_P22.hidden=false;
        _D31.hidden=false, _T31.hidden=false,_P31.hidden=false;
        _D32.hidden=false, _T32.hidden=false,_P32.hidden=false;
        _D41.hidden=false, _T41.hidden=false,_P41.hidden=false;
        _D42.hidden=false, _T42.hidden=false,_P42.hidden=false;
        grade=42;
        if ([score getZxf:@"2016-2017第2学期"]==0.0) {//下学期
            _D42.hidden=true, _T42.hidden=true,_P42.hidden=true;
            grade=41;
        }
    }
    else if ([score getZxf:@"2014-2015第1学期"] != 0.0){ //大三
        _D11.text=xf_2014_1;
        _D12.text=xf_2014_2;
        _D21.text=xf_2015_1;
        _D22.text=xf_2015_2;
        _D31.text=xf_2016_1;
        _D32.text=xf_2016_2;
        _P11.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2014-2015第1学期"]/5.0];
        _P12.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2014-2015第2学期"]/5.0];
        _P21.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2015-2016第1学期"]/5.0];
        _P22.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2015-2016第2学期"]/5.0];
        _P31.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2017第1学期"]/5.0];
        _P32.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2016第2学期"]/5.0];
        _D11.hidden=false, _T11.hidden=false,_P11.hidden=false;
        _D12.hidden=false, _T12.hidden=false,_P12.hidden=false;
        _D21.hidden=false, _T21.hidden=false,_P21.hidden=false;
        _D22.hidden=false, _T22.hidden=false,_P22.hidden=false;
        _D31.hidden=false, _T31.hidden=false,_P31.hidden=false;
        _D32.hidden=false, _T32.hidden=false,_P32.hidden=false;
        grade=32;
        if ([score getZxf:@"2016-2017第2学期"]==0.0) //下学期
            _D32.hidden=true, _T32.hidden=true,_P32.hidden=false,grade=31;
        
        
    }
    else if ([score getZxf:@"2015-2016第1学期"] != 0.0){ //大二
        _P11.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:0.95];
        _D11.text=xf_2015_1;
        _D12.text=xf_2015_2;
        _D21.text=xf_2016_1;
        _D22.text=xf_2016_2;
        _P11.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2015-2016第1学期"]/5.0];
        _P12.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2015-2016第2学期"]/5.0];
        _P21.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2017第1学期"]/5.0];
        _P22.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2016第2学期"]/5.0];
        _D11.hidden=false, _T11.hidden=false,_P11.hidden=false;
        _D12.hidden=false, _T12.hidden=false,_P12.hidden=false;
        _D21.hidden=false, _T21.hidden=false,_P21.hidden=false;
        _D22.hidden=false, _T22.hidden=false,_P22.hidden=false;
        grade=22;
        if ([score getZxf:@"2016-2017第2学期"]==0.0) //上学期
            _D22.hidden=true, _T22.hidden=true,_P22.hidden=false,grade=21;
    }
    else{  //大一
        _D11.text=xf_2016_1;
        _D11.text=xf_2016_2;
        _P11.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2017第1学期"]/5.0];
        _P12.image=[self scaleImage:[UIImage imageNamed:@"Score_jd"] toScale:[score getZxf:@"2016-2016第2学期"]/5.0];
        _D11.hidden=false, _T11.hidden=false,_P11.hidden=false;
        _D12.hidden=false, _T12.hidden=false,_P12.hidden=false;
        grade=12;
        if ([score getZxf:@"2016-2017第2学期"]==0.0) //下学期
            _D12.hidden=true,_T12.hidden=true,_P12.hidden=false,grade=11;
        
        
    }
    [defalut setInteger:grade forKey:@"sourceGrade"];
    [defalut synchronize];
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
