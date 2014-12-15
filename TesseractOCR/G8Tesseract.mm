//
//  G8Tesseract.mm
//  Tesseract OCR iOS
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import "G8Tesseract.h"

#import "UIImage+G8Filters.h"

#import "baseapi.h"
#import "environ.h"
#import "pix.h"
#import "ocrclass.h"
#import "allheaders.h"

namespace tesseract {
    class TessBaseAPI;
};

@interface G8Tesseract () {
    tesseract::TessBaseAPI *_tesseract;
    //const UInt8 *_pixels;
    Pix *_currentPix;
    ETEXT_DESC *_monitor;
}

@property (nonatomic, copy) NSString *dataPath;
@property (nonatomic, strong) NSMutableDictionary *variables;

@property (readwrite, assign) CGSize imageSize;

@end

@implementation G8Tesseract

+ (NSString *)version
{
    return [NSString stringWithFormat:@"%s", tesseract::TessBaseAPI::Version()];
}

- (id)init
{
    return [self initWithLanguage:nil];
}

- (id)initWithLanguage:(NSString*)language
{
    return [self initPrivateWithDataPath:nil language:language];
}

- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language
{
    return [self initPrivateWithDataPath:dataPath language:language];
}

- (id)initPrivateWithDataPath:(NSString *)dataPath language:(NSString *)language
{
    self = [super init];
    if (self != nil) {
        _dataPath = [dataPath copy];
        _language = [language copy];
        _variables = [NSMutableDictionary dictionary];

        _monitor = new ETEXT_DESC();
        _monitor->cancel = (CANCEL_FUNC)[self methodForSelector:@selector(tesseractCancelCallbackFunction:)];
        _monitor->cancel_this = (__bridge void*)self;

        if (dataPath != nil) {
            [self copyDataToDocumentsDirectory];
        }
        else {
            [self setUpTesseractToSearchTrainedDataInTrainedDataFolderOfTheApplicatinBundle];
        }

        _tesseract = new tesseract::TessBaseAPI();

        BOOL success = [self initEngine];
        if (success == NO) {
            self = nil;
        }
    }
    return self;
}

- (void)dealloc
{
    if (_monitor != nullptr) {
        free(_monitor);
        _monitor = nullptr;
    }
    if (_tesseract != nullptr) {
        // There is no needs to call Clear() and End() explicitly.
        // End() is sufficient to free up all memory of TessBaseAPI.
        // End() is called in destructor of TessBaseAPI.
        delete _tesseract;
        _tesseract = nullptr;
    }
    if (_currentPix != nullptr) {
        pixDestroy(&_currentPix);
    }
}

- (void)setUpTesseractToSearchTrainedDataInTrainedDataFolderOfTheApplicatinBundle
{
    NSString *datapath =
    [NSString stringWithFormat:@"%@/", [NSString stringWithString:[[NSBundle mainBundle] bundlePath]]];
    setenv("TESSDATA_PREFIX", datapath.UTF8String, 1);
}

- (BOOL)initEngine
{
    int returnCode = _tesseract->Init(self.dataPath.UTF8String, self.language.UTF8String);
    return returnCode == 0;
}

