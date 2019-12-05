//
//  RecognitionTests.m
//  TestsProjectTests
//
//  Created by Nikolay Volosatov on 15.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import "UIImage+G8Equal.h"
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#import <TesseractOCRmacOS/TesseractOCR.h>
#import "NSImage+G8Equal.h"
#endif

#import <Kiwi/Kiwi.h>
#import "G8RecognitionTestsHelper.h"
#import "Defaults.h"
#import "NSData+G8Equal.h"
#import "XPlatformImage.h"

SPEC_BEGIN(RecognitionTests)

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
void (^testImageWithOrientationShouldContainText)(UIImage *image, UIImageOrientation orientation, NSString *text) = ^(UIImage *image, UIImageOrientation orientation, NSString *text) {
    UIImage *rotatedImage = [UIImage imageWithCGImage:image.CGImage
                                                scale:image.scale
                                          orientation:orientation];

    NSAssert(image.imageOrientation != rotatedImage.imageOrientation, @"Error! Image has not been rotated");

    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
    tesseract.image = rotatedImage;

    [[theBlock(^{
        [tesseract recognize];
    }) shouldNot] raise];

    NSString *recognizedText = tesseract.recognizedText;
    [[recognizedText should] containString:text];

    UIImage *thresholdedImage = tesseract.thresholdedImage;
    [[theValue(thresholdedImage.imageOrientation) should] equal:theValue(UIImageOrientationUp)];
};
#endif

__block G8RecognitionTestsHelper *helper;

beforeEach(^{
    helper = [[G8RecognitionTestsHelper alloc] init];
});

#pragma mark - Test - Simple image

describe(@"Simple image", ^{

    beforeEach(^{
        helper.image = [XPlatformImage imageWithName:@"image_sample.jpg"];
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

    #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    it(@"Should recognize regardless of orientation", ^{
        NSString *text = @"1234567890";
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"image_sample_left.jpg"], UIImageOrientationLeft, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"image_sample_right.jpg"], UIImageOrientationRight, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"image_sample_down.jpg"], UIImageOrientationDown, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"image_sample_up_mirrored.jpg"], UIImageOrientationUpMirrored, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"image_sample_left_mirrored.jpg"], UIImageOrientationLeftMirrored, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"image_sample_right_mirrored.jpg"], UIImageOrientationRightMirrored, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"image_sample_down_mirrored.jpg"], UIImageOrientationDownMirrored, text);
    });
    #endif

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

        NSArray *confidences = [helper.tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelWord];
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

    it(@"Should clamp source resolution", ^{
        [helper setupTesseract];

        [[theValue(helper.tesseract.sourceResolution) should] equal:theValue(kG8DefaultResolution)];

        helper.tesseract.sourceResolution = 50;
        [[theValue(helper.tesseract.sourceResolution) should] beInTheIntervalFrom:theValue(kG8MinCredibleResolution)
                                                                               to:theValue(kG8MaxCredibleResolution)];

        helper.tesseract.sourceResolution = 3000;
        [[theValue(helper.tesseract.sourceResolution) should] beInTheIntervalFrom:theValue(kG8MinCredibleResolution)
                                                                               to:theValue(kG8MaxCredibleResolution)];
    });

    it(@"Should draw blocks on image", ^{
        [helper recognizeImage];

        NSArray *blocks = [helper.tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelSymbol];

        #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIImage *blocksImage = [helper.tesseract imageWithBlocks:blocks drawText:YES thresholded:NO];
        UIImage *expectedBlocksImage = [UIImage imageWithName:@"image_sample_bl.png"];
        #elif TARGET_OS_MAC
        NSImage *blocksImage = [helper.tesseract imageWithBlocks:blocks drawText:YES thresholded:NO];
        NSImage *expectedBlocksImage = [NSImage imageWithName:@"image_sample_bl_mac.png"];
        #endif

        [[theValue([blocksImage g8_isEqualToImage:expectedBlocksImage]) should] beYes];
    });

    it(@"Should fetch thresholded image", ^{
        #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIImage *onceThresholded = [helper thresholdedImageForImage:helper.image];
        UIImage *twiceThresholded = [helper thresholdedImageForImage:onceThresholded];
        UIImage *expectedThresholdedImage = [UIImage imageWithName:@"image_sample_tr.png"];
        #elif TARGET_OS_MAC
        NSImage *onceThresholded = [helper thresholdedImageForImage:helper.image];
        NSImage *twiceThresholded = [helper thresholdedImageForImage:onceThresholded];
        NSImage *expectedThresholdedImage = [NSImage imageWithName:@"image_sample_tr.png"];
        #endif

        [[theValue([onceThresholded g8_isEqualToImage:twiceThresholded]) should] beYes];
        [[theValue([onceThresholded g8_isEqualToImage:expectedThresholdedImage]) should] beYes];
    });

});

