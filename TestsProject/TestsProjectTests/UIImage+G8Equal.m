//
//  UIImage+G8Equal.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 17.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "UIImage+G8Equal.h"

static CGFloat const kG8MinimalSimilarity = 0.99;

@implementation UIImage (G8Equal)

- (BOOL)g8_isEqualToImage:(UIImage *)image
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
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return pixels;
}

- (CGFloat)g8_similarityWithImage:(UIImage *)image
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

- (UIImage *)g8_normalizedImage
{
    const CGSize pixelSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    UIGraphicsBeginImageContext(pixelSize);

    [self drawInRect:(CGRect){CGPointZero, pixelSize}];
    
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return drawnImage;
}

- (BOOL)g8_isFilledWithColor:(UIColor *)color
{
    UIImage *sampleImage = [[self class] g8_imageFilledWithColor:color ofSize:self.size];
    return [self g8_isEqualToImage:sampleImage];
}

+ (UIImage *)g8_imageFilledWithColor:(UIColor *)color ofSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, (CGRect){CGPointZero, size});

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
