//
//  ECGateView.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECGateView.h"

@implementation ECGateView

-(CGPoint)closestPointToSnap:(CGPoint)point{
    if (self.delegate) {
        return [self.delegate gateViewClosestPointToSnap:point];
    }
    return point;
}

@end
