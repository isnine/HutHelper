//
//  XXShopCell.m
//  WaterFallLayout
//
//  Created by sky on 16/6/6.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JRShopCell.h"
#import "UIImageView+WebCache.h"
#import "JRShop.h"

@interface JRShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation JRShopCell

- (void)setShop:(JRShop *)shop
{
    _shop = shop;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    self.priceLabel.text = shop.price;
}


@end
