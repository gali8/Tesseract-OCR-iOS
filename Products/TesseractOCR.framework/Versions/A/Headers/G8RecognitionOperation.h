//
//  RecognitionOperation.h
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 12.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <UIKit/UIKit.h>

#import "G8Tesseract.h"

/**
 *  The type of a block function that can be used as a callback for the
 *  recognition operation.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
typedef void(^G8RecognitionOperationCallback)(G8Tesseract *tesseract);

/**
 *  `G8RecognitionOperation` is a convenience class for recognizing and 
 *  analyzing text in images asynchronously using `NSOperation`.
 */
@interface G8RecognitionOperation : NSOperation

/**
 *  The `G8Tesseract` object performing the recognition.
 */
@property (nonatomic, strong, readonly) G8Tesseract *tesseract;

/**
 *  An optional delegate for Tesseract's recognition.
 *
 *  @note Delegate methods will be called from operation thread.
 */
@property (nonatomic, weak) id<G8TesseractDelegate> delegate;

/**
 *  The percentage of progress of Tesseract's recognition (between 0 and 100).
 */
@property (nonatomic, assign, readonly) CGFloat progress;

/**
 *  A `G8RecognitionOperationBlock` function that will be called when the
 *  recognition has been completed.
 *  
 *  @note It will be called from main thread.
 */
@property (nonatomic, copy) G8RecognitionOperationCallback recognitionCompleteBlock;

/**
 *  A `G8RecognitionOperationBlock` function that will be called periodically
 *  as the recognition progresses.
 *
 *  @note It will be called from operation thread.
 */
@property (nonatomic, copy) G8RecognitionOperationCallback progressCallbackBlock;

/// @deprecated	Use property recognitionCompleteBlock instead
@property (copy) void (^completionBlock)(void) DEPRECATED_ATTRIBUTE;

@end
