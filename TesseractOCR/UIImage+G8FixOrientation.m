//
//  UIImage+G8FixOrientation.m
//  Tesseract OCR iOS
//
//  Thanks to `binnyb` for answer from
//  http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
//
//  Created by Nikolay Volosatov on 09/01/15.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import "UIImage+G8FixOrientation.h"

@implementation UIImage (G8FixOrientation)

- (CGAffineTransform)transformForOrientationFix
{
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;

        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    return transform;
}

- (CGSize)sizeForOrientationFix
{
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            return CGSizeMake(self.size.height, self.size.width);

        default:
            return self.size;
    }
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;

    CGAffineTransform transform = [self transformForOrientationFix];

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGImageRef cgImage = self.CGImage;
    CGSize size = [self sizeForOrientationFix];
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width, size.height,
                                             CGImageGetBitsPerComponent(cgImage), 0,
                                             CGImageGetColorSpace(cgImage),
                                             CGImageGetBitmapInfo(cgImage));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, (CGRect){CGPointZero, size}, cgImage);

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
