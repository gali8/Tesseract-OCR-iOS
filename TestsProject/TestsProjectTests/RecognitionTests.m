//
//  RecognitionTests.m
//  TestsProjectTests
//
//  Created by Nikolay Volosatov on 15.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <Kiwi/Kiwi.h>

#import "UIImage+G8Equal.h"

static NSString *const kG8Languages = @"eng";

SPEC_BEGIN(RecognitionTests)

#pragma mark - Variables

__block G8Tesseract *tesseract;

__block G8OCREngineMode engineMode;
__block G8PageSegmentationMode pageSegmentationMode;
__block NSString *charWhitelist;
__block NSTimeInterval waitDeadline;
__block NSTimeInterval maxExpectedRecognitionTime;
__block BOOL isSimpleThresholding;
__block UIImage *image;

beforeEach(^{
    engineMode = G8OCREngineModeTesseractOnly;
    pageSegmentationMode = G8PageSegmentationModeAuto;
    charWhitelist = @"";
    waitDeadline = 180.0;
    maxExpectedRecognitionTime = 185.0;
    isSimpleThresholding = NO;
    image = nil;
});

#pragma mark - Helpers

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

void (^setupTesseract)() = ^{
    tesseract.language = kG8Languages;
    tesseract.engineMode = engineMode;
    tesseract.pageSegmentationMode = pageSegmentationMode;

    tesseract.charWhitelist = charWhitelist;
    tesseract.maximumRecognitionTime = waitDeadline;

    if (isSimpleThresholding) {
        [tesseract setImage:[image g8_blackAndWhite] withSimpleThreshold:0.5f];
    }
    else {
        tesseract.image = [image g8_blackAndWhite];
    }
};

void (^recognizeImage)() = ^{
    tesseract = [[G8Tesseract alloc] init];
    setupTesseract(tesseract);

    __block BOOL isDone = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        [tesseract recognize];
        isDone = YES;
    });

    wait(maxExpectedRecognitionTime, ^{
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

    wait(maxExpectedRecognitionTime, ^{
        return (BOOL)(isDone == NO);
    });

    if (isDone == NO) {
        [NSException raise:@"Tesseract stopped" format:@"Tesseract worked too long"];
    }
};

UIImage *(^thresholdedImageForImage)(UIImage *) = ^(UIImage *sourceImage) {
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];

    if (isSimpleThresholding) {
        [tesseract setImage:[image g8_blackAndWhite] withSimpleThreshold:0.5f];
    }
    else {
        tesseract.image = [image g8_blackAndWhite];
    }

    return tesseract.thresholdedImage;
};

#pragma mark - Test - Simple image

describe(@"Simple image", ^{

    beforeEach(^{
        image = [UIImage imageNamed:@"image_sample.jpg"];
        charWhitelist = @"0123456789";
    });

    it(@"Should recognize sync", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should recognize by queue", ^{
        [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should recognize with simple thresholding", ^{
        isSimpleThresholding = YES;

        [[theBlock(recognizeImage) shouldNot] raise];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should provide choices", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

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
        [[theBlock(recognizeImage) shouldNot] raise];

        NSArray *confidences = [tesseract confidencesByIteratorLevel:G8PageIteratorLevelWord];
        [[[confidences should] have:1] object];

        id blockObj = confidences.firstObject;
        [[blockObj should] beKindOfClass:[G8RecognizedBlock class]];
        G8RecognizedBlock *block = blockObj;

        [[block.text shouldNot] beEmpty];
        [[theValue(block.confidence) should] beGreaterThanOrEqualTo:theValue(0.0f)];
        [[theValue(block.level) should] equal:theValue(G8PageIteratorLevelWord)];
    });

    it(@"Should draw blocks on image", ^{
        [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

        NSArray *blocks = [tesseract confidencesByIteratorLevel:G8PageIteratorLevelSymbol];
        UIImage *blocksImage = [tesseract imageWithBlocks:blocks drawText:YES thresholded:NO];
        UIImage *expectedBlocksImage = [UIImage imageNamed:@"image_sample_bl"];
        
        [[theValue([blocksImage g8_isEqualToImage:expectedBlocksImage]) should] beYes];
    });

    it(@"Should fetch thresholded image", ^{
        UIImage *onceThresholded = thresholdedImageForImage(image);
        UIImage *twiceThresholded = thresholdedImageForImage(onceThresholded);
        UIImage *expectedThresholdedImage = [UIImage imageNamed:@"image_sample_tr"];

        [[theValue([onceThresholded g8_isEqualToImage:twiceThresholded]) should] beYes];
        [[theValue([onceThresholded g8_isEqualToImage:expectedThresholdedImage]) should] beYes];
    });

});

#pragma mark - Test - Blank image

describe(@"Blank image", ^{

    beforeEach(^{
        image = [UIImage imageNamed:@"image_blank"];
        isSimpleThresholding = YES;
    });

    it(@"Should recognize nothing", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

        NSString *recognizedText = [tesseract recognizedText];
        [[recognizedText should] beEmpty];
    });

    it(@"Should recognize noise with Otsu", ^{
        isSimpleThresholding = NO;

        [[theBlock(recognizeImage) shouldNot] raise];

        NSString *recognizedText = [tesseract recognizedText];
        [[recognizedText shouldNot] beEmpty];
    });

    it(@"Should be blank thresholded image", ^{
        UIImage *thresholdedImage = thresholdedImageForImage(image);

        [[theValue([thresholdedImage g8_isFilledWithColor:[UIColor blackColor]]) should] beYes];
    });

});

#pragma mark - Test - Well scaned page

describe(@"Well scaned page", ^{

    beforeEach(^{
        image = [UIImage imageNamed:@"well_scaned_page"];
    });

    it(@"Should recognize", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

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

    it(@"Should analyze layout", ^{
        pageSegmentationMode = G8PageSegmentationModeAutoOSD;

        [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

        CGFloat deskewAngle = tesseract.deskewAngle;
        [[theValue(ABS(deskewAngle)) should] beGreaterThan:theValue(FLT_EPSILON)];

        [[theValue(tesseract.orientation) should] equal:theValue(G8OrientationPageUp)];
        [[theValue(tesseract.writingDirection) should] equal:theValue(G8WritingDirectionLeftToRight)];
        [[theValue(tesseract.textlineOrder) should] equal:theValue(G8TextlineOrderTopToBottom)];
    });

    it(@"Should break by deadline", ^{
        waitDeadline = 2.0;

        [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

        [[tesseract shouldNot] beNil];
        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"Foreword"];
        [[recognizedText shouldNot] containString:@"Mathematcs"];
        [[[[tesseract confidencesByIteratorLevel:G8PageIteratorLevelWord] should] haveAtLeast:10] items];
    });
    
});

SPEC_END
