//
//  NSImage+G8Equal.h
//  TestsProject
//
//  Created by Nikolay Volosatov on 17.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSImage (G8Equal)

- (BOOL)g8_isEqualToImage:(NSImage *)image;
- (BOOL)g8_isFilledWithColor:(NSColor *)color;
+ (NSImage *)g8_imageFilledWithColor:(NSColor *)color ofSize:(CGSize)size;
+ (NSImage *)imageWithName:(NSString *)name;

@end
