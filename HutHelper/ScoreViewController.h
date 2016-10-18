//
//  ScoreViewController.h
//  HutHelper
//
//  Created by nine on 2016/10/18.
//  Copyright © 2016年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"

@interface ScoreViewController : UIViewController <SKSTableViewDelegate>
@property (nonatomic, weak) IBOutlet SKSTableView *tableView;
@end
