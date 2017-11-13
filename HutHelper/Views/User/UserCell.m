//
//  UserCell.m
//  HutHelper
//
//  Created by nine on 2017/11/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "UserCell.h"
#import <Masonry/Masonry.h>
@interface UserCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation UserCell

-(instancetype)initWithName:(NSString*)nameStr withInfo:(NSString*)infoStr reuseIdentifier:(NSString *)reuseIdentifier{
    self.nameStr=nameStr;
    self.infoStr=infoStr;
    self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = self.nameStr;
        _nameLabel.textAlignment = 1;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, 20)];
        _infoLabel.text = self.infoStr;
        _infoLabel.textAlignment = NSTextAlignmentRight;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = Color(0xadadad);
        _infoLabel.font = [UIFont systemFontOfSize:18];
    }
    return _infoLabel;
}

-(void)layoutSubviews{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-580);
//        make.bottom.mas_equalTo(-10);
    }];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(10);
  //      make.left.mas_equalTo(80);
        make.right.mas_equalTo(-300);
//        make.bottom.mas_equalTo(-10);
    }];
}

@end
