//
//  G8HierarchicalRecognizedBlock.h
//  Tesseract OCR iOS
//
//  Created by Jürgen Mayer on 30.11.15.
//  Copyright © 2015 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <TesseractOCR/TesseractOCR.h>
#elif TARGET_OS_MAC
#import <TesseractOCRmacOS/TesseractOCR.h>
#endif

@interface G8HierarchicalRecognizedBlock : G8RecognizedBlock

/**
 *	An array of blocks of the next lower level. See `G8PageIteratorLevel`
 *	in G8Constants.h for the different level options.
 */
@property (nonatomic, strong) NSArray *childBlocks;

/**
 *	Indicates if the word is found in Tesseract's dictionary.
 *	Only applies to a block with level `G8PageIteratorLevelWord`.
 */
@property (nonatomic, assign) BOOL isFromDict;

/**
 *	Indicates if the word only consists of numbers.
 *	Only applies to a block with level `G8PageIteratorLevelWord`.
 */
@property (nonatomic, assign) BOOL isNumeric;

/**
 *	Indicates if the word is written in bold font.
 *	Only applies to a block with level `G8PageIteratorLevelWord`.
 */
@property (nonatomic, assign) BOOL isBold;

/**
 *	Indicates if the word is written in italic font.
 *	Only applies to a block with level `G8PageIteratorLevelWord`.
 */
@property (nonatomic, assign) BOOL isItalic;

/**
 *  An array of arrays, where each subarray contains `G8RecognizedBlock`'s
 *  representing the choices Tesseract considered for each symbol in the target
 *  image.
 *
 *  @note It has been observed that this method only works when using the
 *        `G8OCREngineModeTesseractOnly` mode for `engineMode`. It returns nil,
 *        if the engine is not properly configured.
 */
@property (nonatomic, strong) NSArray *characterChoices;


- (instancetype)initWithBlock:(G8RecognizedBlock *)block;

@end
