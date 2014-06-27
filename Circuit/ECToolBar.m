//
//  ECToolBar.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-26.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECToolBar.h"
#define toolBarHeight 44.0

@implementation ECToolBar

#pragma mark - Methods for tool bar initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set color
        self.backgroundColor = [UIColor blackColor];
        
        [self setupButtons];
    }
    return self;
}

+(instancetype)autosizeToolBarForView:(UIView*)view{
    ECToolBar* autosizeToolBar = [[ECToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame) - toolBarHeight, CGRectGetWidth(view.frame), toolBarHeight)];
    
    //Autosizing property
    autosizeToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    //Return autosizing tool bar
    return autosizeToolBar;
}

#pragma mark - Methods for set up view
- (void)setupButtons {
    UIViewAutoresizing buttonAutoSizeMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    NSMutableArray* buttonsArray = [NSMutableArray array];
    
    //Components Menu Button
    UIButton* componentsMenuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [componentsMenuButton setTitle:@"Add" forState:UIControlStateNormal];
    [componentsMenuButton addTarget:self action:@selector(showComponentsMenu) forControlEvents:UIControlEventTouchUpInside];
    [buttonsArray addObject:componentsMenuButton];
    
    //Adjust Menu Button
    UIButton* adjustmentMenuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [adjustmentMenuButton setTitle:@"Adjust" forState:UIControlStateNormal];
    [buttonsArray addObject:adjustmentMenuButton];
    
    //Data Menu Button
    UIButton* dataMenuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [dataMenuButton setTitle:@"Data" forState:UIControlStateNormal];
    [buttonsArray addObject:dataMenuButton];
    
    //Files Menu Button
    UIButton* filesMenuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [filesMenuButton setTitle:@"Files" forState:UIControlStateNormal];
    //[filesMenuButton addTarget:self action:@selector(showComponentsMenu) forControlEvents:UIControlEventTouchUpInside];
    [buttonsArray addObject:filesMenuButton];
    
    //Adjust Menu Button
    UIButton* additionalMenuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [additionalMenuButton setTitle:@"Menu" forState:UIControlStateNormal];
    [buttonsArray addObject:additionalMenuButton];
    
    //Iteration of buttons
    CGFloat space = self.frame.size.width / buttonsArray.count;
    CGFloat x = space/2;
    CGFloat y = self.frame.size.height / 2;
    for (UIButton* button in buttonsArray) {
        [button sizeToFit];
        button.center = CGPointMake(x, y);
        button.autoresizingMask = buttonAutoSizeMask;
        [self addSubview:button];
        x += space;
    }
}

#pragma mark - Handling touch event from buttons
- (void)showComponentsMenu{
    
}

@end
