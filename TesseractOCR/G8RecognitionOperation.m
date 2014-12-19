//
//  G8RecognitionOperation.m
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 12.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8RecognitionOperation.h"

#import "TesseractOCR.h"

@interface G8RecognitionOperation() <G8TesseractDelegate>

@property (nonatomic, strong, readwrite) G8Tesseract *tesseract;
@property (nonatomic, assign, readwrite) CGFloat progress;

@end

@implementation G8RecognitionOperation

- (id)init
{
    self = [super init];
    if (self != nil) {
        _tesseract = [[G8Tesseract alloc] init];
        _tesseract.delegate = self;

        __weak __typeof(self) weakSelf = self;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        self.completionBlock = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            if (strongSelf.recognitionCompleteBlock != nil) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    strongSelf.recognitionCompleteBlock(strongSelf.tesseract);
                }];
            }
        };
#pragma clang diagnostic pop
    }
    return self;
}

- (void)main
{
    [self.tesseract recognize];
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
    BOOL canceled = self.cancelled;
    if ([self.delegate respondsToSelector:@selector(shouldCancelImageRecognitionForTesseract:)]) {
        canceled = canceled || [self.delegate shouldCancelImageRecognitionForTesseract:tesseract];
    }
    return canceled;
}

@end
