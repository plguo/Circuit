//
//  LTAInputInfoView.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTAInputInfoViewDelegate.h"

@interface LTAInputInfoView : UIView
@property(nonatomic,weak) id<LTAInputInfoViewDelegate> delegate;
@end
