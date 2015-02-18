//
//  G8RecognitionTestsHelper.h
//  TestsProject
//
//  Created by Nikolay Volosatov on 25.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TesseractOCR/TesseractOCR.h>

typedef NS_ENUM(NSUInteger, G8CustomPreprocessing) {
    G8CustomPreprocessingNone,
    G8CustomPreprocessingSimpleThreshold,
    G8CustomPreprocessingSimpleThresholdAndResize,
};

@interface G8RecognitionTestsHelper : NSObject <G8TesseractDelegate>

@property (nonatomic, strong, readonly) G8Tesseract *tesseract;

@property (nonatomic, assign) G8OCREngineMode engineMode;
@property (nonatomic, assign) G8PageSegmentationMode pageSegmentationMode;
@property (nonatomic, copy) NSString *charWhitelist;
@property (nonatomic, assign) NSTimeInterval waitDeadline;
@property (nonatomic, assign) NSTimeInterval maxExpectedRecognitionTime;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) NSInteger sourceResolution;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGSize boundingSizeForResizing;
@property (nonatomic, assign) G8CustomPreprocessing customPreprocessingType;

- (void)setupTesseract;
- (void)recognizeImage;
- (void)recognizeImageUsingOperation;
- (UIImage *)thresholdedImageForImage:(UIImage *)sourceImage;

@end
