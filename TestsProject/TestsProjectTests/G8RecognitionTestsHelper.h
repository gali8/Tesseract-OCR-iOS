//
//  G8RecognitionTestsHelper.h
//  TestsProject
//
//  Created by Nikolay Volosatov on 25.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TesseractOCR/TesseractOCR.h>

typedef NS_ENUM(NSUInteger, G8CustomThresholder) {
    G8CustomThresholderNone,
    G8CustomThresholderSimple,
    G8CustomThresholderResize,
};

@interface G8RecognitionTestsHelper : NSObject <G8TesseractDelegate>

@property (nonatomic, assign) G8CustomThresholder customThresholderType;

@end
