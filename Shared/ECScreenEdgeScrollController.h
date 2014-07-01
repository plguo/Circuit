//
//  ECScreenEdgeScrollController.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECScreenEdgeScrollController : NSObject
- (void)trackGestureRecognizer:(UIPanGestureRecognizer*)recognizer Bounds:(CGRect)bounds Location:(CGPoint)location;
@property(nonatomic, weak) UIScrollView* scrollView;
@property(nonatomic, readonly) BOOL tracking;
@end
