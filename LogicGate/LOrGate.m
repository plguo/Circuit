//
//  LOrGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-24.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LOrGate.h"

@implementation LOrGate

-(NSString*)imageName{
    return @"or_gate";
}

- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput{
    return (firstInput || secondInput);
}

-(GateType)getDefultGateType{
    return GateTypeOR;
}

-(NSString*)formatInBooleanFormula:(NSInteger)format{
    switch (format) {
        case 0:
        default:
            return @"( %@ OR %@ )";
            break;
            
        case 1:
            return @"( %@ ∨ %@ )";
            break;
    }
}

+(NSString*)gateName{
    return @"OR Gate";
}

@end
