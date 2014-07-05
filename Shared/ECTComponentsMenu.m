//
//  ECTComponentsMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTComponentsMenu.h"
#import "ECTCMGestureHandler.h"
#define SPACE 10.0

@implementation ECTComponentsMenu{
    NSMutableArray* _viewsArray;
    NSMutableArray* _infoArray;
    CGFloat _maxImageHeight;
    
    ECTCMGestureHandler* _gestureHandler;
}

#pragma mark - Methods for initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxImageHeight = frame.size.height - 22.0;
        _gestureHandler = [[ECTCMGestureHandler alloc] init];
        
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        self.alwaysBounceHorizontal = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

+(instancetype)autosizeComponentsMenuForView:(UIView*)view{
    ECTComponentsMenu* menu = [[self alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view.bounds), 60)];
    menu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    return menu;
}

#pragma mark - Set ECTComponentsMenuDelegate
- (void)setMenuDelegate:(id<ECTComponentsMenuDelegate>)menuDelegate{
    if (menuDelegate) {
        _menuDelegate = menuDelegate;
        if (_viewsArray) {
            [_viewsArray removeAllObjects];
            _viewsArray = nil;
        }
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.contentSize = CGSizeMake(SPACE, self.frame.size.height);
        NSUInteger number = [_menuDelegate componentsMenuNumberOfViews];
        _viewsArray = [NSMutableArray arrayWithCapacity:number];
        _infoArray = [NSMutableArray arrayWithCapacity:number];
        for (NSUInteger i = 0; i < number; i ++) {
            [self addComponentsAtIndex:i];
        }
        
    }
}

#pragma mark - Add new component
-(void)addComponentsAtIndex:(NSUInteger)index{
    if (self.menuDelegate) {
        UIView* view = [self.menuDelegate componentsMenuViewAtIndex:index];//Get the view
        NSString* title = [self.menuDelegate componentsMenuTitleAtIndex:index];//Get the title
        
        //Add UIPanGestureRecognizer to Subview
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        panRecognizer.delegate = _gestureHandler;
        panRecognizer.delaysTouchesBegan = YES;
        [view addGestureRecognizer:panRecognizer];
        
        
        //Resize view to fit the height
        CGFloat viewWidth;
        
        CGFloat ratio = 1.0;
        if (view.frame.size.height > _maxImageHeight) {
            ratio = 1/(view.frame.size.height/_maxImageHeight);
            
            view.transform = CGAffineTransformScale(view.transform, ratio, ratio);
        }
        viewWidth = view.frame.size.width*ratio;
        
        //Set the label/title
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:10];
        label.text = title;
        [label sizeToFit];
        
        //Choose the largest width for the width
        viewWidth = MAX(viewWidth, label.frame.size.width);
        
        //Set the center
        view.center = CGPointMake(self.contentSize.width + viewWidth/2,_maxImageHeight/2 + 2.0);
        label.center  = CGPointMake(view.center.x, self.frame.size.height - 10.0);
        
        //Resize scroll view content size
        self.contentSize = CGSizeMake(self.contentSize.width + viewWidth + SPACE, self.contentSize.height);
        
        [self addSubview:view];
        [self addSubview:label];
        
        //Store reuseable information
        [_viewsArray setObject:view atIndexedSubscript:index];
        
        NSDictionary* info = @{@"centerX":[NSNumber numberWithDouble:(double)view.center.x],
                               @"centerY":[NSNumber numberWithDouble:(double)view.center.y],
                               @"ratio":[NSNumber numberWithDouble:(double)ratio]};
        
        [_infoArray setObject:info atIndexedSubscript:index];
    }
}

#pragma mark - Fill empty component
-(void)recreateComponentsAtIndex:(NSUInteger)index{
    UIView* view = [self.menuDelegate componentsMenuViewAtIndex:index];
    NSDictionary* info = [_infoArray objectAtIndex:index];
    
    NSNumber* centerNumX = info[@"centerX"];
    NSNumber* centerNumY = info[@"centerY"];
    CGFloat ratio = (double)[(NSNumber*)info[@"ratio"] doubleValue];
    view.transform = CGAffineTransformMakeScale(ratio, ratio);
    view.center = CGPointMake((CGFloat)[centerNumX doubleValue], (CGFloat)[centerNumY doubleValue]);
    view.alpha = 0.0;
    [self addSubview:view];
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 1.0;
    }];
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    panRecognizer.delegate = _gestureHandler;
    panRecognizer.delaysTouchesBegan = YES;
    [view addGestureRecognizer:panRecognizer];
    
    [_viewsArray replaceObjectAtIndex:index withObject:view];
}

#pragma mark - Handle UIPanGestureRecognizer
-(void)handlePanFrom:(UIPanGestureRecognizer*)recognizer{
    UIView* view = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        view.center = [self convertPoint:view.center toView:self.superview];
        [self.superview addSubview:view];
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(1.2, 1.2);
            view.center = [recognizer locationInView:view.superview];
            view.alpha = 0.7;
        } completion:^(BOOL finished) {
            if (!finished) {
                view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                view.alpha = 0.7;
            }
        }];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        view.center = [recognizer locationInView:view.superview];
        if (!CGRectContainsPoint(self.frame,
                                 CGPointMake(CGRectGetMidX(view.frame), CGRectGetMaxY(view.frame))))
        {
            [recognizer removeTarget:self action:@selector(handlePanFrom:)];
            recognizer.delegate = nil;
            recognizer.delaysTouchesBegan = NO;
            [view.layer removeAllAnimations];
            [self.menuDelegate handleViewFromComponentsMenu:view PanGestureRecognizer:recognizer];
            NSUInteger index = [_viewsArray indexOfObject:view];
            [_viewsArray replaceObjectAtIndex:index withObject:[NSNull null]];
            [self recreateComponentsAtIndex:index];
        }
    }else{
        NSDictionary* info = [_infoArray objectAtIndex:[_viewsArray indexOfObject:view]];
        NSNumber* centerNumX = info[@"centerX"];
        NSNumber* centerNumY = info[@"centerY"];
        CGFloat ratio = (double)[(NSNumber*)info[@"ratio"] doubleValue];
        CGPoint oldCenter = CGPointMake((CGFloat)[centerNumX doubleValue], (CGFloat)[centerNumY doubleValue]);
        
        CGPoint viewCenter = [self convertPoint:oldCenter toView:self.superview.superview];
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(ratio, ratio);
            view.center = viewCenter;
            view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self addSubview:view];
            view.center = oldCenter;
        }];
        
    }
}
-(void)dealloc{
    [_viewsArray removeAllObjects];
    [_infoArray removeAllObjects];
}

@end
