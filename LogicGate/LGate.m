//
//  LGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LGate.h"

@implementation LGate

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
}

#pragma mark - Initialization

- (instancetype)initGate{
    self = [super init];
    if (self) {
        //Initialize image
        self.image = [UIImage imageNamed:[self imageName]];
        [self sizeToFit];
        
        //Initialize ports
        [self initPorts];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

+ (instancetype)gate{
    return [[self alloc] initGate];
}


- (void)initPorts{
    /* Initialization of Ports*/
}


#pragma mark - Update gate status
- (void)updateOutput{
     /*Update boolean output*/
}

-(void)updateRealIntput{
    /*Get the real input boolean*/
    BOOL real = YES;
    
    //Check do all ports have real input
    for (LPort* anInPort in _inPorts) {
        if (!anInPort.realInput) {
            real = NO;
            break;
        }
    }
    
    if (self.realInput != real || [self isRealInputSource]){
        _realInput = real || [self isRealInputSource];
        for (LPort* anOutPort in _outPorts) {
            anOutPort.realInput = self.realInput;
        }
    }
}

#pragma mark - Notify ports and their wires to update position
-(void)setCenter:(CGPoint)center{
    [super setCenter:(CGPoint)center];
    for (LPort *aPort in _inPorts){
        [aPort gatePositionDidChange];
    }
    for (LPort *aPort in _outPorts){
        [aPort gatePositionDidChange];
    }
}

#pragma mark - LObjectProtocol
- (void)remove{
    for (LPort *aPort in _inPorts){
        [aPort removeAllWire];
    }
    for (LPort *aPort in _outPorts){
        [aPort removeAllWire];
    }
}


#pragma mark - Gate info for subclasses
- (NSString*)imageName{
    return @"and_gate";
}

- (BOOL)isRealInputSource{
    return NO;
}

- (NSString*)gateName{
    return @"GATE";
}

- (NSString*)booleanFormula{
    return @"DEFULT_GATE";
}

#pragma mark - Handle touch events


@end
