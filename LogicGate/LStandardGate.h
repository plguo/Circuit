//
//  LStandardGate.h
//  Circuit
//
//  Created by Edward Guo on 2014-07-05.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LGate.h"

@interface LStandardGate : LGate
-(NSString*)formatInBooleanFormula:(NSInteger)format;
- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput;
@end
