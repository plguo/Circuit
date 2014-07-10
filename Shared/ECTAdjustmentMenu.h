//
//  ECTAdjustmentMenu.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-08.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECTAdjustmentMenu;
@protocol ECTAdjustmentMenuDelegate <NSObject>
-(void)adjustmentMenuModeChangeTo:(BOOL)adjustmentMenuMode;
@end

@interface ECTAdjustmentMenu : UIView
@property(nonatomic) BOOL displayTapTitle;

+(instancetype)autosizeAdjustmentMenuForView:(UIView*)view;
- (void)addSubMenu:(UIView*)view;
@end
