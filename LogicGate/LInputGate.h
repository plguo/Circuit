//
//  LInputGate.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LGate.h"
#import "LTAInputInfoViewDelegate.h"

@interface LInputGate : LGate<LTAInputInfoViewDelegate>
@property (nonatomic) NSString* inputName;
@end
