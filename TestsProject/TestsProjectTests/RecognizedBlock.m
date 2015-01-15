//
//  RecognizedBlock.m
//  TestsProject
//
//  Created by Kirill Makankov on 12.01.15.
//  Copyright (c) 2015 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <Kiwi/Kiwi.h>
#import "Defaults.h"

SPEC_BEGIN(RecognizedBlockTests)

describe(@"RecognizedBlock Tests", ^{
    
    context(@"empty block", ^{
        let(emptyBlock, ^id{
            G8RecognizedBlock *block = [[G8RecognizedBlock alloc] init];
            [[block shouldNot] beNil];
            return block;
        });
        
        it(@"Should equal another empty block", ^{
            G8RecognizedBlock *block2 = [[G8RecognizedBlock alloc] init];
            [[block2 shouldNot] beNil];
            
            BOOL isEqual = [emptyBlock isEqual:block2];
            [[theValue(isEqual) should] beYes];
        });
        
        it(@"Should copy", ^{
            G8RecognizedBlock *block2 = [emptyBlock copy];
            [[block2 should] equal:emptyBlock];
            
            BOOL isEqual = [emptyBlock isEqual:block2];
            [[theValue(isEqual) should] beYes];
        });
        
        it(@"Should print description", ^{
            [[emptyBlock description] isEqualToString:@"(0.00%) '(null)'"];
        });
        
        it(@"Should compare with nil", ^{
            BOOL isEqual = [emptyBlock isEqual:nil];
            [[theValue(isEqual) should] beNo];
        });
        
        it(@"Should have the empty hash", ^{
            [[theValue([emptyBlock hash]) should] equal:theValue(0)];
        });
    });
    
    context(@"Not empty block", ^{
        NSString *originalText = @"not empty block";
        CGRect originalRect = CGRectMake(10.f, 10.7f, 134.95f, 5.2f);
        CGFloat originalConfidence = 0.29f;
        G8PageIteratorLevel originalLevel = G8PageIteratorLevelWord;
        
        let(notEmptyWordBlock, ^id{
            G8RecognizedBlock *block = [[G8RecognizedBlock alloc] initWithText:originalText
                                                                   boundingBox:originalRect
                                                                    confidence:originalConfidence
                                                                         level:originalLevel];
            [[block shouldNot] beNil];
            return block;
        });

        it(@"should isEqual", ^{
            BOOL isEqual = [notEmptyWordBlock isEqual:notEmptyWordBlock];
            [[theValue(isEqual) should] beYes];
        });
        
        it(@"Should not isEqual", ^{
            
            BOOL isEqual = [notEmptyWordBlock isEqual:[[G8RecognizedBlock alloc] init]];
            [[theValue(isEqual) should] beNo];
            
            isEqual = [notEmptyWordBlock isEqual:[[G8RecognizedBlock alloc] initWithText:@"different text"
                                                                             boundingBox:originalRect
                                                                              confidence:originalConfidence
                                                                                   level:originalLevel]];
            [[theValue(isEqual) should] beNo];
            
            isEqual = [notEmptyWordBlock isEqual:[[G8RecognizedBlock alloc] initWithText:originalText
                                                                             boundingBox:CGRectMake(10.00001f, 10.69999f, 134.95001f, 5.19999f)
                                                                              confidence:originalConfidence
                                                                                   level:originalLevel]];
            [[theValue(isEqual) should] beNo];
            
            isEqual = [notEmptyWordBlock isEqual:[[G8RecognizedBlock alloc] initWithText:originalText
                                                                             boundingBox:originalRect
                                                                              confidence:0.78f
                                                                                   level:originalLevel]];
            [[theValue(isEqual) should] beNo];
            
            isEqual = [notEmptyWordBlock isEqual:[[G8RecognizedBlock alloc] initWithText:originalText
                                                                             boundingBox:originalRect
                                                                              confidence:originalConfidence
                                                                                   level:G8PageIteratorLevelParagraph]];
            [[theValue(isEqual) should] beNo];
        });
    });
});

SPEC_END
