//
//  RecognitionOperation.h
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 12.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TesseractOCR.h"

typedef void(^RecognitionOperationComplete)(Tesseract *tesseract);

@interface RecognitionOperation : NSOperation

@property (nonatomic, strong, readonly) Tesseract *tesseract;
@property (nonatomic, weak) id<TesseractDelegate> delegate;

@property (nonatomic, assign, readonly) CGFloat progress;

@property (nonatomic, copy) RecognitionOperationComplete recognitionCompleteBlock;

/// @deprecated	Use property recognitionCompleteBlock instead
@property (copy) void (^completionBlock)(void) DEPRECATED_ATTRIBUTE;

@end
