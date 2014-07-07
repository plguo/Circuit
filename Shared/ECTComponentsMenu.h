//
//  ECTComponentsMenu.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTCMScrollView.h"


@interface ECTComponentsMenu : UIView

+(instancetype)autosizeComponentsMenuForView:(UIView*)view;
@property(readonly,nonatomic) ECTCMScrollView* scrollView;
@end
