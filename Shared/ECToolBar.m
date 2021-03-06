//
//  ECToolBar.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-26.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECToolBar.h"

#define toolBarHeight 44.0

static NSString*const kSubMemuAppealing = @"A";
static NSString*const kSubMemuShowing = @"S";
static NSString*const kSubMemuDisappealing = @"D";
static NSString*const kSubMemuHiding = @"H";


@implementation ECToolBar{
    BOOL _selected;
    NSUInteger _selectedTool;
    NSArray* _buttonsArray;
    NSMutableArray* _menuStateArray;
    
    NSPointerArray* _menuArray;
    
}

#pragma mark - Methods for tool bar initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set color
        self.backgroundColor = [UIColor blackColor];
        
        [self addButtons];
        
        _menuStateArray = [NSMutableArray arrayWithObjects:kSubMemuHiding,kSubMemuHiding,kSubMemuHiding,kSubMemuHiding,nil];
        _menuArray = [NSPointerArray weakObjectsPointerArray];
        
        //Add four nil Pointers
        [_menuArray addPointer:nil];
        [_menuArray addPointer:nil];
        [_menuArray addPointer:nil];
        [_menuArray addPointer:nil];
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
    
    [componentsMenuButton addTarget:self action:@selector(tapComponentsMenuButton)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [componentsMenuButton setImage:[UIImage imageNamed:@"AddIcon"] forState:UIControlStateNormal];
    [componentsMenuButton setImage:[UIImage imageNamed:@"AddIconDark"] forState:UIControlStateSelected];
    [componentsMenuButton sizeToFit];
    
    [mutableButtonsArray addObject:componentsMenuButton];
    
    //Adjust Menu Button
    UIButton* adjustmentMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [adjustmentMenuButton addTarget:self action:@selector(tapAdjustmentMenuButton)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [adjustmentMenuButton setImage:[UIImage imageNamed:@"AdjustIcon"] forState:UIControlStateNormal];
    [adjustmentMenuButton setImage:[UIImage imageNamed:@"AdjustIconDark"] forState:UIControlStateSelected];
    
    [mutableButtonsArray addObject:adjustmentMenuButton];
    
    //Files Menu Button
    UIButton* filesMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [filesMenuButton addTarget:self action:@selector(tapFilesMenuButton)
              forControlEvents:UIControlEventTouchUpInside];
    
    [filesMenuButton setImage:[UIImage imageNamed:@"FileIcon"] forState:UIControlStateNormal];
    [filesMenuButton setImage:[UIImage imageNamed:@"FileIconDark"] forState:UIControlStateSelected];
    
    [mutableButtonsArray addObject:filesMenuButton];
    
    //Delete Menu Button
    UIButton* deleteModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteModeButton addTarget:self action:@selector(tapDeleteModeButton)
               forControlEvents:UIControlEventTouchUpInside];
    
    [deleteModeButton setImage:[UIImage imageNamed:@"DeleteIcon"] forState:UIControlStateNormal];
    [deleteModeButton setImage:[UIImage imageNamed:@"DeleteIconDark"] forState:UIControlStateSelected];
    
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
    UIView* componentsMenu = (UIView*)[_menuArray pointerAtIndex:0];
    if (self.delegate && !componentsMenu) {
        _menuStateArray[0] = kSubMemuAppealing;
        ECTComponentsMenu* menu = [ECTComponentsMenu autosizeComponentsMenuForView:self];
        menu.frame = CGRectMake(0, self.frame.origin.y, menu.frame.size.width, menu.frame.size.height);
        [self.superview insertSubview:menu belowSubview:self];
        menu.scrollView.menuDelegate = self.delegate;
        CGPoint newCenter = CGPointMake(menu.center.x, menu.center.y - CGRectGetHeight(menu.frame));
        [UIView animateWithDuration:0.3 animations:^{
            menu.center = newCenter;
        }completion:^(BOOL finished) {
            _menuStateArray[0] = kSubMemuShowing;
        }];
        [_menuArray replacePointerAtIndex:0 withPointer:(__bridge void *)(menu)];
    }
}

- (void)showAdjustmentMenu{
    UIView* adjustmentMenu = (UIView*)[_menuArray pointerAtIndex:1];
    if (self.delegate && !adjustmentMenu) {
        _menuStateArray[1] = kSubMemuAppealing;
        ECTAdjustmentMenu* menu = [ECTAdjustmentMenu autosizeAdjustmentMenuForView:self];
        
        menu.frame = CGRectMake(0, self.frame.origin.y, menu.frame.size.width, menu.frame.size.height);
        [self.superview insertSubview:menu belowSubview:self];
        
        CGPoint newCenter = CGPointMake(menu.center.x, menu.center.y - CGRectGetHeight(menu.frame));
        [UIView animateWithDuration:0.3 animations:^{
            menu.center = newCenter;
        }completion:^(BOOL finished) {
            _menuStateArray[1] = kSubMemuShowing;
            if (self.delegate) {
                [self.delegate adjustmentMenuModeChangeTo:YES];
            }
        }];
        [_menuArray replacePointerAtIndex:1 withPointer:(__bridge void *)(menu)];
    }
}

