//
//  ECTComponentsMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTComponentsMenu.h"
//#define COMPACT_HEIGHT 42.0
#define SPACE 10.0

@implementation ECTComponentsMenu{
    NSMutableArray* _viewsArray;
    
    CGFloat _maxImageHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxImageHeight = frame.size.height - 22.0;
        
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceHorizontal = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([otherGestureRecognizer isEqual:self.panGestureRecognizer]) {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer* panGestureRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
            CGPoint translation = [panGestureRecognizer translationInView:self];
            if (fabs((double)translation.y)> 6.0) {
                return NO;
            }
        }
        
    }
    return YES;
}

+(instancetype)autosizeComponentsMenuForView:(UIView*)view{
    CGFloat height = 60;
    ECTComponentsMenu* menu = [[self alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view.bounds), height)];
    return menu;
}

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
        for (NSUInteger i = 0; i < number; i ++) {
            [self addComponentsAtIndex:i];
        }
        
    }
}

-(void)addComponentsAtIndex:(NSUInteger)index{
    if (self.menuDelegate) {
        UIView* view = [self.menuDelegate componentsMenuViewAtIndex:index];
        NSString* title = [self.menuDelegate componentsMenuTitleAtIndex:index];
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        panRecognizer.delegate = self;
        panRecognizer.delaysTouchesBegan = YES;
        [view addGestureRecognizer:panRecognizer];
        
        CGFloat viewWidth;
        
        CGFloat ratio = 1.0;
        if (view.frame.size.height > _maxImageHeight) {
            ratio = 1/(view.frame.size.height/_maxImageHeight);
            
            view.transform = CGAffineTransformScale(view.transform, ratio, ratio);
        }
        viewWidth = view.frame.size.width*ratio;
        
        view.center = CGPointMake(self.contentSize.width + viewWidth/2,_maxImageHeight/2 + 2.0);
        self.contentSize = CGSizeMake(self.contentSize.width + viewWidth + SPACE, self.contentSize.height);
        [self addSubview:view];
        [_viewsArray setObject:view atIndexedSubscript:index];
        
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:10];
        label.text = title;
        [label sizeToFit];
        label.center  = CGPointMake(view.center.x, self.frame.size.height - 10.0);
        [self addSubview:label];
    }
}

-(void)handlePanFrom:(UIPanGestureRecognizer*)panGestureRecognizer{
    
}
@end
