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
@property (nonatomic) BOOL progressDelegateCallbackCalledByQueue;
@property (nonatomic) BOOL cancelDelegateCallbackCalledByQueue;
@property (nonatomic) BOOL preprocessingDelegateCallbackCalledByQueue;

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

- (void)waitTimeLmit:(NSTimeInterval)maximumWait whileTrue:(BOOL (^)(void))shouldKeepRunning
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
    
    self.tesseract.language = kG8Languages;
    self.tesseract.engineMode = self.engineMode;
    self.tesseract.pageSegmentationMode = self.pageSegmentationMode;

    self.tesseract.charWhitelist = self.charWhitelist;
    self.tesseract.maximumRecognitionTime = self.waitDeadline;
};

- (void)setupImage
{
    self.tesseract.image = self.image;

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
    self.tesseract.delegate = self;

    [self setupImage];

    [self.tesseract recognize];
};

- (void)recognizeImageUsingOperation
{
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:kG8Languages];
    operation.delegate = self;
    self.tesseract = operation.tesseract;
    [self setupTesseract];
    
    [self setupImage];
    
    __block BOOL recognitionCompleteBlockInvoked = NO;
    __block BOOL progressCallbackBlockInvoked = NO;
    // Set up callbacks to test that it's being called
    operation.progressCallbackBlock = ^(G8Tesseract *tesseract){
        progressCallbackBlockInvoked = YES;
    };

    self.tesseract = nil;
    __weak __typeof(self) weakSelf = self;
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tesseract = recognizedTesseract;
        recognitionCompleteBlockInvoked = YES;
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
    
    NSAssert(recognitionCompleteBlockInvoked == YES, @"Error! recognitionCompleteBlock has not been invoked");
    NSAssert(progressCallbackBlockInvoked == YES, @"Error! progressCallbackBlock has not been invoked");
    
    NSAssert(self.progressDelegateCallbackCalledByQueue == YES, @"Error! progressImageRecognitionForTesseract has not been invoked by queue");
    self.progressDelegateCallbackCalledByQueue = NO;
    
    NSAssert(self.cancelDelegateCallbackCalledByQueue == YES, @"Error! shouldCancelImageRecognitionForTesseract has not been invoked by queue");
    self.cancelDelegateCallbackCalledByQueue = NO;
    
    NSAssert(self.preprocessingDelegateCallbackCalledByQueue == YES, @"Error! preprocessedImageForTesseract has not been invoked by queue");
    self.preprocessingDelegateCallbackCalledByQueue = NO;
};

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (UIImage *)thresholdedImageForImage:(UIImage *)sourceImage
{
    self.tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
    [self setupTesseract];
    self.tesseract.delegate = self;

    self.tesseract.image = sourceImage;

    return self.tesseract.thresholdedImage;
};
#elif TARGET_OS_MAC
- (NSImage *)thresholdedImageForImage:(NSImage *)sourceImage
{
    self.tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
    [self setupTesseract];
    self.tesseract.delegate = self;

    self.tesseract.image = sourceImage;

    return self.tesseract.thresholdedImage;
};
#endif


#pragma mark - G8TesseractDelegate methods

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract
{
    self.progressDelegateCallbackCalledByQueue = YES;
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract
{
    self.cancelDelegateCallbackCalledByQueue = YES;
    return NO;
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (UIImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage
{
    self.preprocessingDelegateCallbackCalledByQueue = YES;

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
#elif TARGET_OS_MAC
- (NSImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(NSImage *)sourceImage
{
    self.preprocessingDelegateCallbackCalledByQueue = YES;

    switch (self.customPreprocessingType) {
        case G8CustomPreprocessingNone:
            return nil;

        case G8CustomPreprocessingSimpleThreshold:
            return sourceImage;

        case G8CustomPreprocessingSimpleThresholdAndResize:
            return [[self class] resizedImage:sourceImage
                            toPixelDimensions:self.boundingSizeForResizing];
        default:
            return nil;
    }
}

+ (NSImage *)resizedImage:(NSImage *)sourceImage toPixelDimensions:(NSSize)newSize
{
    CGImageRef cgImg = [sourceImage CGImageForProposedRect:nil context:nil hints:nil];

    CGFloat width = (CGFloat)CGImageGetWidth(cgImg);
    CGFloat height = (CGFloat)CGImageGetHeight(cgImg);

    NSSize imageSize = CGSizeMake(width, height);

    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;

    CGFloat scaleFactor = 1.0f;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;

    if (CGSizeEqualToSize(imageSize, newSize) == NO) {
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

    NSSize scaledSize = NSMakeSize(scaledWidth, scaledHeight);

    if (!sourceImage.isValid) {
        return nil;
    }

    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:scaledSize.width
                             pixelsHigh:scaledSize.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    rep.size = scaledSize;

    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    [sourceImage drawInRect:NSMakeRect(0, 0, scaledSize.width, scaledSize.height) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];

    NSImage *newImage = [[NSImage alloc] initWithSize:scaledSize];
    [newImage addRepresentation:rep];
    return newImage;
}
#endif

@end
