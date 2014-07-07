//
//  ECTDeleteMode.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-07.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ECTDeleteModeDelegate<NSObject>
-(void)deleteModeChangeTo:(BOOL)allowDelete;
@end;
@interface ECTDeleteMode : UIView
+(instancetype)autosizeDeleteModeForView:(UIView*)view;
@end
