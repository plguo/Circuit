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
        self.backgroundColor = [UIColor blackColor];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Change Form" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button sizeToFit];
        CGSize buttonSize = button.frame.size;
        CGSize boundsSize = self.bounds.size;
        button.center = CGPointMake(boundsSize.width - buttonSize.width/2, buttonSize.height/2);
        [self addSubview:button];
        
        CGFloat space = 2.0;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, buttonSize.height + space, boundsSize.width, boundsSize.height - (buttonSize.height + space))];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor blackColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [self addSubview:_textView];
    }
    return self;
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
