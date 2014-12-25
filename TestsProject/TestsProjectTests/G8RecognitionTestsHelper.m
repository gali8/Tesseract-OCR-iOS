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
    return self.customThresholderEnabled ? sourceImage : nil;
}

@end
