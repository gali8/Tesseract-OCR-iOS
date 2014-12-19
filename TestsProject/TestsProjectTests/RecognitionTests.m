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

static NSString *const kG8Languages = @"eng";

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
    return [UIImage imageNamed:@"image_sample_tr"];
});

let(engineMode, ^id{
    return theValue(G8OCREngineModeTesseractOnly);
});

let(pageSegmentationMode, ^id{
    return theValue(G8PageSegmentationModeAutoOnly);
});

let(charWhitelist, ^id{
    return @"0123456789";
});

let(waitDeadline, ^id{
    return @(6.0);
});

let(maxExpectedRecognitionTime, ^id{
    return @(5.0);
});

void (^setupTesseract)() = ^{
    tesseract.language = kG8Languages;
    tesseract.engineMode = [engineMode integerValue];
    tesseract.pageSegmentationMode = [pageSegmentationMode integerValue];

    tesseract.charWhitelist = charWhitelist;
    tesseract.maximumRecognitionTime = [waitDeadline floatValue];

    tesseract.image = [image blackAndWhite];
};

void (^recognizeImage)() = ^{
    tesseract = [[G8Tesseract alloc] init];
    setupTesseract(tesseract);

    __block BOOL isDone = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        [tesseract recognize];
        isDone = YES;
    });

    wait([maxExpectedRecognitionTime floatValue], ^{
        return (BOOL)(isDone == NO);
    });

    if (isDone == NO) {
        [NSException raise:@"Tesseract stopped" format:@"Tesseract worked too long"];
    }
};

void (^recognizeImageUsingOperation)() = ^{
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] init];
    tesseract = operation.tesseract;

    setupTesseract();
    __block BOOL isDone = NO;
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        isDone = YES;
        tesseract = recognizedTesseract;
    };

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

    wait([maxExpectedRecognitionTime floatValue], ^{
        return (BOOL)(isDone == NO);
    });

    if (isDone == NO) {
        [NSException raise:@"Tesseract stopped" format:@"Tesseract worked too long"];
    }
};

void (^analyzeLayout)() = ^{
    tesseract = [[G8Tesseract alloc] init];

    tesseract.image = image;
    NSLog(@"%.2f", tesseract.deskewAngle);
};

UIImage *(^thresholdedImageForImage)(UIImage *) = ^(UIImage *sourceImage) {
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
    tesseract.image = image;

    return tesseract.thresholdedImage;
};


describe(@"Simple image", ^{

    let(image, ^id{
        return [UIImage imageNamed:@"image_sample.jpg"];
    });

    let(expectedThresholdedImage, ^id{
        return [UIImage imageNamed:@"image_sample_tr"];
    });

    let(waitDeadline, ^id{
        return @(1.0);
    });

    let(maxExpectedRecognitionTime, ^id{
        return @(1.2);
    });

    it(@"Should recognize sync", ^{
        recognizeImage();

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should recognize by queue", ^{
        recognizeImageUsingOperation();

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should provide choices", ^{
        recognizeImageUsingOperation();

        NSArray *choices = tesseract.characterChoices;
        for (id blocksObj in choices) {
            [[blocksObj should] beKindOfClass:[NSArray class]];

            for (id blockObj in (NSArray *)blocksObj) {
                [[blockObj should] beKindOfClass:[G8RecognizedBlock class]];
                G8RecognizedBlock *block = blockObj;

                [[block.text shouldNot] beEmpty];
                [[theValue(block.confidence) should] beGreaterThanOrEqualTo:theValue(0.0f)];
                [[theValue(block.level) should] equal:theValue(G8PageIteratorLevelSymbol)];
            }
        }
    });

    it(@"Should provide confidences", ^{
        recognizeImageUsingOperation();

        NSArray *confidences = [tesseract confidencesByIteratorLevel:G8PageIteratorLevelWord];
        [[[confidences should] have:1] object];

        id blockObj = confidences.firstObject;
        [[blockObj should] beKindOfClass:[G8RecognizedBlock class]];
        G8RecognizedBlock *block = blockObj;

        [[block.text shouldNot] beEmpty];
        [[theValue(block.confidence) should] beGreaterThanOrEqualTo:theValue(0.0f)];
        [[theValue(block.level) should] equal:theValue(G8PageIteratorLevelWord)];
    });

    it(@"Should fetch thresholded image", ^{
        UIImage *onceThresholded = thresholdedImageForImage(image);
        UIImage *twiceThresholded = thresholdedImageForImage(onceThresholded);

        [[theValue([onceThresholded g8_isEqualToImage:expectedThresholdedImage]) should] beYes];
        [[theValue([twiceThresholded g8_isEqualToImage:expectedThresholdedImage]) should] beYes];
    });

});

describe(@"Well scaned page", ^{

    let(image, ^id{
        return [UIImage imageNamed:@"well_scaned_page"];
    });

    let(charWhitelist, ^id{
        return @"";
    });

    let(waitDeadline, ^id{
        return @(10.0);
    });

    let(maxExpectedRecognitionTime, ^id{
        return @(9.0);
    });

    it(@"Should recognize", ^{
        [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"Foreword"];
        [[recognizedText should] containString:@"Division"];
        [[recognizedText should] containString:@"remove"];
        [[recognizedText should] containString:@"1954"];
    });

    it(@"Should fetch thresholded image", ^{
        UIImage *onceThresholded = thresholdedImageForImage(image);
        UIImage *twiceThresholded = thresholdedImageForImage(onceThresholded);

        [[theValue([onceThresholded g8_isEqualToImage:twiceThresholded]) should] beYes];
    });

    describe(@"OSD", ^{

        let(pageSegmentationMode, ^id{
            return theValue(G8PageSegmentationModeAutoOSD);
        });

        it(@"Should analyze layout", ^{
            [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

            CGFloat deskewAngle = tesseract.deskewAngle;
            [[theValue(ABS(deskewAngle)) should] beGreaterThan:theValue(FLT_EPSILON)];

            [[theValue(tesseract.orientation) should] equal:theValue(G8OrientationPageUp)];
            [[theValue(tesseract.writingDirection) should] equal:theValue(G8WritingDirectionLeftToRight)];
            [[theValue(tesseract.textlineOrder) should] equal:theValue(G8TextlineOrderTopToBottom)];
        });

    });

    describe(@"Deadline", ^{

        let(waitDeadline, ^id{
            return @(2.0);
        });

        let(maxExpectedRecognitionTime, ^id{
            return @(3.0);
        });

        it(@"Should break", ^{
            [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

            [[tesseract shouldNot] beNil];
            NSString *recognizedText = tesseract.recognizedText;
            [[recognizedText should] containString:@"Foreword"];
            [[recognizedText shouldNot] containString:@"Mathematcs"];
            [[[[tesseract confidencesByIteratorLevel:G8PageIteratorLevelWord] should] haveAtLeast:10] items];
        });

    });
    
});

SPEC_END
