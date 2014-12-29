//
//  G8RecognitionTestsHelper.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 25.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8RecognitionTestsHelper.h"

@implementation G8RecognitionTestsHelper

- (id)init
{
    self = [super init];
    if (self != nil) {
        _customPreprocessingType = G8CustomPreprocessingNone;
        _boundingSizeForResizing = CGSizeMake(700.0f, 700.0f);
    }
    return self;
}

- (UIImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage
{
    switch (self.customPreprocessingType) {
        case G8CustomPreprocessingNone:
            return nil;

        case G8CustomPreprocessingSimpleThreshold:
            return sourceImage;

        case G8CustomPreprocessingSimpleThresholdAndResize:
            return [[self class] imageWithImage:sourceImage
                scaledToSizeWithSameAspectRatio:self.boundingSizeForResizing];

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
