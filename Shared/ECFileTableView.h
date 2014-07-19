//
//  ECFileTableView.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-19.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECFileTableView;
@protocol ECFileTableViewDataSource <NSObject>
- (NSString*)fileTableView:(ECFileTableView *)fileTableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)fileTableView:(ECFileTableView *)fileTableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInFileTableView:(ECFileTableView *)fileTableView;
@end

@protocol ECFileTableViewDelegate <NSObject>
- (void)fileTableView:(ECFileTableView*)fileTableView DeleteMapsAtIndexPaths:(NSArray*)indexPaths;
- (void)fileTableViewWillAppear:(ECFileTableView*)fileTableView;
- (void)loadMapAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface ECFileTableView : UIView<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>;
- (void)reloadData;
@property(nonatomic,weak) id<ECFileTableViewDelegate> delegate;
@property(nonatomic,weak) id<ECFileTableViewDataSource> dataSource;
@end
