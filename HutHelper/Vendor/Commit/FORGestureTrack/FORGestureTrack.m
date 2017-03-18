//
//  FORGestureTrack.m
//  LooseLeaf
//
//  Created by Adam Wulf on 4/5/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import "FORGestureTrack.h"


#pragma mark - FORGesture Category

@interface FORGesture (Private)
+ (FORGesture *) sharedInstace;
@end

#pragma mark -  FORGestureTrack


@implementation FORGestureTrack{
    FORGesture* touchGesture;
    NSMutableDictionary* dots;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self finishInit];
    }
    return self;
}

-(void)finishInit {
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    touchGesture = [FORGesture sharedInstace];
    [touchGesture setTouchDelegate:self];
    dots = [NSMutableDictionary dictionary];
    self.dotWidth = 20;
    self.dotColor = [UIColor colorWithRed: 62.0/255.0 green: 151.0/255.0 blue: 0.8 alpha: 1.0];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
}

-(void)setDotColor:(UIColor *)dotColor {
    if(!dotColor) {
        dotColor = [UIColor colorWithRed: 62.0/255.0 green: 151.0/255.0 blue: 0.8 alpha: 1.0];
    }
    _dotColor = dotColor;
}

-(void)updateTouch:(UITouch *)t {
    
    NSMutableSet* seenKeys = [NSMutableSet set];
    CGPoint loc = [t locationInView:self];
    NSNumber* key = [NSNumber numberWithUnsignedInteger:t.hash];
    [seenKeys addObject:key];
    
    UIView* dot = [dots objectForKey:key];
    
    if(!dot){
        dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dotWidth, _dotWidth)];
        dot.backgroundColor = _dotColor;
        dot.layer.cornerRadius = _dotWidth/2;
        dot.tag = key.unsignedIntegerValue;
        [self addSubview:dot];
        [dots setObject:dot forKey:key];
        
        UIView* anim = [[UIView alloc] initWithFrame:dot.frame];
        anim.opaque = NO;
        anim.backgroundColor = [UIColor clearColor];
        anim.layer.cornerRadius = _dotWidth/2;
        anim.layer.borderColor = _dotColor.CGColor;
        anim.layer.borderWidth = 3;
        anim.center = loc;
        anim.tag = NSUIntegerMax;
        [self addSubview:anim];
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            anim.transform = CGAffineTransformMakeScale(1.5, 1.5);
            anim.alpha = 0;
        } completion:^(BOOL finished){
            [anim removeFromSuperview];
        }];
    }
    dot.center = loc;
}

-(void)removeViewFor:(UITouch *)t {
    NSNumber* key = [NSNumber numberWithUnsignedInteger:t.hash];
    UIView* dot = [dots objectForKey:key];
    [dot removeFromSuperview];
    [dots removeObjectForKey:key];
}

-(void)didMoveToSuperview {
    [touchGesture.view removeGestureRecognizer:touchGesture];
    [self.superview addGestureRecognizer:touchGesture];
}

-(void)forTouchesBegan:(NSSet *)touches {
    NSArray* siblings = self.superview.subviews;
    if([siblings indexOfObject:self] != [siblings count]-1){
        // ensure we are the top most view
        [self.superview addSubview:self];
    }
    for(UITouch* t in touches){
        [self updateTouch:t];
    }
}

-(void)forTouchesMoved:(NSSet *)touches {
    for(UITouch* t in touches){
        [self updateTouch:t];
    }
}

-(void)forTouchesEnded:(NSSet *)touches {
    for(UITouch* t in touches){
        [self removeViewFor:t];
    }
}

-(void)forTouchesCancelled:(NSSet *)touches {
    for(UITouch* t in touches){
        [self removeViewFor:t];
    }
}

#pragma mark - Ignore Touches

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

@end


//@implementation UIWindow (tracking)
//
//- (void)startTracking {
//    FORGestureTrack *track = [[FORGestureTrack alloc] initWithFrame:self.bounds];
//    [self.window addSubview:track];
//}
//
//@end

