//
//  RecognitionTests.m
//  Tesseract OCR iOS Tests
//
//  Created by Nikolay Volosatov on 12.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(RecognitionTests)

__block Tesseract *tesseract;

let(image, ^id{
    return nil;
});

void (^recognizeImage)() = ^{
    UIImage *bwImage = [image blackAndWhite];
    [tesseract setImage:bwImage];
    [tesseract recognize];
};

beforeEach(^{
    tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];

    [tesseract setVariableValue:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                         forKey:@"tessedit_char_whitelist"];
});

describe(@"Simple numbers", ^{

    let(image, ^id{
        return [UIImage imageNamed:@"image_sample.jpg"];
    });

    it(@"Should recognize", ^{
        recognizeImage();

        NSString *recognizedText = [tesseract recognizedText];
        [[recognizedText should] containString:@"1234567890"];
    });
    
});

SPEC_END