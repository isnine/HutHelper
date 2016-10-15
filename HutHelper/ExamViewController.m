//
//  ExamViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/15.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "ExamViewController.h"
#import "MyView.h"
#import "MsgModel.h"
#import "JSONKit.h"

@interface ExamViewController (){
   UIScrollView * scrollView;
   MyView * myView;
   UIView * dataPiker;
}
@end
@implementation NSString (MD5)
 - (id)MD5
 {
         const char *cStr = [self UTF8String];
         unsigned char digest[16];
         unsigned int x=(int)strlen(cStr) ;
         CC_MD5( cStr, x, digest );
         // This is the md5 call
         NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
         for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                 [output appendFormat:@"%02x", digest[i]];
    
        return  output;
 }
 @end
@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"考试计划";
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *studentKH = [defaults objectForKey:@"studentKH"];

    NSString *Url_String_1=@"http://218.75.197.124:84/api/exam/";
    NSString *Url_String_1_U=[Url_String_1 stringByAppendingString:studentKH];
    NSString *Url_String_1_U_2=[Url_String_1_U stringByAppendingString:@"/key/"];
    NSString *ss=[studentKH stringByAppendingString:@"apiforapp!"];
    NSString *ssmd5=[ss MD5];
    NSString *Url_String=[Url_String_1_U_2 stringByAppendingString:ssmd5];
    
    NSURL *url = [NSURL URLWithString: Url_String]; //接口地址
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *User_All = [jsonData objectFromJSONData];//数据 -> 字典
   //All字典 -> Data字典
