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

@interface G8RecognitionOperation() <G8TesseractDelegate>

@property (nonatomic, strong, readwrite) G8Tesseract *tesseract;
@property (nonatomic, assign, readwrite) CGFloat progress;

@end

@implementation G8RecognitionOperation

- (id) initWithLanguage:(NSString *)language
{
    self = [super init];
    if (self != nil) {
        _tesseract = [[G8Tesseract alloc] initWithLanguage:language];
        _tesseract.delegate = self;

        __weak __typeof(self) weakSelf = self;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
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
#pragma clang diagnostic pop
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

@end
