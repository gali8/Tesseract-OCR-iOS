//
//  G8RecognizedBlock.h
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 18.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "G8Constants.h"

@interface G8RecognizedBlock : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, assign, readonly) CGRect boundingBox;
@property (nonatomic, assign, readonly) CGFloat confidence;
@property (nonatomic, assign, readonly) G8PageIteratorLevel level;

- (instancetype)initWithText:(NSString *)text
                 boundingBox:(CGRect)boundingBox
                  confidence:(CGFloat)confidence
                       level:(G8PageIteratorLevel)level;

@end
