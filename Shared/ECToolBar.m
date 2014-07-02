//
//  ECToolBar.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-26.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECToolBar.h"
#define toolBarHeight 44.0

@implementation ECToolBar{
    BOOL _selected;
    NSUInteger _selectedTool;
    NSArray* _buttonsArray;
    UIView* _subMenu;
}

#pragma mark - Methods for tool bar initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set color
        self.backgroundColor = [UIColor blackColor];
        
        [self addButtons];
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

#pragma mark - Methods for set up buttons
- (void)addButtons {
    UIViewAutoresizing buttonAutoSizeMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    NSMutableArray* mutableButtonsArray = [NSMutableArray array];
    
    //Components Menu Button
    UIButton* componentsMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [componentsMenuButton addTarget:self action:@selector(tapComponentsMenuButton) forControlEvents:UIControlEventTouchUpInside];
    
    [componentsMenuButton setImage:[UIImage imageNamed:@"AddIcon"] forState:UIControlStateNormal];
    [componentsMenuButton setImage:[UIImage imageNamed:@"AddIconDark"] forState:UIControlStateSelected];
    [componentsMenuButton sizeToFit];
    
    [mutableButtonsArray addObject:componentsMenuButton];
    
    //Adjust Menu Button
    UIButton* adjustmentMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [adjustmentMenuButton addTarget:self action:@selector(tapAdjustmentMenuButton) forControlEvents:UIControlEventTouchUpInside];
    
    [adjustmentMenuButton setImage:[UIImage imageNamed:@"AdjustIcon"] forState:UIControlStateNormal];
    [adjustmentMenuButton setImage:[UIImage imageNamed:@"AdjustIconDark"] forState:UIControlStateSelected];
    [adjustmentMenuButton sizeToFit];
    
    [mutableButtonsArray addObject:adjustmentMenuButton];
    
    //Files Menu Button
    UIButton* filesMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [filesMenuButton addTarget:self action:@selector(tapFilesMenuButton) forControlEvents:UIControlEventTouchUpInside];
    
    [filesMenuButton setImage:[UIImage imageNamed:@"FileIcon"] forState:UIControlStateNormal];
    [filesMenuButton setImage:[UIImage imageNamed:@"FileIconDark"] forState:UIControlStateSelected];
    [filesMenuButton sizeToFit];
    
    [mutableButtonsArray addObject:filesMenuButton];
    
    //Delete Menu Button
    UIButton* deleteModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteModeButton addTarget:self action:@selector(tapDeleteModeButton) forControlEvents:UIControlEventTouchUpInside];
    
    [deleteModeButton setImage:[UIImage imageNamed:@"DeleteIcon"] forState:UIControlStateNormal];
    [deleteModeButton setImage:[UIImage imageNamed:@"DeleteIconDark"] forState:UIControlStateSelected];
    [deleteModeButton sizeToFit];
    
    [mutableButtonsArray addObject:deleteModeButton];
    
    //Iteration of buttons
    _buttonsArray = [NSArray arrayWithArray:mutableButtonsArray];
    CGFloat space = self.frame.size.width / _buttonsArray.count;
    CGFloat x = space/2;
    CGFloat y = self.frame.size.height / 2;
    for (UIButton* button in _buttonsArray) {
        [button sizeToFit];
        button.center = CGPointMake(x, y);
        button.autoresizingMask = buttonAutoSizeMask;
        [self addSubview:button];
        x += space;
    }
}

#pragma mark - Tap buttons
- (void)tapComponentsMenuButton{
    [self selectButtonAtIndex:0];
}

- (void)tapAdjustmentMenuButton{
    [self selectButtonAtIndex:1];
}

- (void)tapFilesMenuButton{
    [self selectButtonAtIndex:2];
}

- (void)tapDeleteModeButton{
    [self selectButtonAtIndex:3];
}



#pragma mark - Show Menus
- (void)showComponentsMenu{
    if (self.delegate) {
        ECTComponentsMenu* menu = [ECTComponentsMenu autosizeComponentsMenuForView:self];
        menu.frame = CGRectMake(0, self.frame.origin.y, menu.frame.size.width, menu.frame.size.height);
        [self.superview insertSubview:menu belowSubview:self];
        menu.menuDelegate = self.delegate;
        CGPoint newCenter = CGPointMake(menu.center.x, menu.center.y - CGRectGetHeight(menu.frame));
        [UIView animateWithDuration:0.3 animations:^{
            menu.center = newCenter;
        }];
        _subMenu = menu;
    }
}

- (void)showAdjustmentMenu{
    
}

- (void)showFilesMenu{
    
}

- (void)showDeleteMode{
    
}


#pragma mark - Hide Menus
- (void)hideTool:(NSUInteger)index{
    switch (index) {
        case 0:
            [self hideComponentsMenu];
            break;
        
        case 1:
            [self hideAdjustmentMenu];
            break;
        
        case 2:
            [self hideFilesMenu];
            break;
            
        case 3:
            [self hideDeleteMode];
            break;
            
        default:
            break;
    }
}

- (void)showMenu:(NSUInteger)index{
    switch (index) {
        case 0:
            [self showComponentsMenu];
            break;
            
        case 1:
            [self showAdjustmentMenu];
            break;
            
        case 2:
            [self showFilesMenu];
            break;
            
        case 3:
            [self showDeleteMode];
            break;
            
        default:
            break;
    }
}
    
- (void)hideComponentsMenu{
    UIButton* button =  _buttonsArray[0];
    button.selected = NO;
    CGPoint center = CGPointMake(_subMenu.center.x, _subMenu.center.y + CGRectGetHeight(_subMenu.frame));
    [UIView animateWithDuration:0.3 animations:^{
        _subMenu.center = center;
    } completion:^(BOOL finished) {
        [_subMenu.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_subMenu removeFromSuperview];
    }];
    _subMenu = nil;
}

- (void)hideAdjustmentMenu{
    UIButton* button =  _buttonsArray[1];
    button.selected = NO;
}

- (void)hideFilesMenu{
    UIButton* button =  _buttonsArray[2];
    button.selected = NO;
}

- (void)hideDeleteMode{
    UIButton* button =  _buttonsArray[3];
    button.selected = NO;
}

#pragma mark - Selected New Image
- (void)selectButtonAtIndex:(NSUInteger)index{
    if (_selected) {
        //Deseclect pervious button and peform other hiding actions
        [self hideTool:_selectedTool];
        //If itself is pervious button, then cancel and no select any buttons
        if (_selectedTool == index) {
            _selected = NO;
            return;
        }
    }
    _selected = YES;
    _selectedTool = index;
    UIButton* button =  _buttonsArray[index];
    button.selected = YES;
    [self showMenu:index];
}

#pragma mark - Animation
- (void)startHideAnimation{
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)startShowAnimation{
    self.hidden = NO;
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y - self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
@end