#pragma mark - Test - Blank image

describe(@"Blank image", ^{

    beforeEach(^{
        helper.image = [XPlatformImage imageWithName:@"image_blank.png"];
        helper.customPreprocessingType = G8CustomPreprocessingSimpleThreshold;
    });

    it(@"Should not crash when accessing character choices", ^{
        [helper recognizeImage];
        [[theBlock(^{
            [helper.tesseract characterChoices];
        }) shouldNot] raise];
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
        #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIImage *thresholdedImage = [helper thresholdedImageForImage:helper.image];
        UIColor *color = [UIColor blackColor];
        #elif TARGET_OS_MAC
        NSImage *thresholdedImage = [helper thresholdedImageForImage:helper.image];
        NSColor *color = [NSColor blackColor];
        #endif

        [[theValue([thresholdedImage g8_isFilledWithColor:color]) should] beYes];
    });

});

#pragma mark - Test - Well scaned page

describe(@"Well scanned page", ^{

    static NSString *const kG8WellScanedFirstTitle = @"Foreword";
    static NSString *const kG8WellScanedFinalLongString = @"recommendations sometimes get acted on";

    beforeEach(^{
        helper.image = [XPlatformImage imageWithName:@"well_scanned_page.png"];
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
        #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIImage *onceThresholded = [helper thresholdedImageForImage:helper.image];
        UIImage *twiceThresholded = [helper thresholdedImageForImage:onceThresholded];
        #elif TARGET_OS_MAC
        NSImage *onceThresholded = [helper thresholdedImageForImage:helper.image];
        NSImage *twiceThresholded = [helper thresholdedImageForImage:onceThresholded];
        #endif

        [[theValue([onceThresholded g8_isEqualToImage:twiceThresholded]) should] beYes];
    });

    it(@"Should not crash analyze layout", ^{
        helper.pageSegmentationMode = G8PageSegmentationModeOSDOnly;

        [helper recognizeImage];

        [[theBlock(^{
            [helper.tesseract deskewAngle];
        }) shouldNot] raise];
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

        [[[[helper.tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelWord] should] haveAtLeast:10] items];
    });

    #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    it(@"Should recognize regardless of orientation", ^{
        NSString *text = kG8WellScanedFinalLongString;
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"well_scanned_page_left"], UIImageOrientationLeft, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"well_scanned_page_right"], UIImageOrientationRight, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"well_scanned_page_down"], UIImageOrientationDown, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"well_scanned_page_up_mirrored"], UIImageOrientationUpMirrored, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"well_scanned_page_left_mirrored"], UIImageOrientationLeftMirrored, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"well_scanned_page_right_mirrored"], UIImageOrientationRightMirrored, text);
        testImageWithOrientationShouldContainText([XPlatformImage imageWithName:@"well_scanned_page_down_mirrored"], UIImageOrientationDownMirrored, text);
    });
    #endif
});

#pragma mark - hierarchical data

