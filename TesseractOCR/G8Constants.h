//
//  G8Constants.h
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 18.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_G8Constants_h
#define Tesseract_OCR_iOS_G8Constants_h

/**
 * Possible modes for page layout analysis.
 */
typedef NS_ENUM(NSUInteger, G8PageSegmentationMode){
    /**
     *  Orientation and script detection only.
     */
    G8PageSegmentationModeOSDOnly,
    /**
     *  Automatic page segmentation with orientation and script detection. (OSD)
     */
    G8PageSegmentationModeAutoOSD,
    /**
     *  Automatic page segmentation, but no OSD, or OCR.
     */
    G8PageSegmentationModeAutoOnly,
    /**
     *  Fully automatic page segmentation, but no OSD.
     */
    G8PageSegmentationModeAuto,
    /**
     *  Assume a single column of text of variable sizes.
     */
    G8PageSegmentationModeSingleColumn,
    /**
     *  Assume a single uniform block of vertically aligned text.
     */
    G8PageSegmentationModeSingleBlockVertText,
    /**
     *  Assume a single uniform block of text. (Default.)
     */
    G8PageSegmentationModeSingleBlock,
    /**
     *  Treat the image as a single text line.
     */
    G8PageSegmentationModeSingleLine,
    /**
     *  Treat the image as a single word.
     */
    G8PageSegmentationModeSingleWord,
    /**
     *  Treat the image as a single word in a circle.
     */
    G8PageSegmentationModeCircleWord,
    /**
     *  Treat the image as a single character.
     */
    G8PageSegmentationModeSingleChar,
    /**
     *  Find as much text as possible in no particular order.
     */
    G8PageSegmentationModeSparseText,
    /**
     *  Sparse text with orientation and script det.
     */
    G8PageSegmentationModeSparseTextOSD,
};

/**
 * When Tesseract/Cube is initialized we can choose to instantiate/load/run
 * only the Tesseract part, only the Cube part or both along with the combiner.
 */
typedef NS_ENUM(NSUInteger, G8OCREngineMode){
    /**
     *  Run Tesseract only - fastest
     */
    G8OCREngineModeTesseractOnly,
    /**
     *  Run Cube only - better accuracy, but slower
     */
    G8OCREngineModeCubeOnly,
    /**
     *  Run both and combine results - best accuracy
     */
    G8OCREngineModeTesseractCubeCombined,
//    G8OCREngineModeDefault,
};

/**
 *  Result iteration level
 */
typedef NS_ENUM(NSUInteger, G8PageIteratorLevel){
    /**
     *  Block of text/image/separator line.
     */
    G8PageIteratorLevelBlock,
    /**
     *  Paragraph within a block.
     */
    G8PageIteratorLevelParagraph,
    /**
     *  Line within a paragraph.
     */
    G8PageIteratorLevelTextline,
    /**
     *  Word within a textline.
     */
    G8PageIteratorLevelWord,
    /**
     *  Symbol/character within a word.
     */
    G8PageIteratorLevelSymbol,
};

#endif
