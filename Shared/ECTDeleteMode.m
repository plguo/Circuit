//
//  ECTDeleteMode.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-07.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTDeleteMode.h"

@implementation ECTDeleteMode{
    UILabel* _label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.902344 green:0.296875 blue:0.234375 alpha:1.0];
        
        _label = [[UILabel alloc]init];
        _label.text = @"tap any object to delete";
        _label.textColor = [UIColor whiteColor];
        CGSize size = [_label sizeThatFits:CGSizeMake(frame.size.width-4, 40)];
        _label.frame = CGRectMake(0, 0, size.width, size.height);
        
        self.frame = CGRectMake(0, 10, frame.size.width, size.height+4);
        
        _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_label];
    }
    return self;
}

+(instancetype)autosizeDeleteModeForView:(UIView*)view{
    ECTDeleteMode* deleteMode = [[self alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view.bounds), 20)];
    deleteMode.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    return deleteMode;
}
@end
