//
//  ViewController.m
//  LogicGate
//
//  Created by Edward Guo on 2014-06-28.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ViewController.h"
#import "LAndGate.h"
#import "LNotGate.h"
#import "LTrueOutput.h"
#import "LLight.h"
#import "LSwitch.h"
#import "LDataModel.h"

@interface ViewController ()

@end

@implementation ViewController{
    ECNavigationBar* _navBar;
    UIScrollView* _mainScrollView;
    ECToolBar* _toolBar;
    UIButton* _showButton;
    ECGridView* _gridView;
    
    ECOverlayView* _gateView;
    ECOverlayView* _wireView;
    
    ECScreenEdgeScrollController* _screenEdgeScrollController;
    CGRect _scrollViewEdge;
    
    TapMode _tapMode;
    MenuState _menuState;
    
    LDataModel* _dataModel;
    
    __weak LTAGateInfoView* _gateInfoView;
    
    __weak id<LObjectProtocol> _menuControlLObject;
    __weak LGate* _selectedGate;
}

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataModel = [LDataModel sharedDataModel];
    
    //Setup tool bar
    _toolBar = [ECToolBar autosizeToolBarForView:self.originalContentView];
    _toolBar.delegate = self;
    _toolBar.fileMenuDataSource = _dataModel;
    [self.originalContentView addSubview:_toolBar];
	
    //Setup navigation bar
    
    _navBar = [ECNavigationBar autosizeTooNavigationBarForView:self.originalContentView];
    _navBar.delegate = self;
    [self.originalContentView addSubview:_navBar];
    
    
    //Setup scroll view
    CGRect scrollViewFrame = CGRectMake(0, CGRectGetHeight(_navBar.frame), CGRectGetWidth(self.originalContentView.bounds), CGRectGetHeight(self.originalContentView.bounds) - CGRectGetHeight(_toolBar.frame) - CGRectGetHeight(_navBar.frame));
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _mainScrollView.canCancelContentTouches = NO;
    [self.originalContentView insertSubview:_mainScrollView belowSubview:_toolBar];
    
    //Setup grid view
    _gridView = [ECGridView generateGridWithNumberOfVerticalLines:31 HorizonLines:31];
    [_mainScrollView addSubview:_gridView];
    
    _mainScrollView.contentSize = _gridView.frame.size;
    
    _gateView = [[ECOverlayView alloc] initWithFrame:_gridView.frame];
    _wireView = [[ECOverlayView alloc] initWithFrame:_gridView.frame];
    
    [_gridView addSubview:_wireView];
    [_gridView addSubview:_gateView];
    
    [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.contentSize.width/2 - _mainScrollView.bounds.size.width/2, _mainScrollView.contentSize.height/2 - _mainScrollView.bounds.size.height/2) animated:NO];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [_mainScrollView addGestureRecognizer:tapGestureRecognizer];
    
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressFrom:)];
    [_mainScrollView addGestureRecognizer:longPressGestureRecognizer];
    
    //Setup show/hide button
    _showButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [_showButton setImage:[UIImage imageNamed:@"ShowMenuIcon"] forState:UIControlStateNormal];
    [_showButton sizeToFit];
    _showButton.frame = CGRectMake(self.originalContentView.bounds.size.width - _showButton.frame.size.width - 8, 8, _showButton.frame.size.width, _showButton.frame.size.height);
    _showButton.alpha = 0.8;
    _showButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [_showButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _screenEdgeScrollController = [[ECScreenEdgeScrollController alloc] init];
    _screenEdgeScrollController.scrollView = _mainScrollView;
    //End of View Initialization
    [UIViewController prepareInterstitialAds];
    
    _tapMode = TapModeNone;
    _menuState = MenuNormalState;
    
    self.canDisplayBannerAds = YES;
}

- (void)viewDidLayoutSubviews{
    _scrollViewEdge = CGRectInset(CGRectMake(0, 0, _mainScrollView.bounds.size.width, _mainScrollView.bounds.size.height) , 15, 15);
}

#pragma mark - Memory Mangement
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIStatusBar
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Hide Menu
- (void)hideMenu{
    _menuState = MenuDisappealingState;
    [_navBar startHideAnimation];
    [_toolBar startHideAnimation];
    _showButton.frame = CGRectMake(self.originalContentView.bounds.size.width - _showButton.frame.size.width - 5, 5, _showButton.frame.size.width, _showButton.frame.size.height);
    [self.originalContentView insertSubview:_showButton belowSubview:_navBar];
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        _mainScrollView.frame = self.originalContentView.bounds;
        _showButton.alpha = 0.8;
    } completion:^(BOOL finished) {
        _menuState = MenuHidenState;
    }];
}

