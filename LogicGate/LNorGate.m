//
//  LNorGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-24.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LNorGate.h"

@implementation LNorGate

-(NSString*)imageName{
    return @"nor_gate";
}

- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput{
    return ( !(firstInput || secondInput) );
}

-(GateType)getDefultGateType{
    return GateTypeNOR;
}

-(NSString*)formatInBooleanFormula:(NSInteger)format{
    switch (format) {
        case 0:
        default:
            return @"( %@ NOR %@ )";
            break;
            
        case 1:
            return @"( ¬( %@ ∨ %@ ) )";
            break;
    }
}

+(NSString*)gateName{
    return @"NOR Gate";
}

@end
