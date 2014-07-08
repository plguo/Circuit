//
//  ECTASubScrollView.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-08.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(uint16_t, ECTAViewCompression){
    ECTAViewVerticalCompression   = 1 << 0,
    ECTAViewHorizontalCompression = 1 << 1,
};


@interface ECTASubScrollView : UIScrollView

@end
