//
//  TesseractOCR.h
//  TesseractOCR
//
//  Created by Kirill Makankov on 04.01.15.
//  Copyright (c) 2015 Daniele Galiotto - www.g8production.com. All rights
//  reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#endif

//! Project version number for TesseractOCR.
FOUNDATION_EXPORT double TesseractOCRVersionNumber;

//! Project version string for TesseractOCR.
FOUNDATION_EXPORT const unsigned char TesseractOCRVersionString[];

// In this header, you should import all the public headers of your framework
// using statements like #import <TesseractOCR/PublicHeader.h>
#ifndef Tesseract_OCR_iOS_TesseractOCR_h
#define Tesseract_OCR_iOS_TesseractOCR_h

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <TesseractOCR/G8Constants.h>
#import <TesseractOCR/G8HierarchicalRecognizedBlock.h>
#import <TesseractOCR/G8RecognitionOperation.h>
#import <TesseractOCR/G8RecognizedBlock.h>
#import <TesseractOCR/G8Tesseract.h>
#import <TesseractOCR/G8TesseractParameters.h>
#elif TARGET_OS_MAC
#import <TesseractOCRmacOS/G8Constants.h>
#import <TesseractOCRmacOS/G8HierarchicalRecognizedBlock.h>
#import <TesseractOCRmacOS/G8RecognitionOperation.h>
#import <TesseractOCRmacOS/G8RecognizedBlock.h>
#import <TesseractOCRmacOS/G8Tesseract.h>
#import <TesseractOCRmacOS/G8TesseractParameters.h>
#endif

#endif
