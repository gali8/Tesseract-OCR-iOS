//
//  G8RecognitionTestsHelper.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 25.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8RecognitionTestsHelper.h"

static NSString *const kG8Languages = @"eng";

@interface G8RecognitionTestsHelper ()

@property (nonatomic, strong, readwrite) G8Tesseract *tesseract;

@end

@implementation G8RecognitionTestsHelper

- (id)init
{
    self = [super init];
    if (self != nil) {
        _engineMode = G8OCREngineModeTesseractOnly;
        _pageSegmentationMode = G8PageSegmentationModeAuto;
        _charWhitelist = @"";
        _waitDeadline = 180.0;
        _maxExpectedRecognitionTime = 185.0;
        _rect = CGRectZero;
        _sourceResolution = 0;

        _customPreprocessingType = G8CustomPreprocessingNone;
        _boundingSizeForResizing = CGSizeMake(700.0f, 700.0f);
    }
    return self;
}

- (void)waitTimeLmit:(NSTimeInterval)maximumWait whileTrue:(BOOL (^)())shouldKeepRunning
{
    NSDate *deadlineDate = [NSDate dateWithTimeInterval:maximumWait sinceDate:[NSDate date]];
    BOOL isDeadline = NO;
    while (shouldKeepRunning != nil && shouldKeepRunning() && isDeadline == NO) {
        if ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:deadlineDate] == NO) {
            break;
        }
        isDeadline = [[NSDate date] compare:deadlineDate] == NSOrderedDescending;
    }
};

- (void)setupTesseract
{
    if (self.tesseract == nil) {
        self.tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
    }
    
    self.tesseract.delegate = self;

    self.tesseract.language = kG8Languages;
    self.tesseract.engineMode = self.engineMode;
    self.tesseract.pageSegmentationMode = self.pageSegmentationMode;

    self.tesseract.charWhitelist = self.charWhitelist;
    self.tesseract.maximumRecognitionTime = self.waitDeadline;
};

- (void)setupImage
{
    self.tesseract.image = [self.image g8_blackAndWhite];

    if (CGRectEqualToRect(self.rect, CGRectZero) == NO) {
        self.tesseract.rect = self.rect;
    }

    if (self.sourceResolution > 0) {
        self.tesseract.sourceResolution = self.sourceResolution;
    }
}

- (void)recognizeImage
{
    self.tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
    [self setupTesseract];
    [self setupImage];

    [self.tesseract recognize];
};

- (void)recognizeImageUsingOperation
{
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:kG8Languages];
    self.tesseract = operation.tesseract;
    [self setupTesseract];

    [self setupImage];

    __weak __typeof(self) weakSelf = self;

    self.tesseract = nil;
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        strongSelf.tesseract = recognizedTesseract;
    };

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

    [self waitTimeLmit:self.maxExpectedRecognitionTime whileTrue:^BOOL{
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        return (BOOL)(strongSelf.tesseract == nil);
    }];

    if (self.tesseract == nil) {
        [NSException raise:@"Tesseract stopped" format:@"Tesseract worked too long"];
    }
};

- (UIImage *)thresholdedImageForImage:(UIImage *)sourceImage
{
    self.tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
    [self setupTesseract];

    self.tesseract.image = [sourceImage g8_blackAndWhite];

    return self.tesseract.thresholdedImage;
};

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
