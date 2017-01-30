//
//  LSwitch.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LSwitch.h"

@implementation LSwitch{
    BOOL _outputState;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _outputState = ![coder decodeBoolForKey:@"OutputState"];
        self.image = [UIImage imageNamed:[self imageName]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeBool:_outputState forKey:@"OutputState"];
}


- (void)initPorts{
    LPort *outP1 = [[LPort alloc]initWithPortType:PortTypeOutput SuperGate:self Center:CGPointMake(27, 25)];
    self.outPorts = [NSArray arrayWithObject:outP1];
    [self addSubview:outP1];
    
    self.inputName = @"Variable";
    _outputState = NO;
}

- (void)inverseState{
    _outputState = !_outputState;
    
    LPort* outP1 = self.outPorts[0];
    outP1.boolStatus = _outputState;
    
    self.image = [UIImage imageNamed:[self imageName]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[LInputGate inputDidUpdateNotificationKey] object:self];
}

- (BOOL)outputState{
    return _outputState;
}

-(NSString*)imageName{
    if (_outputState) {
        return @"switch_on";
    } else {
        return @"switch_off";
    }
}

-(GateType)getDefultGateType{
    return GateTypeSwitch;
}


+(NSString*)gateName{
    return @"Switch";
}
@end
