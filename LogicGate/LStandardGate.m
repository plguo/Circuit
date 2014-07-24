//
//  LStandardGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-05.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LStandardGate.h"

@implementation LStandardGate

-(void)initPorts{
    LPort *inP1 = [LPort portType:PortTypeInput SuperGate:self Center:CGPointMake(5, 9)];
    LPort *inP2 = [LPort portType:PortTypeInput SuperGate:self Center:CGPointMake(5, 21)];
    self.inPorts = [NSArray arrayWithObjects:inP1,inP2, nil];
    [self addSubview:inP1];
    [self addSubview:inP2];
    
    LPort *outP1 = [LPort portType:PortTypeOutput SuperGate:self Center:CGPointMake(55, 15)];
    self.outPorts = [NSArray arrayWithObject:outP1];
    [self addSubview:outP1];
}

-(void)updateOutput{
    if (self.realInput) {
        LPort *outP1 = [self.outPorts objectAtIndex:0];
        LPort *inP1 = [self.inPorts objectAtIndex:0];
        LPort *inP2 = [self.inPorts objectAtIndex:1];
        outP1.boolStatus = [self outputForFirstInput:inP1.boolStatus
                                         SecondInput:inP2.boolStatus];
    }
}

-(NSString*)formatInBooleanFormula:(NSInteger)format{
    return @"( %@ ? %@ )";
}

-(NSString*)booleanFormulaWithFormat:(NSInteger)format{
    if (self.inPorts.count >= 2) {
        LPort*inP1 = self.inPorts[0];
        LPort*inP2 = self.inPorts[1];
        if (inP1.inWire && inP2.inWire) {
            if (inP1.inWire.startPort && inP2.inWire.startPort) {
                return [NSString stringWithFormat:[self formatInBooleanFormula:format],
                        [inP1.inWire.startPort.superGate booleanFormulaWithFormat:format],
                        [inP2.inWire.startPort.superGate booleanFormulaWithFormat:format]];
            }
        }
    }
    return [super booleanFormulaWithFormat:format];
}

- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput{
    return NO;
}
@end
