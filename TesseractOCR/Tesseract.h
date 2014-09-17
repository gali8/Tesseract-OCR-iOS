//
//  Tesseract.h
//  Tesseract
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import <UIKit/UIKit.h>
#import "UIImage+Filters.h"

@class Tesseract;

@protocol TesseractDelegate <NSObject>
@optional
- (void)progressImageRecognitionForTesseract:(Tesseract*)tesseract;
- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract;
@end

@interface Tesseract : NSObject
+ (NSString *)version;

@property (nonatomic, strong) NSString* language;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect rect;

@property (nonatomic, readonly) short progress; // from 0 to 100
@property (nonatomic, readonly) NSString *recognizedText;

//  This NSDictionary uses NSValue encoded CGRects as keys and the recognized character (NSString) as the value
//  CGRects are in UIKit's coordinate space (origin is in the top left)
@property (nonatomic, readonly) NSArray *characterBoxes;

@property (nonatomic, readonly) NSArray *getConfidenceByWord;
@property (nonatomic, readonly) NSArray *getConfidenceBySymbol;
@property (nonatomic, readonly) NSArray *getConfidenceByTextline;
@property (nonatomic, readonly) NSArray *getConfidenceByParagraph;
@property (nonatomic, readonly) NSArray *getConfidenceByBlock;

@property (nonatomic, weak) id<TesseractDelegate> delegate;

///
/// @warning deprecated method!
/// @deprecated	- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language is deprecated. Please use - (id)initWithLanguage:(NSString*)language;
///
- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language DEPRECATED_ATTRIBUTE;
- (id)initWithLanguage:(NSString*)language;
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;

- (BOOL)recognize;

///
/// @warning deprecated method!
/// @deprecated	- (void)clear is deprecated. The memory will be freed in dealloc added by ARC;
///
- (void)clear DEPRECATED_ATTRIBUTE;

@end
