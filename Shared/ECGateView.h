//
//  ECGateView.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECOverlayView.h"
@class ECGateView;
@protocol ECGateViewDelegate <NSObject>

- (CGPoint)gateViewClosestPointToSnap:(CGPoint)point;

@end
@interface ECGateView : ECOverlayView
- (CGPoint)closestPointToSnap:(CGPoint)point;
@property(nonatomic,weak) id<ECGateViewDelegate> delegate;
@end