- (void)showFilesMenu{
    UIView* fileMenu = (UIView*)[_menuArray pointerAtIndex:2];
    if (self.delegate && !fileMenu) {
        _menuStateArray[2] = kSubMemuAppealing;
        ECTFileMenu* menu = [ECTFileMenu autosizeFileMenuForView:self];
        
        menu.frame = CGRectMake(0, self.frame.origin.y, menu.frame.size.width, menu.frame.size.height);
        [self.superview insertSubview:menu belowSubview:self];
        
        if (self.fileMenuDataSource) {
            menu.collectionView.dataSource = self.fileMenuDataSource;
            [self.fileMenuDataSource setFetchedResultsControllerDelegate:menu];
        }
        
        
        CGPoint newCenter = CGPointMake(menu.center.x, menu.center.y - CGRectGetHeight(menu.frame));
        [UIView animateWithDuration:0.3 animations:^{
            menu.center = newCenter;
        }completion:^(BOOL finished) {
            _menuStateArray[2] = kSubMemuShowing;
            menu.delegate = self.delegate;
        }];
        [_menuArray replacePointerAtIndex:2 withPointer:(__bridge void *)(menu)];
    }
}

- (void)showDeleteMode{
    UIView* deleteMode = (UIView*)[_menuArray pointerAtIndex:3];
    if (!deleteMode) {
        _menuStateArray[3] = kSubMemuAppealing;
        
        ECTDeleteMode* menu = [ECTDeleteMode autosizeDeleteModeForView:self];
        menu.frame = CGRectMake(0, self.frame.origin.y, menu.frame.size.width, menu.frame.size.height);
        
        [self.superview insertSubview:menu belowSubview:self];
        CGPoint newCenter = CGPointMake(menu.center.x, menu.center.y - CGRectGetHeight(menu.frame));
        [UIView animateWithDuration:0.3 animations:^{
            menu.center = newCenter;
        }completion:^(BOOL finished) {
            _menuStateArray[3] = kSubMemuShowing;
        }];
        [_menuArray replacePointerAtIndex:3 withPointer:(__bridge void *)(menu)];
        if (self.delegate) {
            [self.delegate deleteModeChangeTo:YES];
        }
    }
}


