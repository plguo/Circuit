//
//  LAndGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-05.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LAndGate.h"

@implementation LAndGate

-(NSString*)imageName{
    return @"and_gate";
}

-(void)updateOutput{
    if (self.realInput) {
        LPort *outP1 = [self.outPorts objectAtIndex:0];
        LPort *inP1 = [self.inPorts objectAtIndex:0];
        LPort *inP2 = [self.inPorts objectAtIndex:1];
        outP1.boolStatus = inP1.boolStatus && inP2.boolStatus;
    }
}

-(GateType)getDefultGateType{
    return GateTypeAND;
}

-(NSString*)gateNameInBooleanFormula{
    return @"AND";
}

+(NSString*)gateName{
    return @"AND Gate";
}

@end
