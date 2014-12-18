//
//  RecognitionTests.m
//  TestsProjectTests
//
//  Created by Nikolay Volosatov on 15.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <Kiwi/Kiwi.h>

#import "UIImage+G8Equal.h"

static NSTimeInterval const kG8MaximumRecognitionTime = 5.0;
static NSString *const kG8Languages = @"eng";
static NSString *const kG8WhiteList = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

SPEC_BEGIN(RecognitionTests)

void (^wait)(NSTimeInterval, BOOL (^)()) = ^(NSTimeInterval maximumWait, BOOL (^shouldKeepRunning)()) {
    NSDate *deadlineDate = [NSDate dateWithTimeInterval:maximumWait sinceDate:[NSDate date]];
    BOOL isDeadline = NO;
    while (shouldKeepRunning != nil && shouldKeepRunning() && isDeadline == NO) {
        if ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:deadlineDate] == NO) {
            break;
        }
        isDeadline = [[NSDate date] compare:deadlineDate] == NSOrderedDescending;
    }
};

__block G8Tesseract *tesseract;

let(image, ^id{
    return [UIImage imageNamed:@"image_sample.jpg"];
});

let(expectedThresholdedImage, ^id{
    return [UIImage imageNamed:@"image_sample_tr.png"];
});

let(engineMode, ^id{
    return theValue(G8OCREngineModeTesseractOnly);
});

void (^recognizeImage)() = ^() {
    tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages engineMode:[engineMode integerValue]];

    [tesseract setVariableValue:kG8WhiteList
                         forKey:kG8ParamTesseditCharWhitelist];

    UIImage *bwImage = [image blackAndWhite];
    [tesseract setImage:bwImage];
    [tesseract recognize];
};

void (^recognizeImageUsingOperation)() = ^() {
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] init];

    operation.tesseract.language = kG8Languages;
    operation.tesseract.engineMode = [engineMode integerValue];
    operation.tesseract.image = image;
    [operation.tesseract setVariableValue:kG8WhiteList forKey:kG8ParamTesseditCharWhitelist];

    tesseract = nil;
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        tesseract = recognizedTesseract;
    };

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

    wait(kG8MaximumRecognitionTime, ^{
        return (BOOL)(tesseract == nil);
    });
};

describe(@"Simple numbers", ^{

    it(@"Should recognize", ^{
        recognizeImage();

        NSString *recognizedText = [tesseract recognizedText];
        [[recognizedText should] containString:@"1234567890"];
    });

});

describe(@"NSOperation usage", ^{

    it(@"Should recognize", ^{
        recognizeImageUsingOperation();

        NSString *recognizedText = [tesseract recognizedText];
        [[recognizedText should] containString:@"1234567890"];
    });

});

describe(@"Thresholding", ^{

    UIImage *(^thresholdedImageForImage)(UIImage *) = ^(UIImage *sourceImage) {
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
        tesseract.image = image;

        return tesseract.thresholdedImage;
    };

    it(@"Should fetch thresholded image", ^{
        UIImage *onceThresholded = thresholdedImageForImage(image);
        UIImage *twiceThresholded = thresholdedImageForImage(onceThresholded);

        [[theValue([onceThresholded g8_isEqualToImage:expectedThresholdedImage]) should] beYes];
        [[theValue([twiceThresholded g8_isEqualToImage:expectedThresholdedImage]) should] beYes];
    });

});

SPEC_END
