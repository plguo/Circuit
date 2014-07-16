//
//  ECToolBar.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-26.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTComponentsMenu.h"
#import "ECTDeleteMode.h"
#import "ECTAdjustmentMenu.h"
#import "ECTFileMenu.h"

@protocol ECToolBarDelegate <ECTComponentsMenuDelegate,ECTDeleteModeDelegate,ECTAdjustmentMenuDelegate>

@end

@interface ECToolBar : UIView
+(instancetype)autosizeToolBarForView:(UIView*)view;
- (void)startHideAnimation;
- (void)startShowAnimation;

- (void)showSubAdjustmentMenu:(UIView*)view;
- (void)hideAdjustmentMenu;
- (CGRect)subAdjustmentMenuFrame;
@property(nonatomic,weak) id<ECToolBarDelegate> delegate;
@end
