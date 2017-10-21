//
//  FORGestureTrack.h
//  LooseLeaf
//
//  Created by Adam Wulf on 4/5/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FORGesture.h"

//@interface UIWindow (tracking)
//- (void)startTracking;
//@end


@interface FORGestureTrack : UIView <FORGestureDelegate>
@property (nonatomic) UIColor* dotColor;
@property (nonatomic) CGFloat dotWidth;
@end
