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
    UILabel* _label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _title = @"Gate";
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Format" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button sizeToFit];
        CGSize buttonSize = button.frame.size;
        CGSize boundsSize = self.bounds.size;
        
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        button.center = CGPointMake(boundsSize.width - buttonSize.width/2, buttonSize.height/2);
        [self addSubview:button];
        
        _label = [[UILabel alloc] init];
        _label.text = self.title;
        _label.textColor = [UIColor whiteColor];
        _label.font = button.titleLabel.font;
        _label.textAlignment = NSTextAlignmentCenter;
        
        [_label sizeToFit];
        _label.center = CGPointMake(_label.center.x, button.center.y);
        [self addSubview:_label];
        
        CGFloat space = 2.0;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, buttonSize.height + space, boundsSize.width, boundsSize.height - (buttonSize.height + space))];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [self addSubview:_textView];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _label.text = _title;
    [_label sizeToFit];
}

- (void)setDelegate:(id<LTAGateInfoViewDelegate>)delegate{
    if (delegate) {
        _delegate = delegate;
        [self performSelectorInBackground:@selector(loadBooleanFormula) withObject:nil];
    }
}

- (void)loadBooleanFormula{
    if (self.delegate) {
        NSString* string = [self.delegate booleanFormula];
        [_textView performSelectorOnMainThread:@selector(setText:) withObject:string waitUntilDone:NO];
    }
}
@end
