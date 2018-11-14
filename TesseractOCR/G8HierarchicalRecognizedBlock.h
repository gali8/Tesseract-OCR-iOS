//
//  G8HierarchicalRecognizedBlock.h
//  Tesseract OCR iOS
//
//  Created by Jürgen Mayer on 30.11.15.
//  Copyright © 2015 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <TesseractOCR/TesseractOCR.h>

@interface G8HierarchicalRecognizedBlock : G8RecognizedBlock

/**
 *	An array of blocks of the next lower level. See `G8PageIternatorLevel`
 *	in G8Constants.h for the different level options.
 */
@property (nonatomic, strong) NSArray *childBlocks;

/**
 *	Indicates if the word is found in Tesseracts dictionary.
 *	Only applies to a block with level G8PageIteratorLevelWord.
 */
@property (nonatomic, assign) BOOL isFromDict;

/**
 *	Indicates if the word only consists of numbers.
 *	Only applies to a block with level G8PageIteratorLevelWord.
 */
@property (nonatomic, assign) BOOL isNumeric;

/**
 *	Indicates if the word is written in bold font.
 *	Only applies to a block with level G8PageIteratorLevelWord.
 */
@property (nonatomic, assign) BOOL isBold;

/**
 *	Indicates if the word is written in italic font.
 *	Only applies to a block with level G8PageIteratorLevelWord.
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
