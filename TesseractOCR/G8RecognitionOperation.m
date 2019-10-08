//
//  G8RecognitionOperation.m
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 12.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import "G8RecognitionOperation.h"

#import "TesseractOCR.h"

@interface G8RecognitionOperation() <G8TesseractDelegate> {
    G8Tesseract *_tesseract;
}
@property (nonatomic, assign, readwrite) CGFloat progress;

@end

@implementation G8RecognitionOperation

- (id) initWithLanguage:(NSString *)language
{
    return [self initWithLanguage:language configDictionary:nil configFileNames:nil absoluteDataPath:nil engineMode:G8OCREngineModeTesseractOnly];
}

- (id)initWithLanguage:(NSString *)language
      configDictionary:(NSDictionary *)configDictionary
       configFileNames:(NSArray *)configFileNames
      absoluteDataPath:(NSString *)absoluteDataPath
            engineMode:(G8OCREngineMode)engineMode
{
    self = [super init];
    if (self != nil) {
        _tesseract = [[G8Tesseract alloc] initWithLanguage:language
                                          configDictionary:configDictionary
                                           configFileNames:configFileNames
                                          absoluteDataPath:absoluteDataPath
                                                engineMode:engineMode];
        _tesseract.delegate = self;
        
        __weak __typeof(self) weakSelf = self;
        self.completionBlock = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            G8RecognitionOperationCallback callback = [strongSelf.recognitionCompleteBlock copy];
            G8Tesseract *tesseract = strongSelf.tesseract;
            if (callback != nil) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    callback(tesseract);
                }];
            }
        };
    }
    return self;
}

- (void)main
{
    @autoreleasepool {
        // Analyzing the layout must be performed before recognition
        [self.tesseract analyseLayout];
        
        [self.tesseract recognize];
    }
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract
{
    self.progress = self.tesseract.progress / 100.0f;

    if (self.progressCallbackBlock != nil) {
        self.progressCallbackBlock(self.tesseract);
    }

    if ([self.delegate respondsToSelector:@selector(progressImageRecognitionForTesseract:)]) {
        [self.delegate progressImageRecognitionForTesseract:tesseract];
    }
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract
{
    BOOL canceled = self.isCancelled;
    if (canceled == NO && [self.delegate respondsToSelector:@selector(shouldCancelImageRecognitionForTesseract:)]) {
        canceled = [self.delegate shouldCancelImageRecognitionForTesseract:tesseract];
    }
    return canceled;
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (UIImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage
{
    if ([self.delegate respondsToSelector:@selector(preprocessedImageForTesseract:sourceImage:)]) {
        return [self.delegate preprocessedImageForTesseract:tesseract sourceImage:sourceImage];
    }
    return nil;
}
#elif TARGET_OS_MAC
- (NSImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(NSImage *)sourceImage
{
    if ([self.delegate respondsToSelector:@selector(preprocessedImageForTesseract:sourceImage:)]) {
        return [self.delegate preprocessedImageForTesseract:tesseract sourceImage:sourceImage];
    }
    return nil;
}
#endif

@end
