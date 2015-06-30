//
//  G8Tesseract+PDFRendering.h
//  Tesseract OCR iOS
//
//  Created by Sebastian Husche on 30.06.15.
//  Copyright (c) 2015 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8Tesseract.h"

@interface G8Tesseract (PDFRendering)

- (void)setImageURL:(NSURL *)imageURL;

- (BOOL)beginPDF:(NSURL *)pdfOutputURL creatorString:(NSString *)creator;

- (BOOL)addCurrentPageWithResolution:(int)dpi;

- (BOOL)endPDF;

- (NSArray *)recognizedWordsForSandwiching;

@end
