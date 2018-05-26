//
//  NSImage+G8Equal.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 17.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "NSImage+G8Equal.h"

static CGFloat const kG8MinimalSimilarity = 0.99;

@implementation NSImage (G8Equal)

- (BOOL)g8_isEqualToImage:(NSImage *)image
{
    if (self == image) {
        return YES;
    }

    CGFloat similarity = [[self g8_normalizedImage] g8_similarityWithImage:[image g8_normalizedImage]];
    return similarity > kG8MinimalSimilarity;
}

- (uint32_t *)pixels
{
    CGSize size = [self size];
    int width = size.width;
    int height = size.height;

    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    memset(pixels, 0, width * height * sizeof(uint32_t));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);

    NSRect imageRect = NSMakeRect(0, 0, width, height);

    // TODO: Should context really be NULL here?
    // TODO: Why do I need the struct tag?
    struct CGImage *cgImage = [self CGImageForProposedRect: &imageRect context: NULL hints: nil];

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return pixels;
}

- (CGFloat)g8_similarityWithImage:(NSImage *)image
{
    if (CGSizeEqualToSize(self.size, image.size) == NO) {
        return 0.0;
    }

    CGSize size = [self size];
    int width = size.width;
    int height = size.height;

    uint32_t *p1 = [self pixels];
    uint32_t *p2 = [image pixels];

    NSInteger numDifferences = 0;
    NSInteger totalCompares = width * height;

    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            if (p1[y * width + x] != p2[y * width + x]) {
                ++numDifferences;
            }
        }
    }

    free(p1);
    free(p2);

    return 1.0 - (CGFloat)numDifferences / totalCompares;
}

- (NSImage *)g8_normalizedImage
{
    //    const CGSize pixelSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    // TODO: FIXME USING

    //    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
    //                             initWithBitmapDataPlanes:NULL
    //                             pixelsWide:scaledSize.width
    //                             pixelsHigh:scaledSize.height
    //                             bitsPerSample:8
    //                             samplesPerPixel:4
    //                             hasAlpha:YES
    //                             isPlanar:NO
    //                             colorSpaceName:NSCalibratedRGBColorSpace
    //                             bytesPerRow:0
    //                             bitsPerPixel:0];
    //    rep.size = scaledSize;
    //
    //    [NSGraphicsContext saveGraphicsState];
    //    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    //    [sourceImage drawInRect:NSMakeRect(0, 0, scaledSize.width, scaledSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    //    [NSGraphicsContext restoreGraphicsState];
    //
    //    NSImage *newImage = [[NSImage alloc] initWithSize:scaledSize];
    //    [newImage addRepresentation:rep];
    //    return newImage;

    const CGSize pixelSize = CGSizeMake(self.size.width, self.size.height);

    NSImage *drawnImage = [[NSImage alloc] initWithSize: NSMakeSize(self.size.width, self.size.height)];

    [drawnImage lockFocus];

//    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];

    [self drawInRect:(CGRect){CGPointZero, pixelSize}];

    [drawnImage unlockFocus];

    return drawnImage;
}

- (BOOL)g8_isFilledWithColor:(NSColor *)color
{
    // TODO: FIX MY SIZE
    NSImage *sampleImage = [[self class] g8_imageFilledWithColor:color ofSize:self.size];
    return [self g8_isEqualToImage:sampleImage];
}

+ (NSImage *)g8_imageFilledWithColor:(NSColor *)color ofSize:(CGSize)size
{
    // TODO: FIXME USING

    //    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
    //                             initWithBitmapDataPlanes:NULL
    //                             pixelsWide:scaledSize.width
    //                             pixelsHigh:scaledSize.height
    //                             bitsPerSample:8
    //                             samplesPerPixel:4
    //                             hasAlpha:YES
    //                             isPlanar:NO
    //                             colorSpaceName:NSCalibratedRGBColorSpace
    //                             bytesPerRow:0
    //                             bitsPerPixel:0];
    //    rep.size = scaledSize;
    //
    //    [NSGraphicsContext saveGraphicsState];
    //    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    //    [sourceImage drawInRect:NSMakeRect(0, 0, scaledSize.width, scaledSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    //    [NSGraphicsContext restoreGraphicsState];
    //
    //    NSImage *newImage = [[NSImage alloc] initWithSize:scaledSize];
    //    [newImage addRepresentation:rep];
    //    return newImage;
    NSImage *image = [[NSImage alloc] initWithSize: size];

    [image lockFocus];

    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];

    [color setFill];
    CGContextFillRect(context, (CGRect){CGPointZero, size});

    [image unlockFocus];

    return image;
}

+ (NSImage *)imageWithName:(NSString *)name
{
    NSString *filePath = [[[NSBundle.mainBundle resourcePath] stringByAppendingString:@"/images/"] stringByAppendingString:name];
    return [[NSImage alloc] initWithContentsOfFile:filePath];
}

@end
