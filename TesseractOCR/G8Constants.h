//
//  G8Constants.h
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 18.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_G8Constants_h
#define Tesseract_OCR_iOS_G8Constants_h

#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif

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

/**
 * If you orient your head so that "up" aligns with Orientation,
 * then the characters will appear "right side up" and readable.
 *
 * In the example above, both the English and Chinese paragraphs are oriented
 * so their "up" is the top of the page (page up).  The photo credit is read
 * with one's head turned leftward ("up" is to page left).
 */
typedef NS_ENUM(NSUInteger, G8Orientation){
    G8OrientationPageUp,
    G8OrientationPageRight,
    G8OrientationPageDown,
    G8OrientationPageLeft,
};

/**
 * The grapheme clusters within a line of text are laid out logically
 * in this direction, judged when looking at the text line rotated so that
 * its Orientation is "page up".
 *
 * For English text, the writing direction is left-to-right.  For the
 * Chinese text in the above example, the writing direction is top-to-bottom.
 */
typedef NS_ENUM(NSUInteger, G8WritingDirection){
    G8WritingDirectionLeftToRight,
    G8WritingDirectionRightToLeft,
    G8WritingDirectionTopToBottom,
};

/**
 * The text lines are read in the given sequence.
 *
 * In English, the order is top-to-bottom.
 * In Chinese, vertical text lines are read right-to-left.  Mongolian is
 * written in vertical columns top to bottom like Chinese, but the lines
 * order left-to right.
 *
 * Note that only some combinations make sense.  For example,
 * WRITING_DIRECTION_LEFT_TO_RIGHT implies TEXTLINE_ORDER_TOP_TO_BOTTOM
 */
typedef NS_ENUM(NSUInteger, G8TextlineOrder) {
    G8TextlineOrderLeftToRight,
    G8TextlineOrderRightToLeft,
    G8TextlineOrderTopToBottom,
};

#endif
