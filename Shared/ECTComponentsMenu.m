//
//  ECTComponentsMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTComponentsMenu.h"
#define COMPACT_HEIGHT 42.0
#define SPACE 10.0

@implementation ECTComponentsMenu{
    NSMutableArray* _viewsArray;
    
    CGFloat _maxImageHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxImageHeight = frame.size.height - 12.0;
        
        
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

+(instancetype)autosizeComponentsMenuForView:(UIView*)view{
    CGFloat height = COMPACT_HEIGHT;
    ECTComponentsMenu* menu = [[self alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view.bounds), height)];
    return menu;
}

- (void)setMenuDelegate:(id<ECTComponentsMenuDelegate>)menuDelegate{
    if (menuDelegate) {
        if (_viewsArray) {
            [_viewsArray removeAllObjects];
            _viewsArray = nil;
        }
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.contentSize = CGSizeMake(SPACE, self.frame.size.height);
        NSUInteger number = [menuDelegate componentsMenuNumberOfViews];
        _viewsArray = [NSMutableArray arrayWithCapacity:number];
        for (NSUInteger i = 0; 0 < number; i ++) {
            [self addComponentsAtIndex:i];
        }
        _menuDelegate = menuDelegate;
    }
}

-(void)addComponentsAtIndex:(NSUInteger)index{
    UIView* view = [self.menuDelegate componentsMenuViewAtIndex:index];
    NSString* title = [self.menuDelegate componentsMenuTitleAtIndex:index];
    BOOL allowRotation = [self.menuDelegate componentsMenuAllowRotationAtIndex:index];
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    panRecognizer.delaysTouchesBegan = YES;
    [view addGestureRecognizer:panRecognizer];
    CGFloat viewWidth;
    if (allowRotation && !_compactHeight && view.frame.size.width>view.frame.size.height) {
        
        CGFloat ratio = 1.0;
        
        if (view.frame.size.width > _maxImageHeight) {
            ratio = 1/(view.frame.size.width/_maxImageHeight);
            view.transform = CGAffineTransformScale(view.transform, ratio, ratio);
        }
        
        viewWidth = view.frame.size.height*ratio;
        view.transform = CGAffineTransformRotate(view.transform, M_PI + M_PI_2);
        
    }else{
        CGFloat ratio = 1.0;
        if (view.frame.size.width > _maxImageHeight) {
            ratio = 1/(view.frame.size.height/_maxImageHeight);
            
            view.transform = CGAffineTransformScale(view.transform, ratio, ratio);
        }
        viewWidth = view.frame.size.width*ratio;
    }
    view.center = CGPointMake(_maxImageHeight/2 + 2.0,self.contentSize.width + viewWidth/2);
    self.contentSize = CGSizeMake(self.contentSize.width + viewWidth + SPACE, self.contentSize.height);
    [self addSubview:view];
    [_viewsArray addObject:view];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = title;
    [label sizeToFit];
    label.center  = CGPointMake(view.center.x, self.frame.size.height - 5.0);
    [self addSubview:label];
}

-(void)handlePanFrom:(UIPanGestureRecognizer*)panGestureRecognizer{
    
}
@end
