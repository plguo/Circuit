//
//  LNandGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-24.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LNandGate.h"

@implementation LNandGate

-(NSString*)imageName{
    return @"nand_gate";
}

- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput{
    return (!(firstInput && secondInput));
}

-(GateType)getDefultGateType{
    return GateTypeNAND;
}

-(NSString*)formatInBooleanFormula:(NSInteger)format{
    switch (format) {
        case 0:
        default:
            return @"( %@ NAND %@ )";
            break;
            
        case 1:
            return @"( ¬( %@ ∧ %@ ) )";
            break;
    }
}

+(NSString*)gateName{
    return @"NAND Gate";
}

@end
