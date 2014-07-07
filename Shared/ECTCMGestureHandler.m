//
//  ECTCMGestureHandler.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-05.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTCMGestureHandler.h"

@implementation ECTCMGestureHandler
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview];
    if (velocity.y < 0.0){
        if (fabs((double)velocity.y) >  fabs((double)velocity.x)) {
            return YES;
        }
    }
    return NO;
}

@end
