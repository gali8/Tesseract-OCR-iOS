//
//  G8Tesseract.h
//  Tesseract OCR iOS
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import <UIKit/UIKit.h>
#import "G8Constants.h"

@class G8Tesseract;

@protocol G8TesseractDelegate <NSObject>

@optional
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract;
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract;

@end

@interface G8Tesseract : NSObject

+ (NSString *)version;

@property (nonatomic, copy) NSString* language;
@property (nonatomic, assign) G8OCREngineMode engineMode;
@property (nonatomic, assign) G8PageSegmentationMode pageSegmentationMode;
@property (nonatomic, copy) NSString *charWhitelist;
@property (nonatomic, copy) NSString *charBlacklist;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) NSTimeInterval maximumRecognitionTime;

@property (nonatomic, readonly) NSUInteger progress; // from 0 to 100
@property (nonatomic, readonly) NSString *recognizedText;

@property (nonatomic, readonly) G8Orientation orientation;
@property (nonatomic, readonly) G8WritingDirection writingDirection;
@property (nonatomic, readonly) G8TextlineOrder textlineOrder;
@property (nonatomic, readonly) CGFloat deskewAngle;

//  This NSDictionary uses NSValue encoded CGRects as keys and the recognized character (NSString) as the value
//  CGRects are in UIKit's coordinate space (origin is in the top left)
@property (nonatomic, readonly) NSArray *characterBoxes;
@property (nonatomic, readonly) NSArray *characterChoices;
- (NSArray *)confidencesByIteratorLevel:(G8PageIteratorLevel)pageIteratorLevel;

// Debug methods
@property (nonatomic, readonly) UIImage *thresholdedImage;
- (UIImage *)imageWithBlocks:(NSArray *)blocks drawText:(BOOL)drawText thresholded:(BOOL)thresholded;

@property (nonatomic, weak) id<G8TesseractDelegate> delegate;

- (id)initWithLanguage:(NSString*)language;
- (id)initWithLanguage:(NSString*)language engineMode:(G8OCREngineMode)engineMode;
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;
- (void)setVariablesFromDictionary:(NSDictionary *)dictionary;

- (BOOL)recognize;

///
/// @warning deprecated method!
/// @deprecated	- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language is deprecated. Please use - (id)initWithLanguage:(NSString*)language;
///
- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language DEPRECATED_ATTRIBUTE;

///
/// @warning deprecated method!
/// @deprecated	- (void)clear is deprecated. The memory will be freed in dealloc added by ARC;
///
- (void)clear DEPRECATED_ATTRIBUTE;

@end
