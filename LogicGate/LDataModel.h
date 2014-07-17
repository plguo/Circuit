//
//  LDataModel.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ECTFileMenu.h"

@interface LDataModel : NSObject<ECTFileMenuDataSource>
+ (instancetype)sharedDataModel;
+ (void)saveDataModel;
- (BOOL)addMap:(NSString*)name Snapshot:(UIImage*)snapshot;
//- (void)saveMap:(NSString*)name GatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray Snapshot:(UIImage*)snapshot;
@end
