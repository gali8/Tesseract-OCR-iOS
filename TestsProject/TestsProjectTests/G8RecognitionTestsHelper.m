//
//  G8RecognitionTestsHelper.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 25.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8RecognitionTestsHelper.h"

@implementation G8RecognitionTestsHelper

- (UIImage *)thresholdedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage
{
    switch (self.customThresholderType) {
        case G8CustomThresholderNone:
            return nil;

        case G8CustomThresholderSimple:
            return sourceImage;

        case G8CustomThresholderResize:
            return [[self class] imageWithImage:sourceImage scaledToSizeWithSameAspectRatio:CGSizeMake(700.0f, 700.0f)];

        default:
            return nil;
    }
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;

    CGFloat scaleFactor = 1.0f;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;

    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor < heightFactor) {
            scaleFactor = widthFactor;
        }
        else {
            scaleFactor = heightFactor;
        }

        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }

    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));

    [sourceImage drawInRect: CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
