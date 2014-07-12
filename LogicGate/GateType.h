//
//  GateType.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#ifndef Circuit_GateType_h
#define Circuit_GateType_h
typedef NS_ENUM(NSInteger, GateType) {
    GateTypeDefult,
    GateTypeAND,
    GateTypeOR,
    GateTypeXOR,
    GateTypeNAND,
    GateTypeNOR,
    GateTypeXNOR,
    GateTypeNOT,
    GateTypeSwitch,
    GateTypeLightBulb,
    GateTypeTrueOutput
};
#endif
