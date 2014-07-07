//
//  ECTComponentsMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTComponentsMenu.h"
#define BorderHeight 10
#define ScrollViewHeight 60

@implementation ECTComponentsMenu
#pragma mark - Methods for initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* borderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), BorderHeight)];
        borderView.backgroundColor = [UIColor blackColor];
        borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:borderView];
        
        ECTCMScrollView* scrollView = [[ECTCMScrollView alloc]initWithFrame:CGRectMake(0, BorderHeight, CGRectGetWidth(self.bounds), ScrollViewHeight)];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return self;
}

+(instancetype)autosizeComponentsMenuForView:(UIView*)view{
    ECTComponentsMenu* menu = [[self alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view.bounds), ScrollViewHeight + BorderHeight)];
    menu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    return menu;
}

@end
