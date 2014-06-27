//
//  ECGridView.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECGridView : UIView
+ (instancetype)generateGridWithNumberOfVerticalLines:(NSUInteger)width HorizonLines:(NSUInteger)height;
@end
