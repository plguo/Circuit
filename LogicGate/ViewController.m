//
//  ViewController.m
//  LogicGate
//
//  Created by Edward Guo on 2014-06-28.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ViewController.h"
#import "LGate.h"

@interface ViewController ()

@end

@implementation ViewController{
    ECNavigationBar* _navBar;
    UIScrollView* _mainScrollView;
    ECToolBar* _toolBar;
    UIButton* _showButton;
}

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup tool bar
    _toolBar = [ECToolBar autosizeToolBarForView:self.originalContentView];
    [self.originalContentView addSubview:_toolBar];
	
    //Setup navigation bar
    
    _navBar = [ECNavigationBar autosizeTooNavigationBarForView:self.originalContentView];
    _navBar.delegate = self;
    [self.originalContentView addSubview:_navBar];
    
    
    //Setup scroll view
    CGRect scrollViewFrame = CGRectMake(0, CGRectGetHeight(_navBar.frame), self.originalContentView.frame.size.width, CGRectGetHeight(self.originalContentView.bounds) - CGRectGetHeight(_toolBar.frame) - CGRectGetHeight(_navBar.frame));

    _mainScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.originalContentView insertSubview:_mainScrollView belowSubview:_toolBar];
    
    //Setup grid view
    ECGridView* gridView = [ECGridView generateGridWithNumberOfVerticalLines:31 HorizonLines:31];
    [_mainScrollView addSubview:gridView];
    
    _mainScrollView.contentSize = gridView.frame.size;
    [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.contentSize.width/2 - _mainScrollView.bounds.size.width/2, _mainScrollView.contentSize.height/2 - _mainScrollView.bounds.size.height/2) animated:NO];
    
    
    LGate* gate = [[LGate alloc]initGate];
    gate.center = CGPointMake(_mainScrollView.contentSize.width/2, _mainScrollView.contentSize.height/2);
    [gridView addSubview:gate];
    
    
    //Setup show/hide button
    _showButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [_showButton setImage:[UIImage imageNamed:@"ShowMenuIcon"] forState:UIControlStateNormal];
    [_showButton sizeToFit];
    _showButton.frame = CGRectMake(self.originalContentView.bounds.size.width - _showButton.frame.size.width - 8, 8, _showButton.frame.size.width, _showButton.frame.size.height);
    _showButton.alpha = 0.8;
    _showButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [_showButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    //End of View Initialization
    [UIViewController prepareInterstitialAds];
}

- (void)viewDidAppear:(BOOL)animated{
    self.canDisplayBannerAds = YES;
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
    [_navBar startHideAnimation];
    [_toolBar startHideAnimation];
    _showButton.frame = CGRectMake(self.originalContentView.bounds.size.width - _showButton.frame.size.width - 5, 5, _showButton.frame.size.width, _showButton.frame.size.height);
    [self.originalContentView insertSubview:_showButton belowSubview:_navBar];
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        _mainScrollView.frame = self.originalContentView.frame;
        _showButton.alpha = 0.8;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Show Menu
- (void)showMenu{
    [_navBar startShowAnimation];
    [_toolBar startShowAnimation];
    CGRect scrollViewFrame = CGRectMake(0, CGRectGetHeight(_navBar.frame), self.originalContentView.frame.size.width, CGRectGetHeight(self.originalContentView.bounds) - CGRectGetHeight(_toolBar.frame) - CGRectGetHeight(_navBar.frame));
    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
        _mainScrollView.frame = scrollViewFrame;
        _showButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_showButton removeFromSuperview];
    }];
}
@end
