//
//  VFCUtilities.h
//  VFCKit
//

@import Foundation;

// Comment this line if you want to disable logging.
//#warning Comment when releasing
#define VFC_DEBUG

#ifdef VFC_DEBUG
#define VFCLog(fmt, ...) NSLog(@"VFCLog: " fmt, ##__VA_ARGS__)
#else
#define VFCLog(fmt, ...) do {} while(0)
#endif