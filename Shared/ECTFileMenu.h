//
//  ECTFileMenu.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-16.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTFileMenuCell.h"
@class ECTFileMenu;
@protocol ECTFileMenuDelegate <NSObject>
- (void)addMapWithName:(NSString*)name;

- (void)saveMapAtIndex:(NSUInteger)index;
- (void)loadMapAtIndex:(NSUInteger)index;
- (void)removeMapInIndexSet:(NSSet*)indexSet;

- (void)renameMapAtIndex:(NSUInteger)index Name:(NSString*)name;
@end

@interface ECTFileMenu : UIView<UICollectionViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
+(instancetype)autosizeFileMenuForView:(UIView*)view;
@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<ECTFileMenuDelegate> delegate;
@end