#pragma mark - Hide Menus
- (void)hideTool:(NSUInteger)index BehideBar:(BOOL)behideBar{
    
    UIButton* button =  _buttonsArray[index];
    button.selected = NO;

    switch (index) {
        case 0:
            [self hideComponentsMenuBehideBar:behideBar];
            break;
        
        case 1:
            [self hideAdjustmentMenuBehideBar:behideBar];
            break;
        
        case 2:
            [self hideFilesMenuBehideBar:behideBar];
            break;
            
        case 3:
            [self hideDeleteModeBehideBar:behideBar];
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
    
- (void)hideComponentsMenuBehideBar:(BOOL)behideBar{
    _menuStateArray[0] = kSubMemuDisappealing;
    UIView* componentsMenu = (UIView*)[_menuArray pointerAtIndex:0];
    if (componentsMenu) {
        CGPoint center = CGPointMake(componentsMenu.center.x, componentsMenu.center.y + CGRectGetHeight(componentsMenu.frame));
        if (!behideBar) {
            center.y = self.superview.frame.size.height + componentsMenu.frame.size.height/2;
        }
        [UIView animateWithDuration:0.3 animations:^{
            componentsMenu.center = center;
        } completion:^(BOOL finished) {
            [componentsMenu removeFromSuperview];
            _menuStateArray[0] = kSubMemuHiding;
        }];
    }
    
}

- (void)hideAdjustmentMenuBehideBar:(BOOL)behideBar{
    _menuStateArray[1] = kSubMemuDisappealing;
    UIView* adjustmentMenu = (UIView*)[_menuArray pointerAtIndex:1];
    if (adjustmentMenu) {
        if (self.delegate) {
            [self.delegate adjustmentMenuModeChangeTo:NO];
        }
        CGPoint center = CGPointMake(adjustmentMenu.center.x, adjustmentMenu.center.y + CGRectGetHeight(adjustmentMenu.frame));
        if (!behideBar) {
            center.y = self.superview.frame.size.height + adjustmentMenu.frame.size.height/2;
        }
        [UIView animateWithDuration:0.3 animations:^{
            adjustmentMenu.center = center;
        } completion:^(BOOL finished) {
            [adjustmentMenu removeFromSuperview];
            _menuStateArray[1] = kSubMemuHiding;
        }];
    }
}

- (void)hideFilesMenuBehideBar:(BOOL)behideBar{
    _menuStateArray[2] = kSubMemuDisappealing;
    UIView* fileMenu = (UIView*)[_menuArray pointerAtIndex:2];
    if (fileMenu) {
        CGPoint center = CGPointMake(fileMenu.center.x, fileMenu.center.y + CGRectGetHeight(fileMenu.frame));
        if (!behideBar) {
            center.y = self.superview.frame.size.height + fileMenu.frame.size.height/2;
        }
        [UIView animateWithDuration:0.3 animations:^{
            fileMenu.center = center;
        } completion:^(BOOL finished) {
            [fileMenu removeFromSuperview];
            _menuStateArray[2] = kSubMemuHiding;
        }];
    }
}

- (void)hideDeleteModeBehideBar:(BOOL)behideBar{
    _menuStateArray[3] = kSubMemuDisappealing;
    UIView* deleteMode = (UIView*)[_menuArray pointerAtIndex:3];
    if (deleteMode) {
        CGPoint center = CGPointMake(deleteMode.center.x, deleteMode.center.y + CGRectGetHeight(deleteMode.frame));
        if (!behideBar) {
            center.y = self.superview.frame.size.height + deleteMode.frame.size.height/2;
        }
        [UIView animateWithDuration:0.3 animations:^{
            deleteMode.center = center;
        } completion:^(BOOL finished) {
            [deleteMode removeFromSuperview];
            _menuStateArray[3] = kSubMemuHiding;
        }];
        if (self.delegate) {
            [self.delegate deleteModeChangeTo:NO];
        }
    }
}


#pragma mark - Selected New Image
- (void)selectButtonAtIndex:(NSUInteger)index{
    NSString* state = _menuStateArray[index];
    
    if ([state isEqualToString:kSubMemuAppealing] || [state isEqualToString:kSubMemuDisappealing]) {
        return;
    }
    
    if (_selected) {
        //Deseclect pervious button and peform other hiding actions
        [self hideTool:_selectedTool BehideBar:YES];
        //If itself is pervious button, then cancel and no select any buttons
        if (_selectedTool == index) {
            _selected = NO;
            return;
        }
    }
    
    if (state == kSubMemuHiding) {
        _selected = YES;
        _selectedTool = index;
        UIButton* button =  _buttonsArray[index];
        button.selected = YES;
        [self showMenu:index];
    }
}

- (void)immediatelyHideAllMenu{
    for (NSUInteger i = 0; i < [_menuArray count]; i ++) {
        NSString* state = _menuStateArray[i];
        if (![state isEqualToString:kSubMemuHiding]) {
            UIView* view = (UIView*)[_menuArray pointerAtIndex:i];
            if (view) {
                [view.layer removeAllAnimations];
            }
            [self hideTool:i BehideBar:NO];
        }
    }
    _selected = NO;
}

#pragma mark - SubAdjustmentMenu
- (void)showSubAdjustmentMenu:(UIView*)view{
    if (_selectedTool != 1 || !_selected) {
        [self tapAdjustmentMenuButton];
    }
    ECTAdjustmentMenu* menu = (ECTAdjustmentMenu*)[_menuArray pointerAtIndex:1];
    if (menu) {
        [menu addSubMenu:view];
    }
}

- (CGRect)subAdjustmentMenuFrame{
    return CGRectInset(CGRectMake(0.0, 0.0,CGRectGetWidth(self.bounds), 120.0), 5.0, 5.0);;
}

- (void)hideAdjustmentMenu{
    if (_selected && _selectedTool == 1) {
        [self tapAdjustmentMenuButton];
    }
}

#pragma mark - Animation
- (void)startHideAnimation{
    [self immediatelyHideAllMenu];
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

/*
#pragma mark - UICollectionViewDataSource
- (void)setFileMenuDataSource:(id<UICollectionViewDataSource>)fileMenuDataSource{
    if (fileMenuDataSource) {
        _fileMenuDataSource = fileMenuDataSource;
        ECTFileMenu* fileMenu = (ECTFileMenu*)[_menuArray pointerAtIndex:2];
        if (fileMenu) {
            fileMenu.collectionView.dataSource = _fileMenuDataSource;
        }
    }
    
}
 */
@end
