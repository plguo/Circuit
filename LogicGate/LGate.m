//
//  LGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LGate.h"

#define kPositionKeyPath @"position"

@implementation LGate{
    BOOL _initializedUserInteraction;
    
    UIView* _selectedView;
}

#pragma mark - NSCoding
/*
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initGate];
    if (self) {
        self.center = [aDecoder decodeCGPointForKey:@"center"]
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGPoint:self.center forKey:@"center"];
    [aCoder encodeBool:_initializedUserInteraction forKey:@"initUserInteraction"];
    [aCoder encodeBool:_realInput forKey:@"realInput"];
}
*/

#pragma mark - Initialization

- (instancetype)initGate{
    self = [super init];
    if (self) {
        //Initialize image
        self.image = [UIImage imageNamed:[self imageName]];
        [self sizeToFit];
        
        //Initialize ports
        [self initPorts];
        [self updateRealIntput];
        [self updateOutput];
        
        [self setInPortDelegate];
        
        self.userInteractionEnabled = YES;
        _initializedUserInteraction = NO;
        
        [self.layer addObserver:self forKeyPath:kPositionKeyPath options:0 context:nil];
    }
    return self;
}

+ (instancetype)gate{
    return [[self alloc] initGate];
}


- (void)initPorts{
    /* Initialization of Ports*/
}

#pragma mark - Initialize User Interaction
- (void)initUserInteractionWithTarget:(id)target action:(SEL)sector{
    if (!_initializedUserInteraction) {
        _initializedUserInteraction = YES;
        for (LPort *aPort in _inPorts){
            UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:target action:sector];
            [aPort addGestureRecognizer:recognizer];
        }
        for (LPort *aPort in _outPorts){
            UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:target action:sector];
            [aPort addGestureRecognizer:recognizer];
        }
    }
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

#pragma mark - Gate info for subclasses
- (NSString*)imageName{
    return @"and_gate";
}

- (BOOL)isRealInputSource{
    return NO;
}

+ (NSString*)gateName{
    return @"GATE";
}

- (NSString*)booleanFormula{
    return @"Not enough information to generate boolean formula.";
}

#pragma mark - LObjectProtocol
- (void)objectRemove{
    if (self.delegate) {
        [self.delegate gateWillRemove];
    }
    [_inPorts makeObjectsPerformSelector:@selector(removeAllWire)];
    [_outPorts makeObjectsPerformSelector:@selector(removeAllWire)];
    [self removeFromSuperview];
}

#pragma mark - LPortDelegate
- (void)setInPortDelegate{
    for (LPort* port in _inPorts){
        [port addDelegate:self];
    }
}

- (void)portRealInputDidChange:(PortType)portType{
    [self updateRealIntput];
}

- (void)portBoolStatusDidChange:(PortType)portType{
    [self updateOutput];
}

- (void)portWireDidChange{
    if (self.delegate) {
        [self.delegate gateBooleanFormulaDidChange];
    }
}

#pragma mark - Selected Layer
- (void)setSelected:(BOOL)selected{
    if (selected != _selected) {
        _selected = selected;
        if (_selected) {
            if (!_selectedView) {
                _selectedView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, -5, -5)];
                _selectedView.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.86 alpha:0.2];
                _selectedView.layer.cornerRadius = 5;
                _selectedView.layer.borderWidth = 2;
                _selectedView.layer.borderColor = [UIColor blackColor].CGColor;
                _selectedView.userInteractionEnabled = NO;
                [self addSubview:_selectedView];
            }
        }else{
            if (_selectedView) {
                [_selectedView removeFromSuperview];
                _selectedView = nil;
            }
        }
    }
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kPositionKeyPath] && _initializedUserInteraction) {
        for (LPort *aPort in _inPorts){
            [aPort gatePositionDidChange];
        }
        for (LPort *aPort in _outPorts){
            [aPort gatePositionDidChange];
        }
    }
}

-(void)dealloc{
    [self.layer removeObserver:self forKeyPath:kPositionKeyPath];
}
@end