- (void)copyDataToDocumentsDirectory
{
    // Useful paths
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths.firstObject;
    NSString *dataPath = [documentPath stringByAppendingPathComponent:self.dataPath];

    //	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"grc" ofType:@"traineddata"];
    NSLog(@"DATAPATH %@", dataPath);

    // Copy data in Doc Directory
    if ([fileManager fileExistsAtPath:dataPath] == NO) {
        [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    for (NSString *languageName in [self.language componentsSeparatedByString:@"+"]) {
        NSString *tessdataPath = [bundle pathForResource:languageName ofType:@"traineddata"];

        if (tessdataPath != nil) {
            NSString *destinationPath = [dataPath stringByAppendingPathComponent:tessdataPath.lastPathComponent];

            if([fileManager fileExistsAtPath:destinationPath] == NO) {
                NSError *error = nil;
                NSLog(@"found %@", tessdataPath);
                NSLog(@"coping in %@", destinationPath);
                [fileManager copyItemAtPath:tessdataPath toPath:destinationPath error:&error];

                if(error != nil) {
                    NSLog(@"ERROR! %@", error.description);
                }
            }
        }
    }

    setenv("TESSDATA_PREFIX", [documentPath stringByAppendingString:@"/"].UTF8String, 1);
}

- (void)setVariableValue:(NSString *)value forKey:(NSString *)key
{
    /*
     * Example:
     * _tesseract->SetVariable("tessedit_char_whitelist", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ");
     * _tesseract->SetVariable("language_model_penalty_non_freq_dict_word", "0");
     * _tesseract->SetVariable("language_model_penalty_non_dict_word ", "0");
     */

    [self.variables setValue:value forKey:key];
    _tesseract->SetVariable(key.UTF8String, value.UTF8String);
}

- (void)loadVariables
{
    for (NSString *key in self.variables) {
        NSString *value = [self.variables objectForKey:key];
        _tesseract->SetVariable(key.UTF8String, value.UTF8String);
    }
}

#pragma mark - Getters and setters

- (void)setLanguage:(NSString *)language
{
    if ([_language isEqualToString:language] == NO) {
        _language = language;
        BOOL inInitDone = [self initEngine];

        /*
         * "WARNING: On changing languages, all Tesseract parameters
         * are reset back to their default values."
         */
        if (inInitDone) {
            [self loadVariables];
        }
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;

        if (image.size.width <= 0 || image.size.height <= 0) {
            NSLog(@"WARNING: Image has not size!");
            return;
        }

        self.imageSize = image.size; //self.imageSize used in the characterBoxes method
        int width = self.imageSize.width;
        int height = self.imageSize.height;

        CGImage *cgImage = image.CGImage;
        CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
        const UInt8 *_pixels = CFDataGetBytePtr(data);

        size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
        size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);

        if (bytesPerRow > MAX_INT32) {
            NSLog(@"ERROR: Image is too big");
            return;
        }

        tesseract::ImageThresholder *imageThresholder = new tesseract::ImageThresholder();
        @try {
            imageThresholder->SetImage(_pixels, width, height, (int)(bitsPerPixel/bitsPerComponent), (int)bytesPerRow);
            if (_currentPix != nullptr) {
                pixDestroy(&_currentPix);
            }
            _currentPix = imageThresholder->GetPixRect();
            _tesseract->SetImage(_currentPix);
        }
        @finally {
            imageThresholder->Clear();
            delete imageThresholder;
        }

        CFRelease(data);
    }
}

- (void)setRect:(CGRect)rect
{
    if (CGRectEqualToRect(_rect, rect) == NO) {
        _rect = rect;

        _tesseract->SetRectangle(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }
}

- (NSUInteger)progress
{
    return _monitor->progress;
}

#pragma mark - Result fetching

- (NSString *)recognizedText
{
    char *utf8Text = _tesseract->GetUTF8Text();
    if (utf8Text == NULL) {
        NSLog(@"No recognized text. Check that -[Tesseract setImage:] is passed an image bigger than 0x0.");
        return nil;
    }

    NSString *text = [NSString stringWithUTF8String:utf8Text];
    delete[] utf8Text;
    return text;
}

- (NSArray *)characterBoxes
{
    NSMutableArray *recognizedTextBoxes = [[NSMutableArray alloc] init];

    //  Get box info
    char *boxText = _tesseract->GetBoxText(0);
    if (boxText == NULL) {
        NSLog(@"No boxes recognized. Check that -[Tesseract setImage:] is passed an image bigger than 0x0.");
        return nil;
    }

    NSString *stringBoxes = [NSString stringWithUTF8String:boxText];
    delete[] boxText;

    NSArray *arrayOfStringBoxes = [stringBoxes componentsSeparatedByString:@"\n"];
    for (NSString *stringBox in arrayOfStringBoxes) {
        //  A stringBox is of the format "c L B R T p"
        //  (L, T) is the top left corner of the box, and (R, B) is the bottom right corner
        //  Tesseract has (0, 0) in the bottom left corner and UIKit has (0, 0) in the top left corner
        //  Need to flip to work with UIKit
        //  c is the recognized character and p is the page it is recognized on
        NSArray *boxComponents = [stringBox componentsSeparatedByString:@" "];
        if (boxComponents.count >= 6) {
            CGFloat x = [boxComponents[1] floatValue];
            CGFloat y = self.imageSize.height - [boxComponents[4] floatValue];
            CGFloat width = [boxComponents[3] floatValue] - [boxComponents[1] floatValue];
            CGFloat height = [boxComponents[4] floatValue] - [boxComponents[2] floatValue];
            CGRect box = CGRectMake(x, y, width, height);

            NSDictionary *resultDict = @{
                @"text":    boxComponents[0],
                @"box":     [NSValue valueWithCGRect:box],
            };
            [recognizedTextBoxes addObject:resultDict];
        }
    }
    return [recognizedTextBoxes copy];
}

- (NSArray *)getConfidences:(tesseract::PageIteratorLevel)level
{
    NSMutableArray *array = [NSMutableArray array];
    //  Get iterators
    tesseract::ResultIterator *resultIterator = _tesseract->GetIterator();

    if (resultIterator != NULL) {
        do {
            // BoundingBox parameters are (Left Top Right Bottom).
            // See comment in characterBoxes() for information on the coordinate
            // system, and changes being made.
            int x1, y1, x2, y2;
            resultIterator->BoundingBox(level, &x1, &y1, &x2, &y2);

            CGFloat x = x1;
            CGFloat y = self.imageSize.height - y1;
            CGFloat width = x2 - x1;
            CGFloat height = y1 - y2;
            CGRect box = CGRectMake(x, y, width, height);

            const char *word = resultIterator->GetUTF8Text(level);
            if (word != NULL) {
                float conf = resultIterator->Confidence(level);

                [array addObject:@{
                    @"text":         [NSString stringWithUTF8String:word],
                    @"confidence":   [NSNumber numberWithFloat:conf],
                    @"boundingbox":  [NSValue valueWithCGRect:box]
                }];
                delete[] word;
            }
        } while (resultIterator->Next(level));
    }

    return [array copy];
}

- (NSArray *)getConfidenceByWord
{
    return [self getConfidences:tesseract::RIL_WORD];
}

- (NSArray *)getConfidenceBySymbol
{
    return [self getConfidences:tesseract::RIL_SYMBOL];
}

- (NSArray *)getConfidenceByBlock
{
    return [self getConfidences:tesseract::RIL_BLOCK];
}

- (NSArray *)getConfidenceByTextline
{
    return [self getConfidences:tesseract::RIL_TEXTLINE];
}

- (NSArray *)getConfidenceByParagraph
{
    return [self getConfidences:tesseract::RIL_PARA];
}

#pragma mark - Other functions

- (void)clear
{
    // Free up all memory in dealloc.
    NSLog(@"clear is deprecated. Free up all memory in dealloc.");
}

- (BOOL)recognize
{
    int returnCode = _tesseract->Recognize(_monitor);
    return returnCode == 0;
}

- (void)tesseractProgressCallbackFunction:(int)words
{
    if([self.delegate respondsToSelector:@selector(progressImageRecognitionForTesseract:)]) {
        [self.delegate progressImageRecognitionForTesseract:self];
    }
}

- (BOOL)tesseractCancelCallbackFunction:(int)words
{
    if (_monitor->ocr_alive == 1) {
        _monitor->ocr_alive = 0;
    }
    
    BOOL isCancel = NO;
    if ([self.delegate respondsToSelector:@selector(shouldCancelImageRecognitionForTesseract:)]) {
        isCancel = [self.delegate shouldCancelImageRecognitionForTesseract:self];
    }
    return isCancel;
}

@end
