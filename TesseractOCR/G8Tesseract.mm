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
#import "G8TesseractParameters.h"
#import "G8Constants.h"
#import "G8RecognizedBlock.h"

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
    ETEXT_DESC *_monitor;
}

@property (nonatomic, copy) NSString *dataPath;
@property (nonatomic, copy) NSArray *configFileNames;
@property (nonatomic, strong) NSMutableDictionary *variables;

@property (readwrite, assign) CGSize imageSize;

@property (nonatomic, assign, getter=isRecognized) BOOL recognized;
@property (nonatomic, assign, getter=isLayoutAnalysed) BOOL layoutAnalysed;

@property (nonatomic, assign) G8Orientation orientation;
@property (nonatomic, assign) G8WritingDirection writingDirection;
@property (nonatomic, assign) G8TextlineOrder textlineOrder;
@property (nonatomic, assign) CGFloat deskewAngle;

@end

@implementation G8Tesseract

+ (NSString *)version
{
    const char *version = tesseract::TessBaseAPI::Version();
    if (version != NULL) {
        return [NSString stringWithUTF8String:version];
    }
    return @"n/a";
}

- (id)init
{
    return [self initWithLanguage:nil];
}

- (id)initWithLanguage:(NSString*)language
{
    return [self initWithDataPath:nil language:language engineMode:G8OCREngineModeTesseractOnly configFileNames:nil];
}

- (id)initWithLanguage:(NSString *)language engineMode:(G8OCREngineMode)engineMode
{
    return [self initWithDataPath:nil language:language engineMode:engineMode configFileNames:nil];
}

