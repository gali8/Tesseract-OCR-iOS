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

#import "G8RecognitionTestsHelper.h"
#import "UIImage+G8Equal.h"

static NSString *const kG8Languages = @"eng";

SPEC_BEGIN(RecognitionTests)

#pragma mark - Variables

__block G8RecognitionTestsHelper *helper;
__block G8Tesseract *tesseract;
__block G8CustomPreprocessing customPreprocessing;

__block G8OCREngineMode engineMode;
__block G8PageSegmentationMode pageSegmentationMode;
__block NSString *charWhitelist;
__block NSTimeInterval waitDeadline;
__block NSTimeInterval maxExpectedRecognitionTime;
__block CGRect rect;
__block NSInteger sourceResolution;
__block UIImage *image;

beforeEach(^{
    helper = [[G8RecognitionTestsHelper alloc] init];

    engineMode = G8OCREngineModeTesseractOnly;
    pageSegmentationMode = G8PageSegmentationModeAuto;
    charWhitelist = @"";
    waitDeadline = 180.0;
    maxExpectedRecognitionTime = 185.0;
    customPreprocessing = G8CustomPreprocessingNone;
    rect = CGRectZero;
    sourceResolution = 0;
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
    helper.customPreprocessingType = customPreprocessing;
    tesseract.delegate = helper;

    tesseract.language = kG8Languages;
    tesseract.engineMode = engineMode;
    tesseract.pageSegmentationMode = pageSegmentationMode;

    tesseract.charWhitelist = charWhitelist;
    tesseract.maximumRecognitionTime = waitDeadline;
};

void (^recognizeImage)() = ^{
    tesseract = [[G8Tesseract alloc] init];
    setupTesseract(tesseract);

    tesseract.image = [image g8_blackAndWhite];
    if (CGRectEqualToRect(rect, CGRectZero) == NO) {
        tesseract.rect = rect;
    }
    if (sourceResolution > 0) {
        tesseract.sourceResolution = sourceResolution;
    }

    [tesseract recognize];
};

void (^recognizeImageUsingOperation)() = ^{
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] init];
    tesseract = operation.tesseract;
    setupTesseract();

    tesseract.image = [image g8_blackAndWhite];
    tesseract.rect = rect;

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
    tesseract = [[G8Tesseract alloc] init];
    setupTesseract();

    tesseract.image = [sourceImage g8_blackAndWhite];

    return tesseract.thresholdedImage;
};

#pragma mark - Test - Simple image

describe(@"Simple image", ^{

    beforeEach(^{
        image = [UIImage imageNamed:@"image_sample.jpg"];
        rect = (CGRect){CGPointZero, image.size};
        charWhitelist = @"0123456789";
    });

    it(@"Should recognize sync", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

        [[theValue(tesseract.progress) should] equal:theValue(100)];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should recognize by queue", ^{
        [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

        [[theValue(tesseract.progress) should] equal:theValue(100)];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should recognize with simple thresholding", ^{
        customPreprocessing = G8CustomPreprocessingSimpleThreshold;

        [[theBlock(recognizeImage) shouldNot] raise];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    describe(@"Subimage", ^{

        beforeEach(^{
            rect = (CGRect){CGPointZero, {image.size.width * 0.6f, image.size.height}};
        });

        it(@"Should recognize subimage", ^{
            [[theBlock(recognizeImage) shouldNot] raise];

            NSString *recognizedText = tesseract.recognizedText;
            [[recognizedText should] containString:@"123456"];
            [[recognizedText shouldNot] containString:@"7890"];
        });

        it(@"Should recognize subimage after resizing", ^{
            customPreprocessing = G8CustomPreprocessingSimpleThresholdAndResize;

            [[theBlock(recognizeImage) shouldNot] raise];

            NSString *recognizedText = tesseract.recognizedText;
            [[recognizedText should] containString:@"123456"];
            [[recognizedText shouldNot] containString:@"7890"];
        });

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
                [[theValue(CGRectGetWidth(block.boundingBox)) should] beInTheIntervalFrom:theValue(0.0f) to:theValue(1.0f)];
                [[theValue(CGRectGetHeight(block.boundingBox)) should] beInTheIntervalFrom:theValue(0.0f) to:theValue(1.0f)];
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
        [[theValue(CGRectGetWidth(block.boundingBox)) should] beInTheIntervalFrom:theValue(0.0f) to:theValue(1.0f)];
        [[theValue(CGRectGetHeight(block.boundingBox)) should] beInTheIntervalFrom:theValue(0.0f) to:theValue(1.0f)];
        [[theValue(block.confidence) should] beGreaterThanOrEqualTo:theValue(0.0f)];
        [[theValue(block.level) should] equal:theValue(G8PageIteratorLevelWord)];
    });

    it(@"Should draw blocks on image", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

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
        rect = (CGRect){CGPointZero, image.size};
        customPreprocessing = G8CustomPreprocessingSimpleThreshold;
    });

    it(@"Should recognize nothing", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

        NSString *recognizedText = [tesseract recognizedText];
        [[recognizedText should] beEmpty];
    });

    it(@"Should recognize noise with Otsu", ^{
        customPreprocessing = G8CustomPreprocessingNone;

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

    static NSString *const kG8WellScanedFirstTitle = @"Foreword";
    static NSString *const kG8WellScanedFinalLongString = @"recommendations sometimes get acted on";

    beforeEach(^{
        image = [UIImage imageNamed:@"well_scaned_page"];
        rect = (CGRect){CGPointZero, image.size};
    });

    it(@"Should recognize", ^{
        [[theBlock(recognizeImage) shouldNot] raise];

        [[theValue(tesseract.progress) should] equal:theValue(100)];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:kG8WellScanedFirstTitle];
        [[recognizedText should] containString:kG8WellScanedFinalLongString];

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

        [[theBlock(recognizeImage) shouldNot] raise];

        CGFloat deskewAngle = tesseract.deskewAngle;
        [[theValue(ABS(deskewAngle)) should] beGreaterThan:theValue(FLT_EPSILON)];

        [[theValue(tesseract.orientation) should] equal:theValue(G8OrientationPageUp)];
        [[theValue(tesseract.writingDirection) should] equal:theValue(G8WritingDirectionLeftToRight)];
        [[theValue(tesseract.textlineOrder) should] equal:theValue(G8TextlineOrderTopToBottom)];
    });

    it(@"Should break by deadline", ^{
        waitDeadline = 1.0;

        [[theBlock(recognizeImageUsingOperation) shouldNot] raise];

        [[tesseract shouldNot] beNil];
        [[theValue(tesseract.progress) should] beLessThan:theValue(100)];

        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] containString:kG8WellScanedFirstTitle];
        [[recognizedText shouldNot] containString:kG8WellScanedFinalLongString];
        [[[[tesseract confidencesByIteratorLevel:G8PageIteratorLevelWord] should] haveAtLeast:10] items];
    });
    
});

SPEC_END
