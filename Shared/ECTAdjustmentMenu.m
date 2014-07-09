//
//  ECTAdjustmentMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-08.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTAdjustmentMenu.h"
#define MARGIN 5.0

@implementation ECTAdjustmentMenu{
    UILabel* _label;
    UIView* _subMenu;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _displayTapTitle = YES;
    
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        _label = [[UILabel alloc]init];
        _label.text = @"tap any object to get info";
        _label.textColor = [UIColor whiteColor];
        CGSize size = [_label sizeThatFits:CGSizeMake(frame.size.width-4, 40)];
        _label.frame = CGRectMake(0, 0, size.width, size.height);
        
        self.frame = CGRectMake(0, 10, frame.size.width, size.height+4);
        
        _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:_label];
    }
    return self;
}

+(instancetype)autosizeAdjustmentMenuForView:(UIView*)view{
    ECTAdjustmentMenu* menu = [[self alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view.bounds), 20.0)];
    menu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    return menu;
}

-(CGRect)subMenuFrame{
    return CGRectInset(CGRectMake(0.0, 0.0,CGRectGetWidth(self.bounds), 120.0), MARGIN, MARGIN);
}

- (void)layoutSubviews{
    if (_label) {
        _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
}

-(void)setDisplayTapTitle:(BOOL)displayTapTitle{
    if (_displayTapTitle != displayTapTitle) {
        _displayTapTitle = displayTapTitle;
        if (_displayTapTitle) {
            self.frame = CGRectMake(0, 10, self.frame.size.width, _label.frame.size.height+4);
            _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            [self addSubview:_label];
        }else{
            if (_label) {
                [_label removeFromSuperview];
            }
        }
    }
}

-(void)addSubMenu:(UIView *)view{
    if (view) {
        self.displayTapTitle = NO;
        CGFloat viewHeight = CGRectGetHeight(view.frame)+ MARGIN * 2;
        CGRect frame = CGRectMake(0,self.frame.origin.y - (viewHeight - CGRectGetHeight(self.frame)), CGRectGetWidth(self.frame), viewHeight);
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
        if (_subMenu) {
            [_subMenu removeFromSuperview];
            _subMenu = nil;
        }
        _subMenu = view;
        [self addSubview:view];
        
    }
}
@end
