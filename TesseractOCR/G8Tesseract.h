//
//  G8Tesseract.h
//  Tesseract OCR iOS
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import <UIKit/UIKit.h>

@class G8Tesseract;

@protocol G8TesseractDelegate <NSObject>

@optional
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract;
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract;

@end

@interface G8Tesseract : NSObject

+ (NSString *)version;

@property (nonatomic, copy) NSString* language;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect rect;

@property (nonatomic, readonly) NSUInteger progress; // from 0 to 100
@property (nonatomic, readonly) NSString *recognizedText;

@property (nonatomic, readonly) UIImage *thresholdedImage;

//  This NSDictionary uses NSValue encoded CGRects as keys and the recognized character (NSString) as the value
//  CGRects are in UIKit's coordinate space (origin is in the top left)
@property (nonatomic, readonly) NSArray *characterBoxes;

@property (nonatomic, readonly) NSArray *getConfidenceByWord;
@property (nonatomic, readonly) NSArray *getConfidenceBySymbol;
@property (nonatomic, readonly) NSArray *getConfidenceByTextline;
@property (nonatomic, readonly) NSArray *getConfidenceByParagraph;
@property (nonatomic, readonly) NSArray *getConfidenceByBlock;

@property (nonatomic, weak) id<G8TesseractDelegate> delegate;

- (id)initWithLanguage:(NSString*)language;
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;

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
