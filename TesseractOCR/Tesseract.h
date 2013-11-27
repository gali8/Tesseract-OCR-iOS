//
//  Tesseract.h
//  Tesseract
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import <UIKit/UIKit.h>

@interface Tesseract : NSObject
+ (NSString *)version;

- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language;
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;
- (void)setImage:(UIImage *)image;
- (BOOL)setLanguage:(NSString *)language;
- (BOOL)recognize;
- (NSString *)recognizedText;
- (void)clear;

@end
