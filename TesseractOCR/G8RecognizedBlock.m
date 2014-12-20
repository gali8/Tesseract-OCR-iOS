//
//  G8RecognizedBlock.m
//  Tesseract OCR iOS
//
//  Created by Nikolay Volosatov on 18.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8RecognizedBlock.h"

@interface G8RecognizedBlock ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGRect boundingBox;
@property (nonatomic, assign) CGFloat confidence;
@property (nonatomic, assign) G8PageIteratorLevel level;

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

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    else if ([super isEqual:other] == NO) {
        return NO;
    }
    else if ([other isKindOfClass:[self class]] == NO) {
        return NO;
    }
    else {
        G8RecognizedBlock *otherBlock = other;

        BOOL result = self.level == otherBlock.level;
        result = result && ABS(self.confidence - otherBlock.confidence) < FLT_EPSILON;
        result = result && CGRectEqualToRect(self.boundingBox, otherBlock.boundingBox);
        result = result && (self.text == otherBlock.text || [self.text isEqual:otherBlock.text]);

        return result;
    }
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