describe(@"Hierarchical Data", ^{

    NSArray *(^recognizedHierarchicalBlocksForImageWithName)(NSString *imageName, G8PageIteratorLevel level) = ^NSArray*(NSString *imageName, G8PageIteratorLevel level) {
        helper.image = [XPlatformImage imageWithName:imageName];
        [helper recognizeImage];
        return [helper.tesseract recognizedHierarchicalBlocksByIteratorLevel:level];
    };

    it(@"Should not crash with empty image", ^{
        [[theBlock(^{
            helper.image = [XPlatformImage imageWithName:@"image_blank.png"];
            [helper recognizeImage];
            [helper.tesseract recognizedHierarchicalBlocksByIteratorLevel:G8PageIteratorLevelBlock];
        }) shouldNot] raise]; 
    });
    
    it(@"Should recognize structure of sample image", ^{
        NSArray *blocks = recognizedHierarchicalBlocksForImageWithName(@"image_sample.jpg", G8PageIteratorLevelBlock);
        [[[blocks should] haveAtLeast:1] items];

        NSArray *paras = ((G8HierarchicalRecognizedBlock*)[blocks objectAtIndex:0]).childBlocks;
        [[[paras should] haveAtLeast:1] items];

        NSArray *lines = ((G8HierarchicalRecognizedBlock*)[paras objectAtIndex:0]).childBlocks;
        [[[lines should] haveAtLeast:1] items];

        NSArray *words = ((G8HierarchicalRecognizedBlock*)[lines objectAtIndex:0]).childBlocks;
        [[[words should] haveAtLeast:1] items];

        NSArray *characters = ((G8HierarchicalRecognizedBlock*)[words objectAtIndex:0]).childBlocks;
        [[[characters should] haveAtLeast:10] items];
    });

    it(@"Should recognize full structure of well scanned page", ^{
        NSArray *blocks = recognizedHierarchicalBlocksForImageWithName(@"well_scanned_page.png", G8PageIteratorLevelBlock);
        [[[blocks should] haveAtLeast:1] items];
        G8HierarchicalRecognizedBlock *block = [blocks objectAtIndex:0];
        [[block should] beKindOfClass:[G8HierarchicalRecognizedBlock class]];
        [[theValue(block.level) should] equal:theValue(G8PageIteratorLevelBlock)];

        NSArray *paras = block.childBlocks;
        [[[paras should] haveAtLeast:1] items];
        G8HierarchicalRecognizedBlock *para = [paras objectAtIndex:0];
        [[para should] beKindOfClass:[G8HierarchicalRecognizedBlock class]];
        [[theValue(para.level) should] equal:theValue(G8PageIteratorLevelParagraph)];

        NSArray *lines = para.childBlocks;
        [[[lines should] haveAtLeast:1] items];
        G8HierarchicalRecognizedBlock *line = [lines objectAtIndex:0];
        [[line should] beKindOfClass:[G8HierarchicalRecognizedBlock class]];
        [[theValue(line.level) should] equal:theValue(G8PageIteratorLevelTextline)];

        NSArray *words = line.childBlocks;
        [[[words should] haveAtLeast:1] items];
        G8HierarchicalRecognizedBlock *word = [words objectAtIndex:0];
        [[word should] beKindOfClass:[G8HierarchicalRecognizedBlock class]];
        [[theValue(word.level) should] equal:theValue(G8PageIteratorLevelWord)];
        [[theValue(word.isFromDict) should] beTrue];
        [[theValue(word.isBold) should] beTrue];
        [[theValue(word.isItalic) should] beFalse];
        [[theValue(word.isNumeric) should] beFalse];

        NSArray *characters = word.childBlocks;
        [[[characters should] haveAtLeast:8] items];
        G8HierarchicalRecognizedBlock *character = [characters objectAtIndex:0];
        [[character should] beKindOfClass:[G8HierarchicalRecognizedBlock class]];
        [[theValue(character.level) should] equal:theValue(G8PageIteratorLevelSymbol)];

        [[character.childBlocks should] beNil];
        [[[character.characterChoices should] haveAtLeast:1] items];
        G8RecognizedBlock *choice = [character.characterChoices objectAtIndex:0];
        [[choice should] beKindOfClass:[G8RecognizedBlock class]];
        [[theValue(choice.level) should] equal:theValue(G8PageIteratorLevelSymbol)];
    });

    it(@"Should recognize sub structure of well scanned page", ^{
        NSArray *words = recognizedHierarchicalBlocksForImageWithName(@"well_scanned_page.png", G8PageIteratorLevelWord);
        [[[words should] haveAtLeast:1] items];

        G8HierarchicalRecognizedBlock *word = [words objectAtIndex:0];
        [[word should] beKindOfClass:[G8HierarchicalRecognizedBlock class]];
        [[theValue(word.level) should] equal:theValue(G8PageIteratorLevelWord)];
    });

});

