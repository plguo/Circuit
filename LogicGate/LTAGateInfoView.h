//
//  LTAGateInfoView.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-08.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTAGateInfoViewDelegate.h"

@interface LTAGateInfoView : UIView
@property(nonatomic, weak) id<LTAGateInfoViewDelegate> delegate;
- (void)loadBooleanFormula;
@property (nonatomic) NSString* title;
@end
