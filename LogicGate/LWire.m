//
//  LWire.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LWire.h"

#define COLOR_NO_REAL_INPUT [UIColor redColor]

@implementation LWire{
    UIColor* _color;
}

#pragma mark - Initialization
- (instancetype)initWire{
    self = [super init];
    if (self) {
        _startPort = nil;
        _endPort = nil;
        
        _realInput = NO;
        _boolStatus = NO;
        
        _color = COLOR_NO_REAL_INPUT;
        
        CAShapeLayer* shapeLayer = (CAShapeLayer*)self.layer;
        shapeLayer.fillColor = nil;
        shapeLayer.strokeColor = _color.CGColor;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 4.0;
        
    }
    return self;
}

+ (instancetype)wireWithPortGestureRecognizer:(UIPanGestureRecognizer*)recognizer{
    LWire* wire = [[self alloc] initWire];
    [wire connectNewPort:(LPort*)recognizer.view];
    [wire drawWireWithPosition:[recognizer locationInView:recognizer.view.superview]];
    [recognizer addTarget:wire action:@selector(handlePanFrom:)];
    return wire;
}

#pragma mark - Port connection
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
                    [_startPort addDelegate:self];
                    self.realInput = _startPort.realInput;
                    self.boolStatus = _startPort.boolStatus;
                } else {
                    _endPort = port;
                    [_endPort addDelegate:self];
                    [_endPort connectToInWire:self];
                }
                if (_startPort && _endPort) {
                    [self drawWire];
                }
                return;
            }
        }
    }
}

#pragma mark - Update values
-(void)setBoolStatus:(BOOL)value{
    if(_boolStatus != value){
        _boolStatus = value;
        [self updateColor];
        if (self.endPort) {
            [self.endPort inWireBoolStatusDidChange];
        }
    }
}

-(void)setRealInput:(BOOL)value{
    if(_realInput != value){
        _realInput = value;
        [self updateColor];
        if (self.endPort){
            [self.endPort inWireRealInputDidChange];
        }
        
    }
}

-(void)updateColor{
    UIColor* newColor;
    if (!self.realInput) {
        newColor = [UIColor redColor];
    } else {
        if (self.boolStatus) {
            newColor = [UIColor greenColor];
        } else {
            newColor = [UIColor blackColor];
        }
    }
    if (![_color isEqual:newColor]) {
        _color = newColor;
        CAShapeLayer* layer = (CAShapeLayer*)self.layer;
        layer.strokeColor = _color.CGColor;
    }
}

#pragma mark - Handle Drag
-(void)handlePanFrom:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self drawWireWithPosition:[recognizer locationInView:recognizer.view.superview.superview]];
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        UIView* view = [recognizer.view.superview.superview hitTest:[recognizer locationInView:recognizer.view.superview.superview]
                                                withEvent:nil];
        if (view) {
            if ([view isKindOfClass:[LPort class]]) {
                [self connectNewPort:(LPort *)view];
            }
        }
        [recognizer removeTarget:self action:@selector(handlePanFrom:)];
        if (!(_startPort && _endPort)) {
            [self remove];
        }
    }
}

#pragma mark - LPortDelegate
-(void)portBoolStatusDidChange:(PortType)portType{
    if (self.startPort && portType == PortTypeOutput) {
        self.boolStatus = self.startPort.boolStatus;
    }
}

-(void)portPositionDidChange{
    [self drawWire];
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
    [self removeFromSuperview];
}

#pragma mark - LObjectProtocol
-(void)remove{
    if (self.startPort) {
        [self.startPort removeDelegate:self];
    }
    if (self.endPort){
        [self.endPort inWireWillRemove];
        [self.endPort removeDelegate:self];
    }
    [self removeFromSuperview];
}

#pragma mark - Graphic Logic
+ (Class)layerClass{
    return [CAShapeLayer class];
}

-(void)drawWire{
    if (self.startPort && self.endPort && self.superview) {
        CGPoint startPos = [self.superview convertPoint:self.startPort.center fromView:self.startPort.superview];
        CGPoint endPos = [self.superview convertPoint:self.endPort.center fromView:self.endPort.superview];
        [self drawPathWithStartPosition:startPos andEndPosition:endPos];
    }
}

-(void)drawWireWithPosition:(CGPoint)point{
    if (self.superview) {
        CGPoint startPos;
        CGPoint endPos;
        if (self.startPort) {
            startPos = [self.superview convertPoint:self.startPort.center fromView:self.startPort.superview];
            endPos = point;
        } else if (self.endPort) {
            endPos = [self.superview convertPoint:self.endPort.center fromView:self.endPort.superview];
            startPos = point;
        } else {
            //Wire should have one or more port
            return;
        }
        [self drawPathWithStartPosition:startPos andEndPosition:endPos];
    }
}

#pragma mark - Graphic Draw
-(void)drawPathWithStartPosition:(CGPoint)startPosition andEndPosition:(CGPoint)endPosition{
    CGPoint minPos = CGPointMake(MIN(startPosition.x, endPosition.x), MIN(startPosition.y, endPosition.y));
    
    startPosition.x -= minPos.x;
    startPosition.y -= minPos.y;
    endPosition.x -= minPos.x;
    endPosition.y -= minPos.y;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPosition];
    [bezierPath addLineToPoint:endPosition];
    
    CAShapeLayer* layer = (CAShapeLayer*)self.layer;
    layer.path = bezierPath.CGPath;
    
    self.frame = CGRectMake(minPos.x, minPos.y, self.frame.size.width, self.frame.size.height);
}


@end
