//
//  ECOverlayView.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-30.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECOverlayView.h"

@implementation ECOverlayView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* hitView = [super hitTest:point withEvent:event];
    if ([self isEqual:hitView]) {
        return nil;
    }
    return hitView;
}

@end
