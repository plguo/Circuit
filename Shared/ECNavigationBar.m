//
//  ECNavigationBar.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECNavigationBar.h"
#import "ECFileTableView.h"
#define navigationBarHeight 44.0

@implementation ECNavigationBar{
    UIButton* _menuButton;
}

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
        
        // Add Menu Button
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuButton setImage:[UIImage imageNamed:@"MenuIcon"] forState:UIControlStateNormal];
        [_menuButton sizeToFit];
        _menuButton.center = CGPointMake(5 + _menuButton.frame.size.width/2, self.bounds.size.height/2);
        _menuButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [_menuButton addTarget:self action:@selector(moreMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_menuButton];
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

- (void)moreMenu{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New",@"Open", nil];
    [actionSheet showFromRect:_menuButton.frame inView:self animated:YES];
    
    
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.delegate) {
            [self.delegate newMap];
        }
    }else if(buttonIndex == 1){
        ECFileTableView* view = [[ECFileTableView alloc] initWithFrame:self.superview.frame];
        [self.superview addSubview:view];
    }
}

@end
