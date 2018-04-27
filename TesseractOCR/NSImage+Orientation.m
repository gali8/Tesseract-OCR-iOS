//
//  NSImage+Orientation.m
//  Tesseract OCR iOS
//
//  Created by Hamilton Chapman on 16/04/2018.
//  Copyright © 2018 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_MAC
#import "NSImage+Orientation.h"
#import <AppKit/AppKit.h>

// TODO: Document
@implementation NSImage (Orientation)

- (NSInteger)imageOrientation {
    NSData *tiffData = [self TIFFRepresentation];
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)tiffData, NULL);

//    NSDictionary *tmpProps = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL));
//    NSDictionary *props = [tmpProps mutableCopy];
////    [props setValue:@(orientation) forKey:kCGImagePropertyOrientation];
//    NSLog(@"INSIDE PROPS %@", props);


    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                             nil];
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)options);

    if (imageProperties) {
//        NSNumber *width = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
//        NSNumber *height = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);

        NSInteger orientationValue = 1;
        CFTypeRef val = CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation);
        if (val) {
            BOOL success = CFNumberGetValue(val, kCFNumberNSIntegerType, &orientationValue);
//            NSLog(@"WELL DID IT WORK?!?!?!");
//            if (success) {
//                NSLog(@"IT WORKED");
//            } else {
//                NSLog(@"NOOOOOOOOOOPE");
//            }
        } else {
            NSLog(@"NO VAL ***********************************************");
        }

        CFRelease(imageProperties);

//        CGImagePropertyOrientation orientation = CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation);

//        NSLog(@"ORIENTATION %l", (long)orientationValue);

        CFRelease(imageSource);

        return orientationValue;
    } else {
        CFRelease(imageSource);
        // TODO: Does this make sense?
        return -1;
    }
}

@end

#endif
