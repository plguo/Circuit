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
#import "LDataModelDelegate.h"

@interface LDataModel : NSObject<ECTFileMenuDataSource,NSFetchedResultsControllerDelegate>

+ (instancetype)sharedDataModel;
+ (void)saveDataModel;
- (void)deleteCache;

- (void)addMap:(NSString*)name Snapshot:(UIImage *)snapshot GatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray;

- (void)saveMapAtIndexPath:(NSIndexPath *)indexPath Snapshot:(UIImage *)snapshot GatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray;

- (void)deleteMapsAtIndexPath:(NSArray*)indexPaths;
- (void)deleteMapsAtIndexPath:(NSArray*)indexPaths completion:(void (^)())handler;

- (void)loadMapAtIndexPath:(NSIndexPath *)indexPath GateView:(UIView*)gateView WireView:(UIView*)wireView GateGestureRecognizerTarget:(id)target PanAction:(SEL)panAction PortAction:(SEL)portAction;

- (void)renameMapAtIndexPath:(NSIndexPath *)indexPath Name:(NSString *)name;

@property(nonatomic,weak) id<LDataModelDelegate> delegate;
@property(nonatomic,readonly) NSFetchedResultsController* fetchedResultsController;
@end
