//
//  LNotGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-30.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LNotGate.h"

@implementation LNotGate

-(void)initPorts{
    LPort *inP1 = [[LPort alloc]initWithPortType:PortTypeInput SuperGate:self Center:CGPointMake(5, 14)];
    self.inPorts = [NSArray arrayWithObject:inP1];
    [self addSubview:inP1];
    
    LPort *outP1 = [[LPort alloc]initWithPortType:PortTypeOutput SuperGate:self Center:CGPointMake(55, 14)];
    self.outPorts = [NSArray arrayWithObject:outP1];
    [self addSubview:outP1];
}

-(NSString*)imageName{
    return @"not_gate";
}

-(void)updateOutput{
    if (self.realInput) {
        LPort *outP1 = [self.outPorts objectAtIndex:0];
        LPort *inP1 = [self.inPorts objectAtIndex:0];
        outP1.boolStatus = !inP1.boolStatus;
    }
}

-(GateType)getDefultGateType{
    return GateTypeNOT;
}

-(NSString*)booleanFormulaWithFormat:(NSInteger)format{
    if (self.inPorts.count > 0) {
        LPort*inP1 = self.inPorts[0];
        if (inP1.inWire) {
            LGate* startGate = inP1.inWire.startPort.superGate;
            if (startGate) {
                if (format == 1) {
                    return [NSString stringWithFormat:@"¬ ( %@ )",[startGate booleanFormulaWithFormat:format]];
                }else{
                    return [NSString stringWithFormat:@"NOT ( %@ )",[startGate booleanFormulaWithFormat:format]];
                }
            }
        }
    }
    return [super booleanFormulaWithFormat:format];
}

+(NSString*)gateName{
    return @"NOT Gate";
}

@end
