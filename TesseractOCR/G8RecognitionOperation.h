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
typedef void(^G8RecognitionOperationCallback)(G8Tesseract * _Nullable tesseract);

/**
 *  `G8RecognitionOperation` is a convenience class for recognizing and 
 *  analyzing text in images asynchronously using `NSOperation`.
 */
@interface G8RecognitionOperation : NSOperation

/**
 *  The `G8Tesseract` object performing the recognition.
 */
    @property (nonatomic, strong, readonly, nonnull) G8Tesseract *tesseract;

/**
 *  An optional delegate for Tesseract's recognition.
 *
 *  @note Delegate methods will be called from operation thread.
 */
@property (nonatomic, weak, nullable) id<G8TesseractDelegate> delegate;

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
@property (nonatomic, copy, nullable) G8RecognitionOperationCallback recognitionCompleteBlock;

/**
 *  A `G8RecognitionOperationBlock` function that will be called periodically
 *  as the recognition progresses.
 *
 *  @note It will be called from operation thread.
 */
@property (nonatomic, copy, nullable) G8RecognitionOperationCallback progressCallbackBlock;

/// The default initializer should not be used since the language Tesseract
/// uses needs to be explicit.
- (instancetype _Nonnull )init __attribute__((unavailable("Use initWithLanguage:language instead")));

/**
 *  Initialize a G8RecognitionOperation with the provided language.
 *
 *  @param language The language to use in recognition.
 *
 *  @return The initialized G8RecognitionOperation object, or `nil` if there 
 *          was an error.
 */
- (id _Nullable )initWithLanguage:(nonnull NSString*)language;

- (id _Nullable)initWithLanguage:(nonnull NSString *)language
      configDictionary:(nullable NSDictionary *)configDictionary
       configFileNames:(nullable NSArray *)configFileNames
      absoluteDataPath:(nullable NSString *)absoluteDataPath
            engineMode:(G8OCREngineMode)engineMode;

@end
