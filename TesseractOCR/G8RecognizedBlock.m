//
//  G8RecognizedBlock.m
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 18.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import "G8RecognizedBlock.h"

@interface G8RecognizedBlock ()

@end

@implementation G8RecognizedBlock

- (instancetype)init
{
    return [self initWithText:nil
                  boundingBox:CGRectZero
                   confidence:0.0f
                        level:G8PageIteratorLevelBlock];
}

- (instancetype)initWithText:(NSString *)text
                 boundingBox:(CGRect)boundingBox
                  confidence:(CGFloat)confidence
                       level:(G8PageIteratorLevel)level
{
    self = [super init];
    if (self != nil) {
        _text = [text copy];
        _boundingBox = boundingBox;
        _confidence = confidence;
        _level = level;
    }
    return self;
}

- (CGRect)boundingBoxAtImageOfSize:(CGSize)imageSize
{
    CGFloat x = CGRectGetMinX(self.boundingBox) * imageSize.width;
    CGFloat y = CGRectGetMinY(self.boundingBox) * imageSize.height;
    CGFloat width = CGRectGetWidth(self.boundingBox) * imageSize.width;
    CGFloat height = CGRectGetHeight(self.boundingBox) * imageSize.height;

    return CGRectMake(x, y, width, height);
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    else if ([other isKindOfClass:[self class]] == YES) {
        
        G8RecognizedBlock *otherBlock = other;
        if (self.hash == otherBlock.hash) {
            
            if (self.level == otherBlock.level &&
                ABS(self.confidence - otherBlock.confidence) < FLT_EPSILON &&
                CGRectEqualToRect(self.boundingBox, otherBlock.boundingBox) &&
                (self.text == otherBlock.text || [self.text isEqualToString:otherBlock.text])
                )
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return self.level + (NSUInteger)(self.confidence * 10000) * 11813 + self.text.hash * 13411;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%.2f%%) '%@'", self.confidence, self.text];
}

@end
