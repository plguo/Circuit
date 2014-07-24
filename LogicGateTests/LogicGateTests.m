//
//  LogicGateTests.m
//  LogicGateTests
//
//  Created by Edward Guo on 2014-06-28.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LGate.h"
#import "LWire.h"
#import "LAndGate.h"
#import "LTrueOutput.h"

@interface LogicGateTests : XCTestCase

@end

@implementation LogicGateTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testBasicConnection
{
    LAndGate* gate1 = [[LAndGate alloc] initGate];
    LAndGate* gate2 = [[LAndGate alloc] initGate];
    LWire* wire1 = [[LWire alloc] initWire];
    [wire1 connectNewPort:gate1.outPorts[0]];
    [wire1 connectNewPort:gate2.inPorts[0]];
    
}


- (void)testLogicConnection
{
    LAndGate* gate1 = [[LAndGate alloc] initGate];
    LTrueOutput* output = [LTrueOutput gate];
    
    LWire* wire1 = [[LWire alloc] initWire];
    [wire1 connectNewPort:output.outPorts[0]];
    [wire1 connectNewPort:gate1.inPorts[0]];
    
    LWire* wire2 = [[LWire alloc] initWire];
    [wire2 connectNewPort:output.outPorts[0]];
    [wire2 connectNewPort:gate1.inPorts[1]];
    
    LPort* port = gate1.outPorts[0];
    XCTAssert(port.boolStatus, @"Gate Boolean Result Incorrect");
    
}



@end
