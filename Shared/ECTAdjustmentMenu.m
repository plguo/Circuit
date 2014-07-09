//
//  ECTAdjustmentMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-08.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTAdjustmentMenu.h"

@implementation ECTAdjustmentMenu{
    UILabel* _label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _displayTapTitle = YES;
        
        _submenuFrame = CGRectInset(self.bounds, 5, 5);
        self.backgroundColor = [UIColor blackColor];
        
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

- (void)layoutSubviews{
    if (_label) {
        _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
}

-(void)setDisplayTapTitle:(BOOL)displayTapTitle{
    if (_displayTapTitle != displayTapTitle) {
        _displayTapTitle = displayTapTitle;
        if (_displayTapTitle) {
            _label = [[UILabel alloc]init];
            _label.text = @"tap any object to get info";
            _label.textColor = [UIColor whiteColor];
            CGSize size = [_label sizeThatFits:CGSizeMake(self.bounds.size.width-4, 40)];
            _label.frame = CGRectMake(0, 0, size.width, size.height);
            
            self.frame = CGRectMake(0, 10, self.frame.size.width, size.height+4);
            
            _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            [self addSubview:_label];
        }else{
            if (_label) {
                [_label removeFromSuperview];
                _label = nil;
            }
        }
    }
}
@end