#pragma mark - hOCR

describe(@"hOCR", ^{

    it(@"Should sample image", ^{
        NSString *path = [[[NSBundle.mainBundle resourcePath] stringByAppendingString:@"/images/"] stringByAppendingString:@"image_sample.hOCR"];

        helper.image = [XPlatformImage imageWithName:@"image_sample.jpg"];
        helper.charWhitelist = @"0123456789";

        [helper recognizeImage];
        NSString *hOCR = [helper.tesseract recognizedHOCRForPageNumber:0];

        NSError *error = nil;
        [[hOCR should] equal:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]];
        NSAssert(error == nil, @"error loading hOCR from file %@: %@", path, error);
    });

    it(@"Should well scanned page", ^{
        NSString *path = [[[NSBundle.mainBundle resourcePath] stringByAppendingString:@"/images/"] stringByAppendingString:@"well_scanned_page.hOCR"];

        helper.image = [XPlatformImage imageWithName:@"well_scanned_page.png"];

        [helper recognizeImage];

        NSString *hOCR = [helper.tesseract recognizedHOCRForPageNumber:0];

        NSError *error = nil;
        NSString *fileString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

        NSAssert(error == nil, @"error loading hOCR from file %@: %@", path, error);
        [[hOCR should] equal:fileString];
    });

    it(@"Should return nil without prerecognition", ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];

        NSString *hOCR = [tesseract recognizedHOCRForPageNumber:0];
        [[hOCR should] beNil];
    });
});

describe(@"PDF", ^{

    NSData *(^recognizedPDFForImages)(NSArray *images) = ^NSData*(NSArray *images) {
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];

        NSError *error = nil;
        NSString *tempDirPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]];
        [NSFileManager.defaultManager createDirectoryAtPath:tempDirPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSString *outputFilePath = [tempDirPath stringByAppendingPathComponent:@"outputbase"];

        return [tesseract recognizedPDFForImages:images outputbase:outputFilePath];
    };

    NSData * (^samplePDFDataFromFile)(NSString *fileName) = ^NSData*(NSString *fileName) {
        NSString *PDFPath = [[[NSBundle.mainBundle resourcePath] stringByAppendingString:@"/images/"] stringByAppendingString:fileName];
        NSData *PDF = [NSData dataWithContentsOfFile:PDFPath];
        NSAssert(PDF, @"There is no PDF file at path %@ to compare with", PDFPath);
        return PDF;
    };

    it(@"Should generate well scanned page", ^{
        #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIImage *wellScannedPageImg = [UIImage imageWithName:@"well_scanned_page.png"];
        #elif TARGET_OS_MAC
        NSImage *wellScannedPageImg = [NSImage imageWithName:@"well_scanned_page.png"];
        #endif

        NSData *pdfData = recognizedPDFForImages(@[wellScannedPageImg]);

        [[theValue([pdfData g8_isEqualToData:samplePDFDataFromFile(@"well_scanned_page.pdf")]) should] beYes];
    });

    context(@"Should generate empty page for", ^{
        it(@"nil array", ^{
            [[theValue([recognizedPDFForImages(nil) g8_isEqualToData:samplePDFDataFromFile(@"empty.pdf")]) should] beYes];
        });

        it(@"empty array", ^{
            [[theValue([recognizedPDFForImages(@[]) g8_isEqualToData:samplePDFDataFromFile(@"empty.pdf")]) should] beYes];
        });

        it(@"array containing nonimage", ^{
            [[theValue([recognizedPDFForImages(@[@"someStringAsImage.png"]) g8_isEqualToData:samplePDFDataFromFile(@"empty.pdf")]) should] beYes];
        });
    });
});

SPEC_END
