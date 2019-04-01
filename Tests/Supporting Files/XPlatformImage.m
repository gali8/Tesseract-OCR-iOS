//
//  XPlatformImage.m
//  Tests-macOSTests
//
//  Created by Hamilton Chapman on 26/05/2018.
//  Copyright © 2018 hc.gg. All rights reserved.
//

#import "XPlatformImage.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import "UIImage+G8Equal.h"
#elif TARGET_OS_MAC
#import "NSImage+G8Equal.h"
#endif

@implementation XPlatformImage

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (UIImage *)imageWithName:(NSString *)name {
    return [UIImage imageWithName:name];
}
#elif TARGET_OS_MAC
+ (NSImage *)imageWithName:(NSString *)name {
    return [NSImage imageWithName:name];
}
#endif

@end
