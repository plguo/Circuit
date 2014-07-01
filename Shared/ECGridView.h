//
//  ECGridView.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECOverlayView.h"

@interface ECGridView : ECOverlayView
+ (instancetype)generateGridWithNumberOfVerticalLines:(NSUInteger)width HorizonLines:(NSUInteger)height;
- (CGPoint)closestPointInGridView:(CGPoint)point;

@property(nonatomic, readonly) CGFloat gridWidth;
@property(nonatomic, readonly) CGFloat marginWidth;
@end
