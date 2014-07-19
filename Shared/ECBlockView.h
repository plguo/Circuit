//
//  ECBlockView.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-19.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECBlockView : UIView
+ (instancetype)blockView;
- (void)showOnView:(UIView*)view;
- (void)dismiss;
@property(nonatomic) NSString* title;
@end
