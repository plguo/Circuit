//
//  ECTComponentsMenu.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECTComponentsMenu;
@protocol ECTComponentsMenuDelegate<NSObject>
- (void)handleViewFromComponentsMenu:(UIView*)view PanGestureRecognizer:(UIGestureRecognizer*)recognizer;
- (UIView*)componentsMenuViewAtIndex:(NSUInteger)index;
- (NSString*)componentsMenuTitleAtIndex:(NSUInteger)index;
- (NSUInteger)componentsMenuNumberOfViews;
@end

@interface ECTComponentsMenu : UIScrollView<UIGestureRecognizerDelegate>
+(instancetype)autosizeComponentsMenuForView:(UIView*)view;
@property(nonatomic, weak) id<ECTComponentsMenuDelegate> menuDelegate;
@end
