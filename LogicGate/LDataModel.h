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
@class LDataModel;
@protocol LDataModelDelegate <NSObject>
- (void)loadGatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray;
@end
@interface LDataModel : NSObject<ECTFileMenuDataSource,NSFetchedResultsControllerDelegate>
+ (instancetype)sharedDataModel;
+ (void)saveDataModel;
- (void)deleteCache;
- (void)addMap:(NSString*)name Snapshot:(UIImage *)snapshot GatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray;
- (void)deleteMapsAtIndexPath:(NSArray*)indexPaths;

- (void)loadMapAtIndexPath:(NSIndexPath *)indexPath GateView:(UIView*)gateView WireView:(UIView*)wireView GateGestureRecognizerTarget:(id)target PanAction:(SEL)panAction PortAction:(SEL)portAction;

- (void)renameMapAtIndexPath:(NSIndexPath *)indexPath Name:(NSString *)name;
//- (void)saveMap:(NSString*)name GatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray Snapshot:(UIImage*)snapshot;
@end
