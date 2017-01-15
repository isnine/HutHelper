//
//  FORGesture.h
//  LooseLeaf
//
//  Created by Adam Wulf on 4/5/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FORGestureDelegate <NSObject>

- (void)forTouchesBegan:(NSSet *)touches;

- (void)forTouchesMoved:(NSSet *)touches;

- (void)forTouchesEnded:(NSSet *)touches;

- (void)forTouchesCancelled:(NSSet *)touches;

@end



@interface FORGesture : UIGestureRecognizer <UIGestureRecognizerDelegate>

@property (readonly) NSSet *activeTouches;

@property (nonatomic, weak) NSObject<FORGestureDelegate>* touchDelegate;


- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithTarget:(id)target action:(SEL)action NS_UNAVAILABLE;

@end
