//
//  RecognitionTests.m
//  TestsProjectTests
//
//  Created by Nikolay Volosatov on 15.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <Kiwi/Kiwi.h>

static NSTimeInterval const kTSMaximumRecognitionTime = 5.0;
static NSString *const kTSLanguages = @"eng+ita";
static NSString *const kTSWhiteList = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

SPEC_BEGIN(RecognitionTests)

void (^wait)(NSTimeInterval, BOOL (^)()) = ^(NSTimeInterval maximumWait, BOOL (^shouldKeepRunning)()) {
    NSDate *deadlineDate = [NSDate dateWithTimeInterval:maximumWait sinceDate:[NSDate date]];
    BOOL isDeadline = NO;
    while (shouldKeepRunning != nil && shouldKeepRunning() && isDeadline == NO) {
        if ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:deadlineDate] == NO) {
            break;
        }
        isDeadline = [[NSDate date] compare:deadlineDate] == NSOrderedDescending;
    }
};

__block Tesseract *tesseract;

let(image, ^id{
    return nil;
});

void (^recognizeImage)() = ^{
    tesseract = [[Tesseract alloc] initWithLanguage:kTSLanguages];

    [tesseract setVariableValue:kTSWhiteList
                         forKey:kTSTesseditCharWhitelist];

    UIImage *bwImage = [image blackAndWhite];
    [tesseract setImage:bwImage];
    [tesseract recognize];
};

void (^recognizeImageUsingOperation)() = ^{
    RecognitionOperation *operation = [[RecognitionOperation alloc] init];

    operation.tesseract.language = kTSLanguages;
    operation.tesseract.image = image;
    [operation.tesseract setVariableValue:kTSWhiteList forKey:kTSTesseditCharWhitelist];

    tesseract = nil;
    operation.recognitionCompleteBlock = ^(Tesseract *recognizedTesseract) {
        tesseract = recognizedTesseract;
    };

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

    wait(kTSMaximumRecognitionTime, ^{
        return (BOOL)(tesseract == nil);
    });
};

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

describe(@"NSOperation usage", ^{

    let(image, ^id{
        return [UIImage imageNamed:@"image_sample.jpg"];
    });

    it(@"Should recognize", ^{
        recognizeImageUsingOperation();

        NSString *recognizedText = [tesseract recognizedText];
        [[recognizedText should] containString:@"1234567890"];
    });
});

SPEC_END
