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
#import "UIImage+G8FixOrientation.h"
#import "G8TesseractParameters.h"
#import "G8Constants.h"
#import "G8RecognizedBlock.h"

#import "baseapi.h"
#import "environ.h"
#import "pix.h"
#import "ocrclass.h"
#import "allheaders.h"
#import "genericvector.h"
#import "strngs.h"

NSInteger const kG8DefaultResolution = 72;
NSInteger const kG8MinCredibleResolution = 70;
NSInteger const kG8MaxCredibleResolution = 2400;

namespace tesseract {
    class TessBaseAPI;
};

@interface G8Tesseract () {
    tesseract::TessBaseAPI *_tesseract;
    ETEXT_DESC *_monitor;
}

@property (nonatomic, strong) NSDictionary *configDictionary;
@property (nonatomic, strong) NSArray *configFileNames;
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

+ (void)initialize {
    
    [super initialize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMemoryWarningNotification:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

+ (void)didReceiveMemoryWarningNotification:(NSNotification*)notification {
    
    [self clearCache];
    // some more cleaning here if necessary
}

+ (NSString *)version
{
    const char *version = tesseract::TessBaseAPI::Version();
    return [NSString stringWithUTF8String:version];
}

+ (void)clearCache
{
    tesseract::TessBaseAPI::ClearPersistentCache();
}

- (id)initWithLanguage:(NSString*)language
{
    return [self initWithLanguage:language configDictionary:nil configFileNames:nil cachesRelatedDataPath:nil engineMode:G8OCREngineModeTesseractOnly];
}

- (id)initWithLanguage:(NSString *)language engineMode:(G8OCREngineMode)engineMode
{
    return [self initWithLanguage:language configDictionary:nil configFileNames:nil cachesRelatedDataPath:nil engineMode:engineMode];
}
- (id)initWithLanguage:(NSString *)language
      configDictionary:(NSDictionary *)configDictionary
       configFileNames:(NSArray *)configFileNames
 cachesRelatedDataPath:(NSString *)cachesRelatedPath
            engineMode:(G8OCREngineMode)engineMode
{
    NSString *absoluteDataPath = nil;
    if (cachesRelatedPath) {
        // config Tesseract to search trainedData in tessdata folder of the Caches folder
        NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = cachesPaths.firstObject;

        absoluteDataPath = [cachesPath stringByAppendingPathComponent:cachesRelatedPath].copy;
    }
    return [self initWithLanguage:language
                 configDictionary:configDictionary
                  configFileNames:configFileNames
                 absoluteDataPath:absoluteDataPath
                       engineMode:engineMode
            copyFilesFromResources:cachesRelatedPath != nil];
}

- (id)initWithLanguage:(NSString *)language
      configDictionary:(NSDictionary *)configDictionary
       configFileNames:(NSArray *)configFileNames
      absoluteDataPath:(NSString *)absoluteDataPath
            engineMode:(G8OCREngineMode)engineMode
copyFilesFromResources:(BOOL)copyFilesFromResources
{
    self = [super init];
    if (self != nil) {
        if (configFileNames) {
            NSAssert([configFileNames isKindOfClass:[NSArray class]], @"Error! configFileNames should be of type NSArray");
        }
        if (copyFilesFromResources && absoluteDataPath != nil) {
            BOOL moveDataSuccess = [self moveTessdataToDirectoryIfNecessary:absoluteDataPath];
            if (moveDataSuccess == NO) {
                return nil;
            }
        }
        _absoluteDataPath = [absoluteDataPath copy];
        _language = [language copy];
        _configDictionary = configDictionary;
        _configFileNames = configFileNames;
        _engineMode = engineMode;
        _pageSegmentationMode = G8PageSegmentationModeSingleBlock;
        _variables = [NSMutableDictionary dictionary];
        _sourceResolution = kG8DefaultResolution;
        _rect = CGRectZero;

        _monitor = new ETEXT_DESC();
        _monitor->cancel = (CANCEL_FUNC)[self methodForSelector:@selector(tesseractCancelCallbackFunction:)];
        _monitor->cancel_this = (__bridge void*)self;

        if (self.absoluteDataPath == nil) {
            // config Tesseract to search trainedData in tessdata folder of the application bundle];
            _absoluteDataPath = [NSString stringWithFormat:@"%@", [NSString stringWithString:[NSBundle mainBundle].bundlePath]].copy;
        }
        
        setenv("TESSDATA_PREFIX", [_absoluteDataPath stringByAppendingString:@"/"].UTF8String, 1);

        _tesseract = new tesseract::TessBaseAPI();

        BOOL success = [self configEngine];
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

- (BOOL)configEngine
{
    GenericVector<STRING> tessKeys;
    for( NSString *key in self.configDictionary.allKeys ){
        tessKeys.push_back(STRING(key.UTF8String));
    }

    GenericVector<STRING> tessValues;
    for( NSString *val in self.configDictionary.allValues ){
        tessValues.push_back(STRING(val.UTF8String));
    }
    
    int count = (int)self.configFileNames.count;
    const char **configs = count ? (const char **)malloc(sizeof(const char *) * count) : NULL;
    for (int i = 0; i < count; i++) {
        configs[i] = ((NSString*)self.configFileNames[i]).UTF8String;
    }
    int returnCode = _tesseract->Init(self.absoluteDataPath.UTF8String, self.language.UTF8String,
                                      (tesseract::OcrEngineMode)self.engineMode,
                                      (char **)configs, count,
                                      &tessKeys, &tessValues,
                                      false);
    if (configs != nullptr) {
        free(configs);
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
    BOOL isInitDone = [self configEngine];
    if (isInitDone) {
        [self loadVariables];
        [self resetFlags];
    }
    else {
        NSLog(@"ERROR! Can't init Tesseract engine.");
    }

    return isInitDone;
}

- (BOOL)moveTessdataToDirectoryIfNecessary:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Useful paths
    NSString *tessdataFolderName = @"tessdata";
    NSString *tessdataPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:tessdataFolderName];
    NSString *destinationPath = [directoryPath stringByAppendingPathComponent:tessdataFolderName];
    NSLog(@"Tesseract destination path: %@", destinationPath);
    
    if ([fileManager fileExistsAtPath:destinationPath] == NO) {
        NSError *error = nil;
        BOOL res = [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (res == NO) {
            NSLog(@"Error creating folder %@: %@", destinationPath, error);
            return NO;
        }
    }
    
    BOOL result = YES;
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:tessdataPath error:&error];
    if (files == nil) {
        NSLog(@"ERROR! %@", error.description);
        result = NO;
    } else {
        for (NSString *filename in files) {
            
            NSString *destinationFileName = [destinationPath stringByAppendingPathComponent:filename];
            if (![fileManager fileExistsAtPath:destinationFileName]) {
                
                NSString *filePath = [tessdataPath stringByAppendingPathComponent:filename];
                //NSLog(@"found %@", filePath);
                //NSLog(@"symlink in %@", destinationFileName);
                
                // delete broken symlinks first
                [fileManager removeItemAtPath:destinationFileName error:&error];
                
                // than recreate it
                error = nil;    // don't care about previous error, that can happens if we tried to remove a symlink, which doesn't exist
                BOOL res = [fileManager createSymbolicLinkAtPath:destinationFileName
                                             withDestinationPath:filePath
                                                           error:&error];
                if (res == NO) {
                    NSLog(@"Error creating symlink %@: %@", destinationPath, error);
                    result = NO;
                }
            }
        }
    }
    
    return result;
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

- (NSString*)variableValueForKey:(NSString *)key {
    
    STRING val;
    _tesseract->GetVariableAsString(key.UTF8String, &val);
    return [NSString stringWithUTF8String:val.string()];
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
            NSLog(@"ERROR: Image has not size!");
            return;
        }

        image = [image fixOrientation];
        
        self.imageSize = image.size; //self.imageSize used in the characterBoxes method

        Pix *pix = nullptr;

        if ([self.delegate respondsToSelector:@selector(preprocessedImageForTesseract:sourceImage:)]) {
            UIImage *thresholdedImage = [self.delegate preprocessedImageForTesseract:self sourceImage:image];
            if (thresholdedImage != nil) {
                self.imageSize = thresholdedImage.size;

                Pix *pixs = [self pixForImage:thresholdedImage];
                pix = pixConvertTo1(pixs, UINT8_MAX / 2);
                pixDestroy(&pixs);

                if (pix == nullptr) {
                    NSLog(@"WARNING: Can't create Pix for custom thresholded image!");
                }
            }
        }

        if (pix == nullptr) {
            pix = [self pixForImage:image];
        }

        @try {
            _tesseract->SetImage(pix);
        }
        @catch (NSException *exception) {
            NSLog(@"ERROR: Can't set image: %@", exception);
        }
        pixDestroy(&pix);

        _image = image;
        _rect = (CGRect){CGPointZero, self.imageSize};

        [self resetFlags];
    }
}

- (void)setRect:(CGRect)rect
{
    if (CGRectEqualToRect(_rect, rect) == NO) {
        _rect = rect;

        CGFloat x = CGRectGetMinX(rect);
        CGFloat y = CGRectGetMinY(rect);
        CGFloat width = CGRectGetWidth(rect);
        CGFloat height = CGRectGetHeight(rect);

        // Because of custom preprocessing we may have to resize rect
        if (CGSizeEqualToSize(self.image.size, self.imageSize) == NO) {
            CGFloat widthFactor = self.imageSize.width / self.image.size.width;
            CGFloat heightFactor = self.imageSize.height / self.image.size.height;

            x *= widthFactor;
            y *= heightFactor;
            width *= widthFactor;
            heightFactor *= heightFactor;
        }

        CGFloat (^clip)(CGFloat, CGFloat, CGFloat) = ^(CGFloat value, CGFloat min, CGFloat max) {
            return (value < min ? min : (value > max ? max : value));
        };

        // Clip rect by image size
        x = clip(x, 0, self.imageSize.width);
        y = clip(y, 0, self.imageSize.height);
        width = clip(width, 0, self.imageSize.width - x);
        height = clip(height, 0, self.imageSize.height - y);

        _tesseract->SetRectangle(x, y, width, height);
        [self resetFlags];
    }
}

- (void)setSourceResolution:(NSInteger)sourceResolution
{
    if (_sourceResolution != sourceResolution) {
        if (sourceResolution > kG8MaxCredibleResolution) {
            NSLog(@"Source resolution is too big: %ld > %ld", (long)sourceResolution, (long)kG8MaxCredibleResolution);
            sourceResolution = kG8MaxCredibleResolution;
        }
        else if (sourceResolution < kG8MinCredibleResolution) {
            NSLog(@"Source resolution is too small: %ld < %ld", (long)sourceResolution, (long)kG8MinCredibleResolution);
            sourceResolution = kG8MinCredibleResolution;
        }
        
        _sourceResolution = sourceResolution;

        _tesseract->SetSourceResolution((int)sourceResolution);
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
    [self analyseLayout];
    return _orientation;
}

- (G8WritingDirection)writingDirection
{
    [self analyseLayout];
    return _writingDirection;
}

- (G8TextlineOrder)textlineOrder
{
    [self analyseLayout];
    return _textlineOrder;
}

- (CGFloat)deskewAngle
{
    [self analyseLayout];
    return _deskewAngle;
}

- (void)analyseLayout
{
    // Only perform the layout analysis if we haven't already
    if (self.layoutAnalysed) return;

    tesseract::Orientation orientation;
    tesseract::WritingDirection direction;
    tesseract::TextlineOrder order;
    float deskewAngle;

    tesseract::PageIterator *iterator = _tesseract->AnalyseLayout();
    if (iterator == NULL) {
        NSLog(@"Can't analyse layout. Make sure 'osd.traineddata' available in 'tessdata'.");
        return;
    }

    iterator->Orientation(&orientation, &direction, &order, &deskewAngle);
    delete iterator;

    self.orientation = (G8Orientation)orientation;
    self.writingDirection = (G8WritingDirection)direction;
    self.textlineOrder = (G8TextlineOrder)order;
    self.deskewAngle = deskewAngle;

    self.layoutAnalysed = YES;
}


- (CGRect)normalizedRectForX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    x /= self.imageSize.width;
    y /= self.imageSize.height;
    width /= self.imageSize.width;
    height /= self.imageSize.height;
    return CGRectMake(x, y, width, height);
}

- (G8RecognizedBlock *)blockFromIterator:(tesseract::ResultIterator *)iterator
                           iteratorLevel:(G8PageIteratorLevel)iteratorLevel
{
    tesseract::PageIteratorLevel level = (tesseract::PageIteratorLevel)iteratorLevel;

    G8RecognizedBlock *block = nil;
    const char *word = iterator->GetUTF8Text(level);
    if (word != NULL) {
        // BoundingBox parameters are (Left Top Right Bottom).
        //  (L, T) is the top left corner of the box, and (R, B) is the bottom right corner
        //  Tesseract has (0, 0) in the bottom left corner and UIKit has (0, 0) in the top left corner
        //  Need to flip to work with UIKit
        int x1, y1, x2, y2;
        iterator->BoundingBox(level, &x1, &y1, &x2, &y2);

        CGFloat x = x1;
        CGFloat y = y1;
        CGFloat width = x2 - x1;
        CGFloat height = y2 - y1;

        NSString *text = [NSString stringWithUTF8String:word];
        CGRect boundingBox = [self normalizedRectForX:x y:y width:width height:height];
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

- (NSArray *)recognizedBlocksByIteratorLevel:(G8PageIteratorLevel)pageIteratorLevel
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

- (NSString *)recognizedHOCRForPageNumber:(int)pageNumber {
    char *hocr = _tesseract->GetHOCRText(pageNumber);
    if (hocr) {
        NSString *text = [NSString stringWithUTF8String:hocr];
        free(hocr);
        return text;
    }
    
    return nil;
}

- (UIImage *)imageWithBlocks:(NSArray *)blocks drawText:(BOOL)drawText thresholded:(BOOL)thresholded
{
    UIImage *image = thresholded ? self.thresholdedImage : self.image;

    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);

    [image drawInRect:(CGRect){CGPointZero, image.size}];

    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    for (G8RecognizedBlock *block in blocks) {
        CGRect boundingBox = [block boundingBoxAtImageOfSize:image.size];
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
    
    // Draw CGImage to create UIImage
    //      Creating UIImage by [UIImage imageWithCGImage:] worked wrong
    //      and image became broken after some releases.
    CGRect frame = { CGPointZero, CGSizeMake(width, height) };
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, self.image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Context must be mirrored vertical
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, frame, cgImage);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    pixDestroy(&pix);

    return image;
}

- (Pix *)pixForImage:(UIImage *)image
{
    int width = image.size.width;
    int height = image.size.height;

    CGImage *cgImage = image.CGImage;
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);

    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);

    int bpp = MAX(1, (int)bitsPerPixel);
    Pix *pix = pixCreate(width, height, bpp == 24 ? 32 : bpp);
    l_uint32 *data = pixGetData(pix);
    int wpl = pixGetWpl(pix);
    switch (bpp) {
        case 1:
            for (int y = 0; y < height; ++y, data += wpl, pixels += bytesPerRow) {
                for (int x = 0; x < width; ++x) {
                    if (pixels[x / 8] & (0x80 >> (x % 8))) {
                        CLEAR_DATA_BIT(data, x);
                    }
                    else {
                        SET_DATA_BIT(data, x);
                    }
                }
            }
            break;

        case 8:
            // Greyscale just copies the bytes in the right order.
            for (int y = 0; y < height; ++y, data += wpl, pixels += bytesPerRow) {
                for (int x = 0; x < width; ++x) {
                    SET_DATA_BYTE(data, x, pixels[x]);
                }
            }
            break;

        case 24:
            // Put the colors in the correct places in the line buffer.
            for (int y = 0; y < height; ++y, pixels += bytesPerRow) {
                for (int x = 0; x < width; ++x, ++data) {
                    SET_DATA_BYTE(data, COLOR_RED, pixels[3 * x]);
                    SET_DATA_BYTE(data, COLOR_GREEN, pixels[3 * x + 1]);
                    SET_DATA_BYTE(data, COLOR_BLUE, pixels[3 * x + 2]);
                }
            }
            break;

        case 32:
            // Maintain byte order consistency across different endianness.
            for (int y = 0; y < height; ++y, pixels += bytesPerRow, data += wpl) {
                for (int x = 0; x < width; ++x) {
                    data[x] = (pixels[x * 4] << 24) | (pixels[x * 4 + 1] << 16) |
                        (pixels[x * 4 + 2] << 8) | pixels[x * 4 + 3];
                }
            }
            break;
            
        default:
            NSLog(@"Cannot convert image to Pix with bpp = %d", bpp);
    }
    pixSetYRes(pix, (l_int32)self.sourceResolution);
    
    CFRelease(imageData);
    
    return pix;
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
