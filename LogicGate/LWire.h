//
//  LWire.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LPortDelegate.h"
#import "LObjectProtocol.h"

#import "LPort.h"
#import "LGate.h"

@class LPort;

@interface LWire : UIView<PortDelegate,LObjectProtocol>

/*
-(id)initWithAnyPort:(Port*)sPort andStartPosition:(CGPoint)sPos;
-(id)initWithStartPort:(Port*)sPort EndPort:(Port*)ePort;
*/
- (instancetype)initWire;

- (void)drawWire;
- (void)drawWireWithPosition:(CGPoint)point;

- (void)connectNewPort:(LPort*)port;
//-(void) connectNewPort:(Port*)newPort withPosition:(CGPoint)point;

- (BOOL)allowConnectToThisPort:(LPort*)port;

@property(nonatomic, weak, readonly) LPort* startPort;
@property(nonatomic, weak, readonly) LPort* endPort;

@property(nonatomic) BOOL boolStatus;
@property(nonatomic) BOOL realInput;

@end
