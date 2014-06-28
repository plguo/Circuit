//
//  ECToolBar.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-26.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECToolBar : UIView
+(instancetype)autosizeToolBarForView:(UIView*)view;
- (void)startHideAnimation;
- (void)startShowAnimation;
@end
