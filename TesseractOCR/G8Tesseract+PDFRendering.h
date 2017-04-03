//
//  G8Tesseract+PDFRendering.h
//  Tesseract OCR iOS
//
//  Created by Keyboarder Co. on 4/3/17.
//  Copyright © 2017 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8Tesseract.h"

@interface G8Tesseract (PDFRendering)

- (void)setImageURL:(NSURL *)imageURL;

- (BOOL)beginPDF:(NSURL *)pdfOutputURL creatorString:(NSString *)creator;

- (BOOL)addCurrentPageWithResolution:(int)dpi;

- (BOOL)endPDF;

- (NSArray *)recognizedWordsForSandwiching;

@end
