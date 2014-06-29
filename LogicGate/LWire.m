//
//  LWire.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LWire.h"

@implementation LWire

- (instancetype)initWire{
    self = [super init];
    if (self) {
        _startPort = nil;
        _endPort = nil;
        
        _realInput = NO;
        _boolStatus = NO;
    }
    return self;
}


-(BOOL)allowConnectToThisPort:(LPort *)port{
    if (self.startPort && port.type == PortTypeOutput) {
        return NO;
    }
    if (self.endPort && port.type == PortTypeInput) {
        return NO;
    }
    if (self.startPort.superGate) {
        if ([self.startPort.superGate isEqual:port.superGate]){
            return NO;
        }
    }
    if (self.endPort.superGate) {
        if ([self.endPort.superGate isEqual:port.superGate]){
            return NO;
        }
    }
    return YES;
}

-(void)connectNewPort:(LPort *)port{
    if (port) {
        if ([self allowConnectToThisPort:port]){
            if ([port allowToConnect]) {
                if (port.type == PortTypeOutput) {
                    _startPort = port;
                } else {
                    _endPort = port;
                }
                [newPort connectToWire:self];
                [self drawLine];
                if (self.startPort && self.endPort) {
                    [self didConnectBothSides];
                }
                return;
            }
        }
    }
    [self kill];
}

-(void)connectNewPort:(Port*)newPort withPosition:(CGPoint)point{
    if (newPort) {
        if ([self wantConnectThisPort:newPort]){
            if ([newPort isAbleToConnect]) {
                if (newPort.type == PortTypeOutput) {
                    self.startPort = newPort;
                    self.startGate = newPort.ownerGate;
                } else {
                    self.endPort = newPort;
                    self.endGate = newPort.ownerGate;
                }
                [newPort connectToWire:self];
                [self drawLineWithPosition:point];
                if (self.startPort && self.endPort) {
                    [self didConnectBothSides];
                }
                return;
            }
        }
    }
    [self kill];
    
}


-(void) setBoolStatus:(BOOL)value{
    if(_boolStatus != value){
        _boolStatus = value;
        [self updateColor];
        if (self.endPort) {
            [self.endPort inWireBoolStatusDidChange];
        }
    }
}

-(void) setRealInput:(BOOL)value{
    if(_realInput != value){
        _realInput = value;
        [self updateColor];
        if (self.endPort){
            [self.endPort inWireRealInputDidChange];
        }
        
    }
}

-(void)portBoolStatusDidChange:(PortType)portType{
    if (self.startPort && portType == PortTypeOutput) {
        self.boolStatus = self.startPort.boolStatus;
    }
}

-(void)portPositionDidChange{
    [self performSelectorInBackground:@selector(drawLine) withObject:nil];
}

-(void)portRealInputDidChange:(PortType)portType{
    if (self.startPort && portType == PortTypeOutput) {
        self.realInput = self.startPort.realInput;
    }
}

-(void)portWillRemoveWires:(PortType)portType{
    if (self.startPort && portType != PortTypeOutput) {
        [self.startPort removeDelegate:self];
    }
    if (self.endPort && portType != PortTypeInput){
        [self.endPort inWireWillRemove];
        [self.endPort removeDelegate:self];
    }
    [self removeAllActions];
    [self removeFromParent];
}

-(void)updateColor{
    if (!self.realInput) {
        self.color = [SKColor redColor];
    } else {
        if (self.boolStatus) {
            self.color = [SKColor greenColor];
        } else {
            self.color = [SKColor blackColor];
        }
    }
}

-(void)kill{
    if (self.startPort) {
        [self.startPort removeDelegate:self];
    }
    if (self.endPort){
        [self.endPort inWireWillRemove];
        [self.endPort removeDelegate:self];
    }
    [self removeAllActions];
    [self removeFromParent];
}

-(void)didConnectBothSides{
    [self.startPort addDelegate:self];
    [self.endPort addDelegate:self];
    
    self.realInput = self.startPort.realInput;
    self.boolStatus = self.startPort.boolStatus;
    
    [self.startPort finishedConnectProcess];
    [self.endPort finishedConnectProcess];
}

-(void)drawLine{
    if (self.startPort && self.endPort) {
        CGPoint startPos = [self.startPort mapPosition];
        CGPoint endPos = [self.endPort mapPosition];
        [self drawPathWithStartPosition:startPos andEndPosition:endPos];
    }
}

-(void)drawLineWithPosition:(CGPoint)point{
    CGPoint startPos;
    CGPoint endPos;
    if (self.startPort && self.endPort) {
        startPos = [self.startPort mapPosition];
        endPos = [self.endPort mapPosition];
    } else if (self.startPort) {
        startPos = [self.startPort mapPosition];
        endPos = point;
    } else if (self.endPort) {
        endPos = [self.endPort mapPosition];
        startPos = point;
    } else {
        //Wire should have one or more port
        [self kill];
        return;
    }
    [self drawPathWithStartPosition:startPos andEndPosition:endPos];
}

-(void)drawPathWithStartPosition:(CGPoint)startPos andEndPosition:(CGPoint)endPos{
    CGFloat length = (CGFloat)sqrt(pow(startPos.x-endPos.x, 2)+pow(startPos.y-endPos.y, 2));
    self.size = CGSizeMake(length, 4);
    CGFloat x = endPos.x - startPos.x;
    CGFloat y = endPos.y - startPos.y;
    CGFloat rotation;
    if (x == 0.0) {
        rotation = M_PI_2;
    } else{
        rotation = atan(y/x);
        if (x<0.0) {
            rotation += M_PI;
        }else{
            rotation += M_PI*2;
        }
    }
    self.zRotation = rotation;
    self.position = CGPointMake((endPos.x + startPos.x)/2, (endPos.y + startPos.y)/2);
    
    /*
     CGMutablePathRef drawPath = CGPathCreateMutable();
     CGPathMoveToPoint(drawPath, NULL, startPos.x, startPos.y);
     CGPathAddLineToPoint(drawPath, NULL, endPos.x, endPos.y);
     self.path = drawPath;
     CGPathRelease(drawPath);
     */
}

@end