- (id)initWithDataPath:(NSString *)dataPath
              language:(NSString *)language
            engineMode:(G8OCREngineMode)engineMode
       configFileNames:(NSArray*)configFileNames
{
    self = [super init];
    if (self != nil) {
        _dataPath = [dataPath copy];
        _language = [language copy];
        _configFileNames = [configFileNames copy];
        _engineMode = engineMode;
        _pageSegmentationMode = G8PageSegmentationModeSingleBlock;
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
}

- (void)setUpTesseractToSearchTrainedDataInTrainedDataFolderOfTheApplicatinBundle
{
    _dataPath =
        [NSString stringWithFormat:@"%@/", [NSString stringWithString:[[NSBundle mainBundle] bundlePath]]];
    setenv("TESSDATA_PREFIX", _dataPath.UTF8String, 1);
}

- (BOOL)initEngine
{
    int count = (int)self.configFileNames.count;
    const char **configs = (const char**)malloc(sizeof(int) * count);
    for (int i = 0; i < count; i++) {
        configs[i] = [[self.dataPath stringByAppendingPathComponent:@"tessdata"] stringByAppendingPathComponent:self.configFileNames[i]].UTF8String;
    }
    int returnCode = _tesseract->Init(self.dataPath.UTF8String, self.language.UTF8String,
                                      (tesseract::OcrEngineMode)self.engineMode,
                                      (char**)configs, count,
                                      NULL,
                                      NULL,
                                      false);
    if (configs) {
        delete configs;
    }
    return returnCode == 0;
}

- (void)resetFlags
{
    self.recognized = NO;
    self.layoutAnalysed = NO;
}

- (BOOL)resetEngine
{
    BOOL isInitDone = [self initEngine];
    if (isInitDone) {
        [self loadVariables];
        [self resetFlags];
    }
    else {
        NSLog(@"ERROR! Can't init Tesseract engine.");
    }

    return isInitDone;
}

- (void)copyDataToDocumentsDirectory
{
    // Useful paths
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths.firstObject;
    _dataPath = [documentPath stringByAppendingPathComponent:self.dataPath];

    //	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"grc" ofType:@"traineddata"];
    NSLog(@"DATAPATH %@", _dataPath);

    // Copy data in Doc Directory
    if ([fileManager fileExistsAtPath:_dataPath] == NO) {
        [fileManager createDirectoryAtPath:_dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    for (NSString *languageName in [self.language componentsSeparatedByString:@"+"]) {
        NSString *tessdataPath = [bundle pathForResource:languageName ofType:@"traineddata"];

        if (tessdataPath != nil) {
            NSString *destinationPath = [_dataPath stringByAppendingPathComponent:tessdataPath.lastPathComponent];

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

    [self resetFlags];

    self.variables[key] = value;
    _tesseract->SetVariable(key.UTF8String, value.UTF8String);
}

- (void)setVariablesFromDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in dictionary.allKeys) {
        NSString *value = dictionary[key];
        [self setVariableValue:value forKey:key];
    }
}

- (void)loadVariables
{
    for (NSString *key in self.variables.allKeys) {
        NSString *value = self.variables[key];
        _tesseract->SetVariable(key.UTF8String, value.UTF8String);
    }
}

#pragma mark - Getters and setters

- (void)setLanguage:(NSString *)language
{
    if ([_language isEqualToString:language] == NO) {
        _language = [language copy];

        /*
         * "WARNING: On changing languages, all Tesseract parameters
         * are reset back to their default values."
         */
        [self resetEngine];
    }
}

- (void)setEngineMode:(G8OCREngineMode)engineMode
{
    if (_engineMode != engineMode) {
        _engineMode = engineMode;

        [self resetEngine];
    }
}

- (void)setPageSegmentationMode:(G8PageSegmentationMode)pageSegmentationMode
{
    if (_pageSegmentationMode != pageSegmentationMode) {
        _pageSegmentationMode = pageSegmentationMode;

        [self setVariableValue:[NSString stringWithFormat:@"%lu", (unsigned long)pageSegmentationMode]
                        forKey:kG8ParamTesseditPagesegMode];
    }
}

- (void)setCharWhitelist:(NSString *)charWhitelist
{
    if ([_charWhitelist isEqualToString:charWhitelist] == NO) {
        _charWhitelist = [charWhitelist copy];

        [self setVariableValue:charWhitelist forKey:kG8ParamTesseditCharWhitelist];
    }
}

- (void)setCharBlacklist:(NSString *)charBlacklist
{
    if ([_charBlacklist isEqualToString:charBlacklist] == NO) {
        _charBlacklist = [charBlacklist copy];

        [self setVariableValue:charBlacklist forKey:kG8ParamTesseditCharBlacklist];
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        if (image.size.width <= 0 || image.size.height <= 0) {
            NSLog(@"WARNING: Image has not size!");
            return;
        }

        self.imageSize = image.size; //self.imageSize used in the characterBoxes method
        int width = self.imageSize.width;
        int height = self.imageSize.height;

        CGImage *cgImage = image.CGImage;
        CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
        const UInt8 *pixels = CFDataGetBytePtr(data);

        size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
        size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);

        if (bytesPerRow > MAX_INT32) {
            NSLog(@"ERROR: Image is too big");
            return;
        }

        @try {
            _tesseract->SetImage(pixels, width, height, (int)(bitsPerPixel/bitsPerComponent), (int)bytesPerRow);
        }
        @catch (NSException *exception) {
            NSLog(@"ERROR: Can't set image: %@", exception);
        }

        CFRelease(data);

        _image = image;
        [self resetFlags];
    }
}

- (void)setRect:(CGRect)rect
{
    if (CGRectEqualToRect(_rect, rect) == NO) {
        _rect = rect;

        _tesseract->SetRectangle(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        [self resetFlags];
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

- (G8Orientation)orientation
{
    if (self.layoutAnalysed == NO) {
        [self analyzeLayout];
    }
    return _orientation;
}

- (G8WritingDirection)writingDirection
{
    if (self.layoutAnalysed == NO) {
        [self analyzeLayout];
    }
    return _writingDirection;
}

- (G8TextlineOrder)textlineOrder
{
    if (self.layoutAnalysed == NO) {
        [self analyzeLayout];
    }
    return _textlineOrder;
}

- (CGFloat)deskewAngle
{
    if (self.layoutAnalysed == NO) {
        [self analyzeLayout];
    }
    return _deskewAngle;
}

- (void)analyzeLayout
{
    tesseract::Orientation orientation;
    tesseract::WritingDirection direction;
    tesseract::TextlineOrder order;
    float deskewAngle;

    tesseract::PageIterator *iterator = _tesseract->AnalyseLayout();
    iterator->Orientation(&orientation, &direction, &order, &deskewAngle);
    delete iterator;

    self.orientation = (G8Orientation)orientation;
    self.writingDirection = (G8WritingDirection)direction;
    self.textlineOrder = (G8TextlineOrder)order;
    self.deskewAngle = deskewAngle;

    self.layoutAnalysed = YES;
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

            G8RecognizedBlock *block = [[G8RecognizedBlock alloc] initWithText:boxComponents[0]
                                                                   boundingBox:box
                                                                    confidence:0.0f
                                                                         level:G8PageIteratorLevelBlock];
            [recognizedTextBoxes addObject:block];
        }
    }
    return [recognizedTextBoxes copy];
}

- (G8RecognizedBlock *)blockFromIterator:(tesseract::ResultIterator *)iterator
                           iteratorLevel:(G8PageIteratorLevel)iteratorLevel
{
    tesseract::PageIteratorLevel level = (tesseract::PageIteratorLevel)iteratorLevel;

    G8RecognizedBlock *block = nil;
    const char *word = iterator->GetUTF8Text(level);
    if (word != NULL) {
        // BoundingBox parameters are (Left Top Right Bottom).
        // See comment in characterBoxes() for information on the coordinate
        // system, and changes being made.
        int x1, y1, x2, y2;
        iterator->BoundingBox(level, &x1, &y1, &x2, &y2);

        CGFloat x = x1;
        CGFloat y = y1;
        CGFloat width = x2 - x1;
        CGFloat height = y2 - y1;

        NSString *text = [NSString stringWithUTF8String:word];
        CGRect boundingBox = CGRectMake(x, y, width, height);
        CGFloat confidence = iterator->Confidence(level);
        delete[] word;

        block = [[G8RecognizedBlock alloc] initWithText:text
                                            boundingBox:boundingBox
                                             confidence:confidence
                                                  level:iteratorLevel];
    }
    return block;
}

- (NSArray *)characterChoices
{
    NSMutableArray *array = [NSMutableArray array];
    //  Get iterators
    tesseract::ResultIterator *resultIterator = _tesseract->GetIterator();

    if (resultIterator != NULL) {
        do {
            G8RecognizedBlock *block = [self blockFromIterator:resultIterator iteratorLevel:G8PageIteratorLevelSymbol];
            NSMutableArray *choices = [NSMutableArray array];

            tesseract::ChoiceIterator choiceIterator(*resultIterator);
            do {
                const char *choiceWord = choiceIterator.GetUTF8Text();
                if (choiceWord != NULL) {
                    NSString *text = [NSString stringWithUTF8String:choiceWord];
                    CGFloat confidence = choiceIterator.Confidence();

                    G8RecognizedBlock *choiceBlock = [[G8RecognizedBlock alloc] initWithText:text
                                                                                 boundingBox:block.boundingBox
                                                                                  confidence:confidence
                                                                                       level:G8PageIteratorLevelSymbol];
                    [choices addObject:choiceBlock];
                }
            } while (choiceIterator.Next());

            [array addObject:[choices copy]];
        } while (resultIterator->Next(tesseract::RIL_SYMBOL));
        delete resultIterator;
    }
    
    return [array copy];
}

- (NSArray *)confidencesByIteratorLevel:(G8PageIteratorLevel)pageIteratorLevel
{
    tesseract::PageIteratorLevel level = (tesseract::PageIteratorLevel)pageIteratorLevel;

    NSMutableArray *array = [NSMutableArray array];
    //  Get iterators
    tesseract::ResultIterator *resultIterator = _tesseract->GetIterator();

    if (resultIterator != NULL) {
        do {
            G8RecognizedBlock *block = [self blockFromIterator:resultIterator iteratorLevel:pageIteratorLevel];
            if (block != nil) {
                [array addObject:block];
            }
        } while (resultIterator->Next(level));
        delete resultIterator;
    }
    
    return [array copy];
}

- (UIImage *)imageWithBlocks:(NSArray *)blocks drawText:(BOOL)drawText thresholded:(BOOL)thresholded
{
    UIImage *image = thresholded ? self.thresholdedImage : self.image;

    UIGraphicsBeginImageContextWithOptions(self.imageSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);

    [image drawInRect:(CGRect){CGPointZero, self.imageSize}];

    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    for (G8RecognizedBlock *block in blocks) {
        CGRect boundingBox = block.boundingBox;
        CGRect rect = CGRectMake(boundingBox.origin.x, boundingBox.origin.y,
                                 boundingBox.size.width, boundingBox.size.height);
        CGContextStrokeRect(context, rect);

        if (drawText) {
            NSAttributedString *string =
                [[NSAttributedString alloc] initWithString:block.text attributes:@{
                    NSForegroundColorAttributeName: [UIColor redColor]
                }];
            [string drawAtPoint:(CGPoint){CGRectGetMidX(rect), CGRectGetMaxY(rect) + 2}];
        }
    }

    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

#pragma mark - Other functions

- (BOOL)recognize
{
    if (self.maximumRecognitionTime > FLT_EPSILON) {
        _monitor->set_deadline_msecs((inT32)(self.maximumRecognitionTime * 1000));
    }

    self.recognized = NO;
    int returnCode = 0;
    @try {
        returnCode = _tesseract->Recognize(_monitor);
        self.recognized = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception was raised while recognizing: %@", exception);
    }
    return returnCode == 0 && self.recognized;
}

- (UIImage *)thresholdedImage
{
    Pix *pixs = _tesseract->GetThresholdedImage();
    Pix *pix = pixUnpackBinary(pixs, 32, 0);

    pixDestroy(&pixs);

    return [self imageFromPix:pix];
}

- (UIImage *)imageFromPix:(Pix *)pix
{
    // Get Pix parameters
    l_uint32 width = pixGetWidth(pix);
    l_uint32 height = pixGetHeight(pix);
    l_uint32 bitsPerPixel = pixGetDepth(pix);
    l_uint32 bytesPerRow = pixGetWpl(pix) * 4;
    l_uint32 bitsPerComponent = 8;
    // By default Leptonica uses 3 spp (RGB)
    if (pixSetSpp(pix, 4) == 0) {
        bitsPerComponent = bitsPerPixel / pixGetSpp(pix);
    }

    l_uint32 *pixData = pixGetData(pix);

    // Create CGImage
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, pixData, bytesPerRow * height, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGImageRef cgImage = CGImageCreate(width, height,
                                       bitsPerComponent, bitsPerPixel, bytesPerRow,
                                       colorSpace, kCGBitmapByteOrderDefault,
                                       provider, NULL, NO, kCGRenderingIntentDefault);

    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    pixDestroy(&pix);

    // Draw CGImage to create UIImage
    //      Creating UIImage by [UIImage imageWithCGImage:] worked wrong
    //      and image became broken after some releases.
    CGRect frame = { CGPointZero, CGSizeMake(width, height) };
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Context must be mirrored vertical
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, frame, cgImage);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);

    return image;
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

    [self tesseractProgressCallbackFunction:words];

    BOOL isCancel = NO;
    if ([self.delegate respondsToSelector:@selector(shouldCancelImageRecognitionForTesseract:)]) {
        isCancel = [self.delegate shouldCancelImageRecognitionForTesseract:self];
    }
    return isCancel;
}

@end