#pragma mark - Show Menu
- (void)showMenu{
    _menuState = MenuAppealingState;
    [_navBar startShowAnimation];
    [_toolBar startShowAnimation];
    CGRect scrollViewFrame = CGRectMake(0, CGRectGetHeight(_navBar.frame), CGRectGetWidth(self.originalContentView.bounds), CGRectGetHeight(self.originalContentView.bounds) - CGRectGetHeight(_toolBar.frame) - CGRectGetHeight(_navBar.frame));
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        _mainScrollView.frame = scrollViewFrame;
        _showButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_showButton removeFromSuperview];
        _menuState = MenuNormalState;
    }];
}



#pragma mark - Handle Gesture Recognizers
-(void)handlePanFrom:(UIPanGestureRecognizer *)recognizer{
    UIView* gate = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.2 animations:^{
            gate.transform = CGAffineTransformMakeScale(1.2, 1.2);
            gate.center = [recognizer locationInView:gate.superview];
            gate.alpha = 0.7;
        }];
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        gate.center = [recognizer locationInView:gate.superview];
        if (!_screenEdgeScrollController.tracking) {
            CGPoint location = [recognizer locationInView:_mainScrollView];
            location.x -= _mainScrollView.contentOffset.x;
            location.y -= _mainScrollView.contentOffset.y;
            if (!CGRectContainsPoint(_scrollViewEdge, location)) {
                [_screenEdgeScrollController trackGestureRecognizer:recognizer Bounds:_scrollViewEdge Location:location];
            }
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        
        CGPoint snapPoint = [_gridView closestPointInGridView:[recognizer locationInView:gate.superview]];
        CGSize gateSize = CGSizeMake(CGRectGetWidth(gate.bounds), CGRectGetHeight(gate.bounds));
        CGRect snapRect = CGRectMake(snapPoint.x - gateSize.width/2 , snapPoint.y - gateSize.height/2, gateSize.width, gateSize.height);
        snapRect = CGRectInset(snapRect, - 5.0, - 5.0);
        [_mainScrollView scrollRectToVisible:snapRect animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            gate.transform = CGAffineTransformIdentity;
            gate.center = snapPoint;
            gate.alpha = 1.0;
        }];
        
    }
}

-(void)handlePanFromWireGestureRecognizer:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        LWire* wire = [LWire wireWithPortGestureRecognizer:recognizer];
        [_wireView addSubview:wire];
    }
}

-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_tapMode != TapModeNone) {
            id viewID = [recognizer.view hitTest:[recognizer locationInView:recognizer.view] withEvent:nil];
            if (viewID) {
                if (_tapMode == TapModeRemove) {
                    if ([viewID conformsToProtocol:@protocol(LObjectProtocol)]) {
                        id<LObjectProtocol> lObject = viewID;
                        [lObject objectRemove];
                    }
                }else if (_tapMode == TapModeAdjust){
                    if ([viewID conformsToProtocol:@protocol(LTAGateInfoViewDelegate)]) {
                        [self openGateInfoViewWithDelegate:(id<LTAGateInfoViewDelegate>)viewID];
                    }
                }
                
            }
        }
    }
}

