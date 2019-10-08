//
//  G8RecognitionTestsHelper.h
//  TestsProject
//
//  Created by Nikolay Volosatov on 25.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <TesseractOCR/TesseractOCR.h>
#elif TARGET_OS_MAC
#import <TesseractOCRmacOS/TesseractOCR.h>
#endif

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
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@property (nonatomic, strong) UIImage *image;
#elif TARGET_OS_MAC
@property (nonatomic, strong) NSImage *image;
#endif

@property (nonatomic, assign) CGSize boundingSizeForResizing;
@property (nonatomic, assign) G8CustomPreprocessing customPreprocessingType;

- (void)setupTesseract;
- (void)recognizeImage;
- (void)recognizeImageUsingOperation;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (UIImage *)thresholdedImageForImage:(UIImage *)sourceImage;
#elif TARGET_OS_MAC
- (NSImage *)thresholdedImageForImage:(NSImage *)sourceImage;
#endif

@end
