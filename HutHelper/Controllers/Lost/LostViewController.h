//
//  LostViewController.h
//  HutHelper
//
//  Created by nine on 2017/8/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostViewController : UIViewController
@property (nonatomic,copy) NSArray *myLostArray;
@property (nonatomic,copy) NSArray *otherLostArray;
@property (nonatomic,copy) NSString *otherName;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
