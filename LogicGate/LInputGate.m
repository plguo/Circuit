//
//  LInputGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LInputGate.h"

@implementation LInputGate

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _inputName = (NSString*)[coder decodeObjectForKey:@"InputName"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_inputName forKey:@"InputName"];
}

-(BOOL)isRealInputSource{
    return YES;
}

@end
