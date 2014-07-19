//
//  ECTFileMenu.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-16.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTFileMenuCell.h"
#import <CoreData/NSFetchedResultsController.h>

@class ECTFileMenu;
@protocol ECTFileMenuDelegate <NSObject>
- (void)addMapWithName:(NSString*)name;

- (void)saveMapAtIndexPath:(NSIndexPath*)indexPath;
- (void)loadMapAtIndexPath:(NSIndexPath*)indexPath;
- (void)removeMapInIndexArray:(NSArray*)indexArray;

- (void)renameMapAtIndexPath:(NSIndexPath*)indexPath Name:(NSString*)name;
@end

@protocol ECTFileMenuDataSource <UICollectionViewDataSource>
- (void) setFetchedResultsControllerDelegate:(id)delegate;
@end

@interface ECTFileMenu : UIView<UICollectionViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,NSFetchedResultsControllerDelegate>
+(instancetype)autosizeFileMenuForView:(UIView*)view;
@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<ECTFileMenuDelegate> delegate;
@end
