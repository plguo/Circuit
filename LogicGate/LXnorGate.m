//
//  LXnorGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-24.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LXnorGate.h"

@implementation LXnorGate

-(NSString*)imageName{
    return @"xnor_gate";
}

- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput{
    return ( !(firstInput ^ secondInput) );
}

-(GateType)getDefultGateType{
    return GateTypeXNOR;
}

-(NSString*)formatInBooleanFormula:(NSInteger)format{
    switch (format) {
        case 0:
        default:
            return @"( %@ XNOR %@ )";
            break;
            
        case 1:
            return @"( ¬( %@ ⊕ %@ ) )";
            break;
    }
}

+(NSString*)gateName{
    return @"XOR Gate";
}

@end
