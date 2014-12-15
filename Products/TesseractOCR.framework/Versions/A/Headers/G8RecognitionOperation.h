//
//  RecognitionOperation.h
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 12.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "G8Tesseract.h"

typedef void(^G8RecognitionOperationComplete)(G8Tesseract *tesseract);

@interface G8RecognitionOperation : NSOperation

@property (nonatomic, strong, readonly) G8Tesseract *tesseract;
@property (nonatomic, weak) id<G8TesseractDelegate> delegate;

@property (nonatomic, assign, readonly) CGFloat progress;

@property (nonatomic, copy) G8RecognitionOperationComplete recognitionCompleteBlock;

/// @deprecated	Use property recognitionCompleteBlock instead
@property (copy) void (^completionBlock)(void) DEPRECATED_ATTRIBUTE;

@end