//
   NSString *Msg=[User_All objectForKey:@"msg"];
   NSString *status=[User_All objectForKey:@"status"];
   NSLog(@"状态:%@",status);
    MsgModel * mode0=[[MsgModel alloc]init];
    MsgModel * mode1=[[MsgModel alloc]init];
    MsgModel * mode2=[[MsgModel alloc]init];
    MsgModel * mode3=[[MsgModel alloc]init];
    MsgModel * mode4=[[MsgModel alloc]init];
    MsgModel * mode5=[[MsgModel alloc]init];
    MsgModel * mode6=[[MsgModel alloc]init];
    MsgModel * mode7=[[MsgModel alloc]init];
    MsgModel * mode8=[[MsgModel alloc]init];
    MsgModel * mode9=[[MsgModel alloc]init];
    MsgModel * mode10=[[MsgModel alloc]init];
    MsgModel * mode11=[[MsgModel alloc]init];
    MsgModel * mode12=[[MsgModel alloc]init];
    NSDictionary *Class_Data=[User_All objectForKey:@"res"];
    NSArray *array = [Class_Data objectForKey:@"exam"];
    
    if([status isEqualToString:@"success"]){
        int k;
        for(k=0;k<array.count;k++){
        NSDictionary *dict1 = array[k];
        
        NSString *CourseName = [dict1 objectForKey:@"CourseName"]; //第几节
        NSString *EndTime = [dict1 objectForKey:@"EndTime"];  //结束周
        NSString *RoomName = [dict1 objectForKey:@"RoomName"];  //起始周
        NSString *Starttime = [dict1 objectForKey:@"Starttime"];  //起始周
        NSString *Week_Num = [dict1 objectForKey:@"Week_Num"];  //起始周
        NSString *isset = [dict1 objectForKey:@"isset"];  //起始周

        
            switch (k) {
                case 0:
                    mode0.address=CourseName;
                    mode0.motive=RoomName;
                    mode0.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode0.color=[UIColor redColor];
                    }
                    else
                        mode0.color=[UIColor greenColor];
                    break;
                case 1:
                    mode1.address=CourseName;
                    mode1.motive=RoomName;
                    mode1.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode1.color=[UIColor redColor];
                    }
                    else
                        mode1.color=[UIColor greenColor];
                    break;
                case 2:
                    mode2.address=CourseName;
                    mode2.motive=RoomName;
                    mode2.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode2.color=[UIColor redColor];
                    }
                    else
                        mode2.color=[UIColor greenColor];
                    break;
                case 3:
                    mode3.address=CourseName;
                    mode3.motive=RoomName;
                    mode3.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode3.color=[UIColor redColor];
                    }
                    else
                        mode3.color=[UIColor greenColor];
                    break;
                case 4:
                    mode4.address=CourseName;
                    mode4.motive=RoomName;
                    mode4.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode4.color=[UIColor redColor];
                    }
                    else
                        mode4.color=[UIColor greenColor];
                    break;
                case 5:
                    mode5.address=CourseName;
                    mode5.motive=RoomName;
                    mode5.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode5.color=[UIColor redColor];
                    }
                    else
                        mode5.color=[UIColor greenColor];
                    break;
                case 6:
                    mode6.address=CourseName;
                    mode6.motive=RoomName;
                    mode6.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode6.color=[UIColor redColor];
                    }
                    else
                        mode6.color=[UIColor greenColor];
                    break;
                case 7:
                    mode7.address=CourseName;
                    mode7.motive=RoomName;
                    mode7.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode7.color=[UIColor redColor];
                    }
                    else
                        mode7.color=[UIColor greenColor];
                    break;
                case 8:
                    mode8.address=CourseName;
                    mode8.motive=RoomName;
                    mode8.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode8.color=[UIColor redColor];
                    }
                    else
                        mode8.color=[UIColor greenColor];
                    break;
                case 9:
                    mode9.address=CourseName;
                    mode9.motive=RoomName;
                    mode9.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode9.color=[UIColor redColor];
                    }
                    else
                        mode9.color=[UIColor greenColor];
                    break;
                case 10:
                    mode10.address=CourseName;
                    mode10.motive=RoomName;
                    mode10.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode10.color=[UIColor redColor];
                    }
                    else
                        mode10.color=[UIColor greenColor];
                    break;
                case 11:
                    mode11.address=CourseName;
                    mode11.motive=RoomName;
                    mode11.date=Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode11.color=[UIColor redColor];
                    }
                    else
                        mode11.color=[UIColor greenColor];
                    break;
                default:
                    break;
            }
        mode1.address=CourseName;
        mode1.motive=RoomName;
        mode1.date=Starttime;
        if ([isset isEqualToString:@"0"]) {
            mode1.color=[UIColor redColor];
        }
        else
            mode1.color=[UIColor greenColor];
       

        }
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"查询失败"
                                                            message:Msg
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    NSLog(@"%@",ssmd5);
    
    myView=[[MyView alloc]init];
    MsgModel * model=[[MsgModel alloc]init];

    switch (array.count) {
        case 0:{
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"暂无考试"
                                                                message:@"计划表上暂时没有考试"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView1 show];
            break;
        }
        case 1:
            myView.msgModelArray=@[mode0];
            break;
        case 2:
            myView.msgModelArray=@[mode0,mode1];
            break;
        case 3:
            myView.msgModelArray=@[mode0,mode1,mode2];
            break;
        case 4:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3];
            break;
        case 5:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4];
            break;
        case 6:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5];
            break;
        case 7:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6];
            break;
        case 8:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7];
            break;
        case 9:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8];
            break;
        case 10:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9];
            break;
        case 11:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9,mode10];
            break;
        default:
            break;
    }

    NSLog(@"%d",array.count);
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.backgroundColor=RGBACOLOR(240, 240, 240, 1);
    dataPiker=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, SP_W(60))];
    myView.frame=CGRectMake(0,SP_W(-10), WIDTH, SP_W(60)*myView.msgModelArray.count+65);
    scrollView.contentSize=CGSizeMake(0, SP_W(60)*(myView.msgModelArray.count+2)+SP_W(30));
    [scrollView addSubview:dataPiker];
    [scrollView addSubview:myView];
    [self.view addSubview:scrollView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
