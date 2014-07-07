//
//  LPort.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPortDelegate.h"

#import "LGate.h"
#import "LWire.h"

@class LGate;
@class LWire;

@interface LPort : UIView<LObjectProtocol>

- (id)initWithPortType:(PortType)type SuperGate:(LGate*)gate Center:(CGPoint)center;
+ (instancetype)portType:(PortType)type SuperGate:(LGate *)gate Center:(CGPoint)center;

- (void)connectToInWire:(LWire*)inWire;

- (void)removeAllWire;

- (void)gatePositionDidChange;

- (void)inWireWillRemove;
- (void)inWireBoolStatusDidChange;
- (void)inWireRealInputDidChange;

- (void)addDelegate:(id<LPortDelegate>)delegate;
- (void)removeDelegate:(id<LPortDelegate>)delegate;

-(BOOL) allowToConnect;

@property (nonatomic,readonly) PortType type;
@property (nonatomic) BOOL realInput;
@property (nonatomic) BOOL boolStatus;
@property (nonatomic) BOOL wireConnectable;

@property (nonatomic,weak,readonly) LGate* superGate;
@property (nonatomic,weak) LWire* inWire;

@end