-(void)handleLongPressFrom:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        UIView* view = [recognizer.view hitTest:[recognizer locationInView:recognizer.view] withEvent:nil];
        if ([view conformsToProtocol:@protocol(LObjectProtocol)]) {
            id<LObjectProtocol> lObject = (id)view;
            UIMenuItem* ItemRemove = [[UIMenuItem alloc] initWithTitle:@"remove" action:@selector(removeSelecedLObject)];
            NSMutableArray* items = [NSMutableArray arrayWithObject:ItemRemove];
            
            if ([view isKindOfClass:[LGate class]]) {
                UIMenuItem* ItemInfo = [[UIMenuItem alloc] initWithTitle:@"info" action:@selector(getInfoFromSelecedLObject)];
                [items insertObject:ItemInfo atIndex:0];
            }
            _menuControlLObject= lObject;
            [recognizer.view becomeFirstResponder];
            UIMenuController* menuController = [UIMenuController sharedMenuController];
            [menuController setTargetRect:[recognizer.view convertRect:view.frame fromView:view.superview]
                                   inView:recognizer.view];
            
            menuController.menuItems = items;
            [menuController update];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

-(void)getInfoFromSelecedLObject{
    if ([_menuControlLObject conformsToProtocol:@protocol(LTAGateInfoViewDelegate) ]) {
        [self openGateInfoViewWithDelegate:(id<LTAGateInfoViewDelegate>)_menuControlLObject];
    }
}

-(void)openGateInfoViewWithDelegate:(id<LTAGateInfoViewDelegate>)gate{
    if (gate && _menuState != MenuAppealingState && _menuState != MenuDisappealingState) {
        CGRect frame = [_toolBar subAdjustmentMenuFrame];
        if (!CGRectIsNull(frame)) {
            
            NSString* title = nil;
            if ([gate isKindOfClass:[LGate class]]) {
                if (_selectedGate) {
                    _selectedGate.selected = NO;
                    _selectedGate.delegate = nil;
                    _selectedGate = nil;
                }
                _selectedGate = (LGate*)gate;
                _selectedGate.selected = YES;
                _selectedGate.delegate = self;
                
                title = [[_selectedGate class] gateName];
            }
            UIView* menu;
            if ([gate conformsToProtocol:@protocol(LTAInputInfoViewDelegate)]) {
                LTAInputInfoView* inputView = [[LTAInputInfoView alloc]initWithFrame:frame];
                inputView.toolBar = _toolBar;
                inputView.delegate = (id<LTAInputInfoViewDelegate>)gate;
                menu = (UIView*)inputView;
            }else{
                LTAGateInfoView* gateMenu = [[LTAGateInfoView alloc]initWithFrame:frame];
                gateMenu.delegate = gate;
                if (title) {
                    gateMenu.title = title;
                }
                _gateInfoView = gateMenu;
                menu = (UIView*)gateMenu;
            }
            
            if (_menuState == MenuNormalState) {
                [_toolBar showSubAdjustmentMenu:menu];
            }else{
                [self showMenu];
                [_toolBar performSelector:@selector(showSubAdjustmentMenu:) withObject:menu afterDelay:0.6];
            }
            
        }
    }
}

-(void)removeSelecedLObject{
    if (_menuControlLObject){
        [_menuControlLObject objectRemove];
        _menuControlLObject = nil;
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}


#pragma mark - ECTComponentsMenuDelegate
- (void)handleViewFromComponentsMenu:(UIView*)view PanGestureRecognizer:(UIGestureRecognizer*)recognizer{
    [recognizer addTarget:self action:@selector(handlePanFrom:)];
    [_gateView addSubview:view];
    view.center = [self.originalContentView convertPoint:view.center toView:_gateView];
    if ([view isKindOfClass:[LGate class]]) {
        [(LGate*)view initUserInteractionWithTarget:self action:@selector(handlePanFromWireGestureRecognizer:)];
    }
}

- (UIView*)componentsMenuViewAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            return [LAndGate gate];
            break;
            
        case 1:
            return [LNotGate gate];
            break;
            
        case 2:
            return [LSwitch gate];
            break;
        
        case 3:
            return [LTrueOutput gate];
            break;
        
        case 4:
            return [LLight gate];
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSString*)componentsMenuTitleAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            return [LAndGate gateName];
            break;
            
        case 1:
            return [LNotGate gateName];
            break;
            
        case 2:
            return [LSwitch gateName];
            
        case 3:
            return [LTrueOutput gateName];
            break;
        
        case 4:
            return [LLight gateName];
            break;

            
        default:
            break;
    }
    return [LGate gateName];
}

- (NSUInteger)componentsMenuNumberOfViews{
    return 5;
}

#pragma mark - LGateDelegate
- (void)gateBooleanFormulaDidChange{
    if (_gateInfoView) {
        [_gateInfoView performSelectorInBackground:@selector(loadBooleanFormula) withObject:nil];
    }
}

- (void)gateWillRemove{
    if (_selectedGate) {
        [_toolBar hideAdjustmentMenu];
        _selectedGate = nil;
    }
}

#pragma mark - ECTDeleteModeDelegate
- (void)deleteModeChangeTo:(BOOL)allowDelete{
    if (allowDelete) {
        _tapMode = TapModeRemove;
    }else{
        if (_tapMode == TapModeRemove) {
            _tapMode = TapModeNone;
        }
    }
}

#pragma mark - ECTAdjustmentMenuDelegate
- (void)adjustmentMenuModeChangeTo:(BOOL)adjustmentMenuMode{
    if (adjustmentMenuMode) {
        _tapMode = TapModeAdjust;
    }else{
        if (_tapMode == TapModeAdjust) {
            _tapMode = TapModeNone;
            if (_selectedGate) {
                _selectedGate.selected = NO;
                _selectedGate.delegate = nil;
                _selectedGate = nil;
            }
        }
    }
}

#pragma mark - ECTFileMenuDelegate
- (void)addMapWithName:(NSString*)name{
    CGSize imageSize = [ECTFileMenuCell preferredSizeForImage];
    CGRect rect = CGRectMake(CGRectGetWidth(_gridView.bounds)/2 - imageSize.width, CGRectGetHeight(_gridView.bounds)/2 - imageSize.width, imageSize.width*2, imageSize.height*2);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    [_gridView drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage* snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_dataModel addMap:name Snapshot:snapshot];
}

- (void)saveMapAtIndex:(NSUInteger)index{
    
}

- (void)loadMapAtIndex:(NSUInteger)index{
    
}

- (void)removeMapInIndexSet:(NSSet *)indexSet{
    
}

- (void)renameMapAtIndex:(NSUInteger)index Name:(NSString *)name{
    
}

@end
