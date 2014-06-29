//
//  LGate.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPort.h"
#import "GateType.h"
#import "LObjectProtocol.h"

@interface LGate : UIImageView<LObjectProtocol>

- (instancetype)initGate;

- (void)initPorts;

- (void)updateOutput;
- (void)updateRealIntput;

- (NSString*)imageName;
- (BOOL)isRealInputSource;

//-(void)updatePortPositonInDurtion:(NSTimeInterval)duration;

- (NSString*)gateName;
- (NSString*)booleanFormula;

@property (nonatomic, readonly) GateType gateType;
@property (nonatomic, readonly) BOOL realInput;

@property (nonatomic, readonly) NSArray* inPorts;
@property (nonatomic, readonly) NSArray* outPorts;
@end
