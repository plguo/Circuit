//
//  ECNavigationBar.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECNavigationBar.h"
#define navigationBarHeight 44.0

@implementation ECNavigationBar

#pragma mark - Methods for navigation bar initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set color
        self.barStyle = UIBarStyleBlackOpaque;
        self.translucent = NO;
    }
    return self;
}

+(instancetype)autosizeTooNavigationBarForView:(UIView*)view{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    ECNavigationBar* autosizeNavigationBar = [[ECNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), navigationBarHeight + statusBarHeight)];
    
    //Autosizing property
    autosizeNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    
    //Return autosizing tool bar
    return autosizeNavigationBar;
}


@end
