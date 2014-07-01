//
//  ECGridViewTests.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ECGridView.h"

#define TORLENCE 0.5

@interface ECGridViewTests : XCTestCase
@end



@implementation ECGridViewTests{
    ECGridView* _gridView;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _gridView = nil;
    _gridView = [ECGridView generateGridWithNumberOfVerticalLines:3 HorizonLines:3];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasicSnapping{
    CGPoint expectPoint;
    CGRect torlenceRect;
    
    CGPoint expPointZero;  //X + 0, Y + 0
    
    CGPoint expPointRight; //X + 1
    CGPoint expPointLeft;  //X - 1
    
    CGPoint expPointUp;    //Y + 1
    CGPoint expPointDown;  //Y - 1
    
    expectPoint = CGPointMake(_gridView.marginWidth + _gridView.gridWidth * 2,
                              _gridView.marginWidth + _gridView.gridWidth * 2);
    torlenceRect = CGRectMake(expectPoint.x - TORLENCE, expectPoint.y - TORLENCE, TORLENCE*2, TORLENCE*2);
    expPointZero  = CGPointMake(expectPoint.x, expectPoint.y);
    
    expPointRight = CGPointMake(expectPoint.x + 1, expectPoint.y);
    expPointLeft  = CGPointMake(expectPoint.x - 1, expectPoint.y);
    
    expPointUp    = CGPointMake(expectPoint.x, expectPoint.y + 1);
    expPointDown  = CGPointMake(expectPoint.x, expectPoint.y - 1);
    
    CGPoint result = [_gridView closestPointInGridView:expPointZero];
    XCTAssert(CGRectContainsPoint(torlenceRect, result), @"PointZero moved");
    
    result = [_gridView closestPointInGridView:expPointRight];
    XCTAssert(CGRectContainsPoint(torlenceRect, result), @"Point Right isn't at the correct position");
    
    result = [_gridView closestPointInGridView:expPointLeft];
    XCTAssert(CGRectContainsPoint(torlenceRect, result), @"Point Left isn't at the correct position");
    
    result = [_gridView closestPointInGridView:expPointUp];
    XCTAssert(CGRectContainsPoint(torlenceRect, result), @"Point Up isn't at the correct position");
    
    result = [_gridView closestPointInGridView:expPointDown];
    XCTAssert(CGRectContainsPoint(torlenceRect, result), @"Point Down isn't at the correct position");
}

@end
