//
//  VFCUtilities.h
//  VFCKit
//
//  Copyright (C) 2015 Xcelerate Media Inc. All Rights Reserved.
//  See License.txt for licensing information.
//

#ifdef DEBUG
#define VFCLog(fmt, ...) NSLog(@"VFCLog: " fmt, ##__VA_ARGS__)
#else
#define VFCLog(fmt, ...) do {} while(0)
#endif