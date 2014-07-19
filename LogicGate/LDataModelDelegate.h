//
//  LDataModelDelegate.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-19.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LDataModelDelegate <NSObject>
- (void)startMapDataProcessing;
- (void)finishMapDataProcessing;
@end
