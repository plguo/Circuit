//
//  ECTFileMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-16.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTFileMenu.h"

@implementation ECTFileMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

+ (instancetype)autosizeFileMenuForView:(UIView*)view{
    ECTFileMenu* fileMenu = [[self alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view.bounds), 100)];
    fileMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    return fileMenu;
}

@end
