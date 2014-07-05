//
//  LPort.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LPort.h"
#define RADIUS 5

@implementation LPort{
     NSMutableSet* _delegatesSet;
}

#pragma mark - Initialization
- (id)initWithPortType:(PortType)type SuperGate:(LGate *)gate Center:(CGPoint)center{
    self = [super initWithFrame:CGRectMake(center.x - RADIUS, center.y - RADIUS, RADIUS*2, RADIUS*2)];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = RADIUS;
        
        self.boolStatus = NO;
        self.realInput = NO;
        self.wireConnectable = YES;
        
        _type = type;
        _superGate = gate;
        
        self.inWire = nil;
        _delegatesSet = [NSMutableSet set];
    }
    return self;
}

+ (instancetype)portType:(PortType)type SuperGate:(LGate *)gate Center:(CGPoint)center{
    return [[self alloc] initWithPortType:type SuperGate:gate Center:center];
}

#pragma mark - Handle commands and messages
- (void)removeAllWire{
    for (id<LPortDelegate> pointer in _delegatesSet){
        if ([pointer respondsToSelector:@selector(portWillRemoveWires:)]) {
            [pointer portWillRemoveWires:self.type];
        }
    }
}

- (BOOL)allowToConnect{
    if (!self.wireConnectable) {
        return NO;
    }
    
    if (self.type == PortTypeOutput) {
        //Output type allow multiple connections
        return YES;
    }else{
        //Input type only allow one connection
        if (self.inWire){
            return NO;
        }else{
            return YES;
        }
    }
}

#pragma mark - Handle notifications from inWire
- (void)connectToInWire:(LWire *)inWire{
    if (self.type == PortTypeInput){
        _inWire = inWire;
        self.realInput = _inWire.realInput;
        
        _boolStatus = _inWire.boolStatus;
        for (id<LPortDelegate> pointer in _delegatesSet){
            if ([pointer respondsToSelector:@selector(portBoolStatusDidChange:)]) {
                [pointer portBoolStatusDidChange:self.type];
            }
        }
    }
}

- (void)inWireWillRemove{
    self.boolStatus = NO;
    self.realInput = NO;
    self.inWire = nil;
}

- (void)inWireBoolStatusDidChange{
    self.boolStatus = self.inWire.boolStatus;
}

- (void)inWireRealInputDidChange{
    self.realInput = self.inWire.realInput;
}

#pragma mark - Notifications of delegates
- (void)gatePositionDidChange{
    for (id<LPortDelegate> pointer in _delegatesSet){
        if ([pointer respondsToSelector:@selector(portPositionDidChange)]) {
            [pointer portPositionDidChange];
        }
    }
}

- (void)setBoolStatus:(BOOL)value{
    if(_boolStatus != value){
        _boolStatus = value;
        for (id<LPortDelegate> pointer in _delegatesSet){
            if ([pointer respondsToSelector:@selector(portBoolStatusDidChange:)]) {
                [pointer portBoolStatusDidChange:self.type];
            }
        }
        
    }
}

- (void)setRealInput:(BOOL)value{
    if(_realInput != value){
        _realInput = value;
        for (id<LPortDelegate> pointer in _delegatesSet){
            if ([pointer respondsToSelector:@selector(portRealInputDidChange:)]) {
                [pointer portRealInputDidChange:self.type];
            }
        }
        
    }
}

#pragma mark - Add/Remove delegate
- (void)addDelegate:(id<LPortDelegate>)delegate{
    [_delegatesSet addObject:delegate];
}

- (void)removeDelegate:(id<LPortDelegate>)delegate{
    [_delegatesSet removeObject:delegate];
}



@end
