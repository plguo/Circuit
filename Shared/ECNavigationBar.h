//
//  ECNavigationBar.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECNavigationBarDelegate.h"

@interface ECNavigationBar : UIView<UIActionSheetDelegate>
+(instancetype)autosizeTooNavigationBarForView:(UIView*)view;
- (void)startHideAnimation;
- (void)startShowAnimation;
@property(nonatomic,weak) id<ECNavigationBarDelegate> delegate;
@end
