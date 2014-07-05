//
//  LTrueOutput.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-02.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LTrueOutput.h"

@implementation LTrueOutput

-(void)initPorts{
    LPort *outP1 = [[LPort alloc]initWithPortType:PortTypeOutput SuperGate:self Center:CGPointMake(27, 25)];
    self.outPorts = [NSArray arrayWithObject:outP1];
    [self addSubview:outP1];
}

-(NSString*)imageName{
    return @"output";
}

-(void)updateOutput{
    LPort *outP1 = [self.outPorts objectAtIndex:0];
    outP1.boolStatus = YES;
}

-(GateType)getDefultGateType{
    return GateTypeTrueOutput;
}

-(BOOL)isRealInputSource{
    return YES;
}

-(NSString*)booleanFormula{
    return @"TRUE";
}

+(NSString*)gateName{
    return @"True Output";
}

@end
