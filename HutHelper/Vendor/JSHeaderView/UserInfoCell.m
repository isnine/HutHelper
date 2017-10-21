//
//  UserInfoCell.m
//  JSHeaderView
//
//  Created by 雷亮 on 16/8/1.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "UserInfoCell.h"
#import "AppDelegate.h"

 
@interface UserInfoCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *editInfoButton;

@end

@implementation UserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.infoLabel];
        [self addSubview:self.editInfoButton];
    }
    return self;
}

- (UILabel *)nameLabel {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *username=Config.getUserName;
    if ([defaults objectForKey:@"username"]!=NULL) {
        username=[defaults objectForKey:@"username"];
    }
    else if(username == NULL ){
        username=Config.getTrueName;;
    }
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _nameLabel.center = CGPointMake(kScreenWidth / 2, 60);
        _nameLabel.text = username;
        _nameLabel.textAlignment = 1;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    
    NSString *last_login=Config.getLastLogin;
    if (last_login ==NULL) {
        last_login=@"无";
    }
    if ([last_login isEqualToString:@"1970-01-01 08:00"]) {
        last_login=@"无";
    }
    
    
    last_login=[@"最后一次登录时间:" stringByAppendingString:last_login];
    
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        _infoLabel.center = CGPointMake(kScreenWidth / 2, 99);
        _infoLabel.text = last_login;
        _infoLabel.textAlignment = 1;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = [UIColor darkTextColor];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont systemFontOfSize:11];
    }
    return _infoLabel;
}

- (UIButton *)editInfoButton {
    if (!_editInfoButton) {
        _editInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editInfoButton.frame = CGRectMake(0, 0, 86, 27);
        _editInfoButton.center = CGPointMake(kScreenWidth / 2, 145);
        [_editInfoButton setTitle:@"编辑昵称" forState:UIControlStateNormal];
        _editInfoButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [_editInfoButton setTitleColor:HEXCOLOR(0x88e47a) forState:UIControlStateNormal];
        _editInfoButton.layer.borderColor = HEXCOLOR(0x88e47a).CGColor;
        _editInfoButton.layer.cornerRadius = 2;
        _editInfoButton.layer.borderWidth = 0.5f;
        [_editInfoButton addTarget:self action:@selector(handleEditAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editInfoButton;
}

- (void)handleEditAction:(UIButton *)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserInfoCell *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Username"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
