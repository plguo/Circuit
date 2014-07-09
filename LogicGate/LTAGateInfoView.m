//
//  LTAGateInfoView.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-08.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LTAGateInfoView.h"

@implementation LTAGateInfoView{
    UITextView* _textView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Switch Form" forState:UIControlStateNormal];
        [button sizeToFit];
        CGSize buttonSize = button.frame.size;
        CGSize boundsSize = self.bounds.size;
        button.center = CGPointMake(boundsSize.width - buttonSize.width/2, boundsSize.height - buttonSize.height/2);
        [self addSubview:button];
        
        CGFloat space = 10.0;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, buttonSize.height + space, boundsSize.width, boundsSize.height - (buttonSize.height + space))];
        [self addSubview:_textView];
        
        
    }
    return self;
}

@end
