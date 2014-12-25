//
//  UIImage+G8Equal.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 17.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "UIImage+G8Equal.h"

@implementation UIImage (G8Equal)

- (BOOL)g8_isEqualToImage:(UIImage *)image
{
    if (self == image) {
        return YES;
    }

    if (CGSizeEqualToSize(self.size, image.size) == NO) {
        return NO;
    }

    NSData *data = [image g8_normalizedData];
    NSData *originalData = [self g8_normalizedData];
    return [originalData isEqualToData:data];
}

- (NSData *)g8_normalizedData
{
    const CGSize pixelSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    UIGraphicsBeginImageContext(pixelSize);

    [self drawInRect:(CGRect){CGPointZero, pixelSize}];
    
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(drawnImage);
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
