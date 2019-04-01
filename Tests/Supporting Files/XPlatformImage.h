//
//  XPlatformImage.h
//  Tests-macOSTests
//
//  Created by Hamilton Chapman on 26/05/2018.
//  Copyright © 2018 hc.gg. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#endif

@interface XPlatformImage : NSObject

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (UIImage *)imageWithName:(NSString *)name;
#elif TARGET_OS_MAC
+ (NSImage *)imageWithName:(NSString *)name;
#endif

@end
