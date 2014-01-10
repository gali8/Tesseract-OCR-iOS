//
//  Tesseract.h
//  Tesseract
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import <UIKit/UIKit.h>

@class Tesseract;

@protocol TesseractDelegate <NSObject>
@optional
- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract;
@end

@interface Tesseract : NSObject
+ (NSString *)version;

@property (nonatomic, strong) NSString* language;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect rect;

@property (nonatomic, readonly) short progress; // from 0 to 100
@property (nonatomic, readonly) NSString *recognizedText;

@property (nonatomic, weak) id<TesseractDelegate> delegate;

- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language;  //designed
- (id)initWithLanguage:(NSString*)language;
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;

- (BOOL)recognize;
- (void)clear;

@end
