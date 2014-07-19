//
//  ECNavigationBarDelegate.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-28.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECFileTableView.h"

@protocol ECNavigationBarDelegate <ECFileTableViewDelegate,ECFileTableViewDataSource>
- (void)hideMenu;
- (void)newMap;
@end
