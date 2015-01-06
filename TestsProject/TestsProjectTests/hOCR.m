//
//  hOCR.m
//  TestsProject
//
//  Created by Kirill Makankov on 06.01.15.
//  Copyright (c) 2015 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kiwi/Kiwi.h>

#import "G8RecognitionTestsHelper.h"

SPEC_BEGIN(hOCRTests)

__block G8RecognitionTestsHelper *helper;

beforeEach(^{
    helper = [[G8RecognitionTestsHelper alloc] init];
});

describe(@"hOCR", ^{
    
    it(@"Should sample image", ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"image_sample" ofType:@"hOCR"];

        helper.image = [UIImage imageNamed:@"image_sample.jpg"];
        helper.charWhitelist = @"0123456789";
        
        [helper recognizeImage];
        NSString *hOCR = [helper.tesseract recognizedHOCRForPageNumber:0];
        
        NSError *error = nil;
        [[hOCR should] equal:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]];
        NSAssert(error == nil, @"error loading hOCR from file %@: %@", path, error);
    });
    
    it(@"Should well scanced page", ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"well_scaned_page" ofType:@"hOCR"];

        helper.image = [UIImage imageNamed:@"well_scaned_page"];
        
        [helper recognizeImage];
        NSString *hOCR = [helper.tesseract recognizedHOCRForPageNumber:0];
        
        NSError *error = nil;
        [[hOCR should] equal:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]];
        NSAssert(error == nil, @"error loading hOCR from file %@: %@", path, error);
    });
    
    it(@"Should return nil without prerecognition", ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] init];

        NSString *hOCR = [tesseract recognizedHOCRForPageNumber:0];
        [[hOCR should] beNil];
    });
});

SPEC_END
