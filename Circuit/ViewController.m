//
//  ViewController.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-26.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ViewController.h"

#import "ECToolBar.h"
#import "ECNavigationBar.h"
#import "ECGridView.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup tool bar
    ECToolBar* toolBar = [ECToolBar autosizeToolBarForView:self.view];
    [self.view addSubview:toolBar];
	
    //Setup navigation bar
    
    ECNavigationBar* navBar = [ECNavigationBar autosizeTooNavigationBarForView:self.view];
    [navBar sizeToFit];
    [self.view addSubview:navBar];
    
    
    //Setup scroll view
    CGRect scrollViewFrame = CGRectMake(0, CGRectGetMaxY(navBar.frame), self.view.frame.size.width, CGRectGetMinY(toolBar.frame) - CGRectGetMaxY(navBar.frame));
    //CGRect scrollViewFrame = self.view.bounds;
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    scrollView.delegate = self;
    //scrollView.zoomScale = 0.1;
    [self.view addSubview:scrollView];
    
    
    ECGridView* gridView = [ECGridView generateGridWithNumberOfVerticalLines:24 HorizonLines:24];
    [scrollView addSubview:gridView];
    
    scrollView.contentSize = gridView.frame.size;
    [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width/2 - scrollView.bounds.size.width/2, scrollView.contentSize.height/2 - scrollView.bounds.size.height/2) animated:NO];
     
    //End of View Initialization
    //Setup iAd
    //self.canDisplayBannerAds = YES;
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

@end
