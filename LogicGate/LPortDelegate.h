//
//  LPortDelegate.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PortType){
    PortTypeInput,
    PortTypeOutput
};

@protocol LPortDelegate <NSObject>
@optional
-(void)portRealInputDidChange:(PortType)portType;
-(void)portBoolStatusDidChange:(PortType)portType;
-(void)portPositionDidChange;
-(void)portWillRemoveWires:(PortType)portType;
@end
