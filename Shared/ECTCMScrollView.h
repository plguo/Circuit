//
//  ECTCMScrollView.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-07.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ECTComponentsMenuDelegate<NSObject>
- (void)handleViewFromComponentsMenu:(UIView*)view PanGestureRecognizer:(UIGestureRecognizer*)recognizer;
- (UIView*)componentsMenuViewAtIndex:(NSUInteger)index;
- (NSString*)componentsMenuTitleAtIndex:(NSUInteger)index;
- (NSUInteger)componentsMenuNumberOfViews;
@end

@interface ECTCMScrollView : UIScrollView
@property(nonatomic, weak) id<ECTComponentsMenuDelegate> menuDelegate;
@end
