//
//  RecognitionOperation.m
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 12.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "RecognitionOperation.h"

@interface RecognitionOperation() <TesseractDelegate>

@property (nonatomic, strong, readwrite) Tesseract *tesseract;
@property (nonatomic, assign, readwrite) CGFloat progress;

@end

@implementation RecognitionOperation

- (id)init
{
    self = [super init];
    if (self != nil) {
        _tesseract = [[Tesseract alloc] init];
        _tesseract.delegate = self;

        __weak __typeof(self) weakSelf = self;
        self.completionBlock = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            if (strongSelf.recognitionCompleteBlock != nil) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    strongSelf.recognitionCompleteBlock(strongSelf.tesseract);
                }];
            }
        };
    }
    return self;
}

- (void)main
{
    [self.tesseract recognize];
}

- (void)progressImageRecognitionForTesseract:(Tesseract*)tesseract
{
    self.progress = self.tesseract.progress / 100.0f;
    if ([self.delegate respondsToSelector:@selector(progressImageRecognitionForTesseract:)]) {
        [self.delegate progressImageRecognitionForTesseract:tesseract];
    }
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
    BOOL canceled = self.cancelled;
    if ([self.delegate respondsToSelector:@selector(shouldCancelImageRecognitionForTesseract:)]) {
        canceled = canceled || [self.delegate shouldCancelImageRecognitionForTesseract:tesseract];
    }
    return canceled;
}

@end
