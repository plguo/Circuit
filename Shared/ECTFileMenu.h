//
//  ECTFileMenu.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-16.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTFileMenuCell.h"
@interface ECTFileMenu : UIView<UICollectionViewDelegate>
+(instancetype)autosizeFileMenuForView:(UIView*)view;
@property (nonatomic,readonly) UICollectionView *collectionView;
@end
