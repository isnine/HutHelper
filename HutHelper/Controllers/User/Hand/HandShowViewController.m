//
//  HandShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/18.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandShowViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UMMobClick/MobClick.h"
#import "XWScanImage.h"
 
@interface HandShowViewController ()
@property (weak, nonatomic) IBOutlet UITextView *Content;
@property (weak, nonatomic) IBOutlet UIImageView *Img1;
@property (weak, nonatomic) IBOutlet UIImageView *Img2;
@property (weak, nonatomic) IBOutlet UIImageView *Img3;
@property (weak, nonatomic) IBOutlet UIImageView *Img4;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *Old;
@property (weak, nonatomic) IBOutlet UITextView *contact;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *Img5;
@property (weak, nonatomic) IBOutlet UIImageView *Img6;
@property (weak, nonatomic) IBOutlet UILabel *Ttile;

@end

@implementation HandShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"商品详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _Hand_show=[defaults objectForKey:@"Hand_Show"];
    [self setshow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setshow{
    _Content.text=[_Hand_show objectForKey:@"content"];
    _price.text=[_Hand_show objectForKey:@"prize"];
    _Old.text=[_Hand_show objectForKey:@"attr"];
    _contact.text=[self getcontact];
    _user.text=[[_Hand_show objectForKey:@"user"] objectForKey:@"username"];
    _time.text=[_Hand_show objectForKey:@"created_on"];
    _Ttile.text=[_Hand_show objectForKey:@"tit"];
    NSArray *img=[_Hand_show objectForKey:@"pics"];
    _Img1.contentMode =UIViewContentModeScaleAspectFill;
    _Img1.clipsToBounds = YES;
    _Img2.contentMode =UIViewContentModeScaleAspectFill;
    _Img2.clipsToBounds = YES;
    _Img3.contentMode =UIViewContentModeScaleAspectFill;
    _Img3.clipsToBounds = YES;
    _Img4.contentMode =UIViewContentModeScaleAspectFill;
    _Img4.clipsToBounds = YES;
    _Img5.contentMode =UIViewContentModeScaleAspectFill;
    _Img5.clipsToBounds = YES;
    _Img6.contentMode =UIViewContentModeScaleAspectFill;
    _Img6.clipsToBounds = YES;
    switch (img.count) {
        case 1:{
            [_Img5 sd_setImageWithURL:[NSURL URLWithString:[self getimg:0]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img5 addGestureRecognizer:tapGestureRecognizer1];
            [_Img5 setUserInteractionEnabled:YES];
        }
            break;
        case 2:{
            [_Img5 sd_setImageWithURL:[NSURL URLWithString:[self getimg:0]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            [_Img6 sd_setImageWithURL:[NSURL URLWithString:[self getimg:1]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img5 addGestureRecognizer:tapGestureRecognizer1];
            [_Img5 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img6 addGestureRecognizer:tapGestureRecognizer2];
            [_Img6 setUserInteractionEnabled:YES];
        }
            break;
        case 3:{
            [_Img1 sd_setImageWithURL:[NSURL URLWithString:[self getimg:0]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            [_Img2 sd_setImageWithURL:[NSURL URLWithString:[self getimg:1]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            [_Img3 sd_setImageWithURL:[NSURL URLWithString:[self getimg:2]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img1 addGestureRecognizer:tapGestureRecognizer1];
            [_Img1 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img2 addGestureRecognizer:tapGestureRecognizer2];
            [_Img2 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img3 addGestureRecognizer:tapGestureRecognizer3];
            [_Img3 setUserInteractionEnabled:YES];
    }
            break;
        case 4:{
            [_Img1 sd_setImageWithURL:[NSURL URLWithString:[self getimg:0]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            [_Img2 sd_setImageWithURL:[NSURL URLWithString:[self getimg:1]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            [_Img3 sd_setImageWithURL:[NSURL URLWithString:[self getimg:2]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            [_Img4 sd_setImageWithURL:[NSURL URLWithString:[self getimg:3]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img1 addGestureRecognizer:tapGestureRecognizer1];
            [_Img1 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img2 addGestureRecognizer:tapGestureRecognizer2];
            [_Img2 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img3 addGestureRecognizer:tapGestureRecognizer3];
            [_Img3 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [_Img4 addGestureRecognizer:tapGestureRecognizer4];
            [_Img4 setUserInteractionEnabled:YES];
            
        }
            break;
        default:
            break;
    }
}
-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}
-(NSString*)getimg:(int)i{
    NSArray *img=[_Hand_show objectForKey:@"pics"];
    NSString *Url_String=[NSString stringWithFormat:API_IMG,img[i]];
    return Url_String;
}
-(NSString*)getcontact{
    NSString *Contact=[NSString stringWithFormat:@"手机:%@\nQQ:%@\n微信:%@\n",[_Hand_show objectForKey:@"phone"],[_Hand_show objectForKey:@"qq"],[_Hand_show objectForKey:@"wechat"]];
    return Contact;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"二手市场"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"二手市场"];
}
@end
