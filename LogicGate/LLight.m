//
//  LLight.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-07.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LLight.h"

@implementation LLight

-(void)initPorts{
    LPort *inP1 = [LPort portType:PortTypeInput SuperGate:self Center:CGPointMake(25, 71)];
    self.inPorts = [NSArray arrayWithObject:inP1];
    [self addSubview:inP1];
    
    self.layer.shadowColor = [UIColor yellowColor].CGColor;
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

-(NSString*)imageName{
    LPort *inP1 = [self.inPorts objectAtIndex:0];
    if (inP1.boolStatus && inP1.realInput) {
        return @"LightOn";
    }else{
        return @"LightOff";
    }
    
}

-(void)updateRealIntput{
    [super updateRealIntput];
    self.image = [UIImage imageNamed:[self imageName]];
}
-(void)updateOutput{
    self.image = [UIImage imageNamed:[self imageName]];
    LPort *inP1 = [self.inPorts objectAtIndex:0];
    if (inP1.boolStatus && inP1.realInput) {
        self.layer.shadowOpacity = 0.8;
    }else{
        self.layer.shadowOpacity = 0.0;
    }
}

-(GateType)getDefultGateType{
    return GateTypeLightBulb;
}

-(NSString*)booleanFormulaWithFormat:(NSInteger)format{
    if (self.realInput) {
        LPort* inP1 = self.inPorts[0];
        if (inP1.inWire) {
            if (inP1.inWire.startPort.superGate) {
                return [inP1.inWire.startPort.superGate booleanFormulaWithFormat:format];
            }
        }
    }
    return @"No input";
}

+(NSString*)gateName{
    return @"Light Bulb";
}

@end
