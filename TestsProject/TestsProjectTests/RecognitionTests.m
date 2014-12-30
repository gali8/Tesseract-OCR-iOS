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

SPEC_BEGIN(RecognitionTests)

__block G8RecognitionTestsHelper *helper;

beforeEach(^{
    helper = [[G8RecognitionTestsHelper alloc] init];
});

#pragma mark - Test - Simple image

describe(@"Simple image", ^{

    beforeEach(^{
        helper.image = [UIImage imageNamed:@"image_sample.jpg"];
        helper.charWhitelist = @"0123456789";
    });

    it(@"Should recognize sync", ^{
        [helper recognizeImage];

        [[theValue(helper.tesseract.progress) should] equal:theValue(100)];

        NSString *recognizedText = helper.tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should recognize by queue", ^{
        [helper recognizeImageUsingOperation];

        [[theValue(helper.tesseract.progress) should] equal:theValue(100)];

        NSString *recognizedText = helper.tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    it(@"Should recognize with simple thresholding", ^{
        helper.customPreprocessingType = G8CustomPreprocessingSimpleThreshold;

        [helper recognizeImage];

        NSString *recognizedText = helper.tesseract.recognizedText;
        [[recognizedText should] containString:@"1234567890"];
    });

    describe(@"Subimage", ^{

        beforeEach(^{
            helper.rect = (CGRect){CGPointZero, {helper.image.size.width * 0.6f, helper.image.size.height}};
        });

        it(@"Should recognize subimage", ^{
            [helper recognizeImage];

            NSString *recognizedText = helper.tesseract.recognizedText;
            [[recognizedText should] containString:@"123456"];
            [[recognizedText shouldNot] containString:@"7890"];
        });

        it(@"Should recognize subimage after resizing", ^{
            helper.customPreprocessingType = G8CustomPreprocessingSimpleThresholdAndResize;

            [helper recognizeImage];

            NSString *recognizedText = helper.tesseract.recognizedText;
            [[recognizedText should] containString:@"123456"];
            [[recognizedText shouldNot] containString:@"7890"];
        });

    });

    it(@"Should provide choices", ^{
        [helper recognizeImage];

        NSArray *choices = helper.tesseract.characterChoices;
        for (id blocksObj in choices) {
            [[blocksObj should] beKindOfClass:[NSArray class]];

            for (id blockObj in (NSArray *)blocksObj) {
                [[blockObj should] beKindOfClass:[G8RecognizedBlock class]];
                G8RecognizedBlock *block = blockObj;

                [[block.text shouldNot] beEmpty];

                [[theValue(CGRectGetWidth(block.boundingBox)) should] beInTheIntervalFrom:theValue(0.0f)
                                                                                       to:theValue(1.0f)];
                [[theValue(CGRectGetHeight(block.boundingBox)) should] beInTheIntervalFrom:theValue(0.0f)
                                                                                        to:theValue(1.0f)];

                [[theValue(block.confidence) should] beGreaterThanOrEqualTo:theValue(0.0f)];
                [[theValue(block.level) should] equal:theValue(G8PageIteratorLevelSymbol)];
            }
        }
    });

    it(@"Should provide confidences", ^{
        [helper recognizeImage];

        NSArray *confidences = [helper.tesseract confidencesByIteratorLevel:G8PageIteratorLevelWord];
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
        [helper recognizeImage];

        NSArray *blocks = [helper.tesseract confidencesByIteratorLevel:G8PageIteratorLevelSymbol];
        UIImage *blocksImage = [helper.tesseract imageWithBlocks:blocks drawText:YES thresholded:NO];
        UIImage *expectedBlocksImage = [UIImage imageNamed:@"image_sample_bl"];
        
        [[theValue([blocksImage g8_isEqualToImage:expectedBlocksImage]) should] beYes];
    });

    it(@"Should fetch thresholded image", ^{
        UIImage *onceThresholded = [helper thresholdedImageForImage:helper.image];
        UIImage *twiceThresholded = [helper thresholdedImageForImage:onceThresholded];
        UIImage *expectedThresholdedImage = [UIImage imageNamed:@"image_sample_tr"];

        [[theValue([onceThresholded g8_isEqualToImage:twiceThresholded]) should] beYes];
        [[theValue([onceThresholded g8_isEqualToImage:expectedThresholdedImage]) should] beYes];
    });

});

#pragma mark - Test - Blank image

describe(@"Blank image", ^{

    beforeEach(^{
        helper.image = [UIImage imageNamed:@"image_blank"];
        helper.customPreprocessingType = G8CustomPreprocessingSimpleThreshold;
    });

    it(@"Should recognize nothing", ^{
        [helper recognizeImage];

        NSString *recognizedText = helper.tesseract.recognizedText;
        [[recognizedText should] beEmpty];
    });

    it(@"Should recognize noise with Otsu", ^{
        helper.customPreprocessingType = G8CustomPreprocessingNone;

        [helper recognizeImage];

        NSString *recognizedText = helper.tesseract.recognizedText;
        [[recognizedText shouldNot] beEmpty];
    });

    it(@"Should be blank thresholded image", ^{
        UIImage *thresholdedImage = [helper thresholdedImageForImage:helper.image];

        [[theValue([thresholdedImage g8_isFilledWithColor:[UIColor blackColor]]) should] beYes];
    });

});

#pragma mark - Test - Well scaned page

describe(@"Well scaned page", ^{

    static NSString *const kG8WellScanedFirstTitle = @"Foreword";
    static NSString *const kG8WellScanedFinalLongString = @"recommendations sometimes get acted on";

    beforeEach(^{
        helper.image = [UIImage imageNamed:@"well_scaned_page"];
    });

    it(@"Should recognize", ^{
        [helper recognizeImage];

        [[theValue(helper.tesseract.progress) should] equal:theValue(100)];

        NSString *recognizedText = helper.tesseract.recognizedText;
        [[recognizedText should] containString:kG8WellScanedFirstTitle];
        [[recognizedText should] containString:kG8WellScanedFinalLongString];

        [[recognizedText should] containString:@"Division"];
        [[recognizedText should] containString:@"remove"];
        [[recognizedText should] containString:@"1954"];
    });

    it(@"Should fetch thresholded image", ^{
        UIImage *onceThresholded = [helper thresholdedImageForImage:helper.image];
        UIImage *twiceThresholded = [helper thresholdedImageForImage:onceThresholded];

        [[theValue([onceThresholded g8_isEqualToImage:twiceThresholded]) should] beYes];
    });

    it(@"Should analyze layout", ^{
        helper.pageSegmentationMode = G8PageSegmentationModeAutoOSD;

        [helper recognizeImage];

        CGFloat deskewAngle = helper.tesseract.deskewAngle;
        [[theValue(ABS(deskewAngle)) should] beGreaterThan:theValue(FLT_EPSILON)];

        [[theValue(helper.tesseract.orientation) should] equal:theValue(G8OrientationPageUp)];
        [[theValue(helper.tesseract.writingDirection) should] equal:theValue(G8WritingDirectionLeftToRight)];
        [[theValue(helper.tesseract.textlineOrder) should] equal:theValue(G8TextlineOrderTopToBottom)];
    });

    it(@"Should break by deadline", ^{
        helper.waitDeadline = 1.0;

        [helper recognizeImageUsingOperation];

        [[helper.tesseract shouldNot] beNil];
        [[theValue(helper.tesseract.progress) should] beLessThan:theValue(100)];

        NSString *recognizedText = helper.tesseract.recognizedText;
        [[recognizedText should] containString:kG8WellScanedFirstTitle];
        [[recognizedText shouldNot] containString:kG8WellScanedFinalLongString];

        [[[[helper.tesseract confidencesByIteratorLevel:G8PageIteratorLevelWord] should] haveAtLeast:10] items];
    });
    
});

SPEC_END
