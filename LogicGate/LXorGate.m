//
//  LXorGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-24.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LXorGate.h"

@implementation LXorGate

-(NSString*)imageName{
    return @"xor_gate";
}

- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput{
    return (firstInput ^ secondInput);
}

-(GateType)getDefultGateType{
    return GateTypeXOR;
}

-(NSString*)formatInBooleanFormula:(NSInteger)format{
    switch (format) {
        case 0:
        default:
            return @"( %@ XOR %@ )";
            break;
            
        case 1:
            return @"( %@ ⊕ %@ )";
            break;
    }
}

+(NSString*)gateName{
    return @"XOR Gate";
}

@end
