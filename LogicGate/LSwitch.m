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
- (void)initPorts{
    LPort *outP1 = [[LPort alloc]initWithPortType:PortTypeOutput SuperGate:self Center:CGPointMake(27, 25)];
    self.outPorts = [NSArray arrayWithObject:outP1];
    [self addSubview:outP1];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(8, 8, 13, 34);
    [button addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    self.inputName = @"<-Variable->";
    _outputState = NO;
}

- (void)touchUp{
    _outputState = !_outputState;
    
    LPort* outP1 = self.outPorts[0];
    outP1.boolStatus = _outputState;
    
    self.image = [UIImage imageNamed:[self imageName]];
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

-(NSString*)booleanFormulaWithFormat:(NSInteger)format{
    return self.inputName;
}

+(NSString*)gateName{
    return @"Switch";
}
@end