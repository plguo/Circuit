//
//  ViewController.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-26.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ViewController.h"

#import "ECToolBar.h"

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

#pragma mark - Preferre Style
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
