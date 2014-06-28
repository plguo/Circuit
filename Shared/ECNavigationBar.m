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
        self.backgroundColor = [UIColor blackColor];
        
        // Add Hide Button
        UIButton* hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [hideButton setImage:[UIImage imageNamed:@"HideIcon"] forState:UIControlStateNormal];
        [hideButton sizeToFit];
        hideButton.center = CGPointMake((self.bounds.size.width - hideButton.frame.size.width/2 - 5),
                                        self.bounds.size.height/2);
        hideButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [hideButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
    }
    return self;
}

+(instancetype)autosizeTooNavigationBarForView:(UIView*)view{
    ECNavigationBar* autosizeNavigationBar = [[ECNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), navigationBarHeight)];
    
    //Autosizing property
    autosizeNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    
    //Return autosizing tool bar
    return autosizeNavigationBar;
}


#pragma mark - Handle buttons event
- (void)hideMenu{
    if (self.delegate) {
        [self.delegate hideMenu];
    }
}

#pragma mark - Animation
- (void)startHideAnimation{
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y - self.frame.size.height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)startShowAnimation{
    self.hidden = NO;
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

@end
