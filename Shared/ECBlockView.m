//
//  ECBlockView.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-19.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECBlockView.h"
static ECBlockView* sharedBlockView;
@implementation ECBlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = @"Waiting";
        
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake( CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds) - CGRectGetHeight(activityIndicator.frame)/2 - 4.0);
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
        
        UILabel* label = [[UILabel alloc] init];
        label.text = self.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.center = CGPointMake( CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds) + CGRectGetHeight(label.frame)/2 + 4.0);
        [self addSubview:label];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

+ (instancetype)blockView{
    if (!sharedBlockView) {
        sharedBlockView = [[self alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 40.0)];
    }
    return sharedBlockView;
}

- (void)showOnView:(UIView*)view{
    self.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    [view addSubview:self];
}

- (void)dismiss{
    if (self.superview) {
        sharedBlockView = nil;
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self;
}

@end
