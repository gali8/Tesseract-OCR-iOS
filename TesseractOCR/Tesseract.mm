//
//  Tesseract.mm
//  Tesseract
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import "Tesseract.h"

#import "baseapi.h"
#import "environ.h"
#import "pix.h"
#import "ocrclass.h"

namespace tesseract {
	class TessBaseAPI;
};

@interface Tesseract () {
    NSString* _dataPath;
    NSString* _language;
    NSMutableDictionary* _variables;
	tesseract::TessBaseAPI* _tesseract;
	const UInt8 *_pixels;
    ETEXT_DESC *_monitor;
}

@end

@interface Tesseract ()

@property (readwrite, assign) CGSize imageSize;

@end

@implementation Tesseract

+ (NSString *)version {
	return [NSString stringWithFormat:@"%s", tesseract::TessBaseAPI::Version()];
}

- (id)init {
    
    self = [self initWithLanguage:nil];
    if (self) {
    }
    return self;
}

- (id)initWithLanguage:(NSString*)language {
    
    self = [self initPrivateWithDataPath:nil language:language];
    if (self) {
    }
    return self;
}

- (void)dealloc {
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

- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language {
    return [self initPrivateWithDataPath:nil language:language];
}

- (id)initPrivateWithDataPath:(NSString *)dataPath language:(NSString *)language {
    
	self = [super init];
	if (self) {
		_dataPath = dataPath;
		_language = language;
        
        _monitor = new ETEXT_DESC();
        _monitor->cancel = (CANCEL_FUNC)[self methodForSelector:@selector(tesseractCancelCallbackFunction:)];
        _monitor->cancel_this = (__bridge void*)self;
        
		_variables = [[NSMutableDictionary alloc] init];
		
        if (dataPath)
            [self copyDataToDocumentsDirectory];
        else
            [self setUpTesseractToSearchTrainedDataInTrainedDataFolderOfTheApplicatinBundle];
        
		_tesseract = new tesseract::TessBaseAPI();
		
		BOOL success = [self initEngine];
		if (!success)
            self = nil;
	}
	return self;
}

- (void)setUpTesseractToSearchTrainedDataInTrainedDataFolderOfTheApplicatinBundle {
    
    NSString *datapath = [NSString stringWithFormat:@"%@/",
                          [NSString stringWithString:[[NSBundle mainBundle] bundlePath]]
                          ];
    setenv("TESSDATA_PREFIX", datapath.UTF8String, 1);
}

- (BOOL)initEngine {
	int returnCode = _tesseract->Init([_dataPath UTF8String], [_language UTF8String]);
	return (returnCode == 0) ? YES : NO;
}

- (void)copyDataToDocumentsDirectory {
	
	// Useful paths
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
	NSString *dataPath = [documentPath stringByAppendingPathComponent:_dataPath];
	
	//	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"grc" ofType:@"traineddata"];
	//
	NSLog(@"DATAPATH %@", dataPath);
	
	// Copy data in Doc Directory
	if (![fileManager fileExistsAtPath:dataPath])
	{
		[fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    for (NSString *l in [_language componentsSeparatedByString:@"+"]) {
        NSString *tessdataPath = [bundle pathForResource:l ofType:@"traineddata"];
        
        NSString *destinationPath = [dataPath stringByAppendingPathComponent:[tessdataPath lastPathComponent]];
        
        if(![fileManager fileExistsAtPath:destinationPath])
        {
            if (tessdataPath)
            {
                NSError *error = nil;
                NSLog(@"found %@", tessdataPath);
                NSLog(@"coping in %@", destinationPath);
                [fileManager copyItemAtPath:tessdataPath toPath:destinationPath error:&error];
                
                if(error)
                    NSLog(@"ERROR! %@", error.description);
            }
        }
    }
	
	setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
}

- (void)setVariableValue:(NSString *)value forKey:(NSString *)key {
	/*
	 * Example:
	 * _tesseract->SetVariable("tessedit_char_whitelist", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ");
	 * _tesseract->SetVariable("language_model_penalty_non_freq_dict_word", "0");
	 * _tesseract->SetVariable("language_model_penalty_non_dict_word ", "0");
	 */
	
	[_variables setValue:value forKey:key];
	_tesseract->SetVariable([key UTF8String], [value UTF8String]);
}

- (void)loadVariables {
	for (NSString* key in _variables) {
		NSString* value = [_variables objectForKey:key];
		_tesseract->SetVariable([key UTF8String], [value UTF8String]);
	}
}

#pragma mark - Getters and setters

- (void)setLanguage:(NSString *)language {
    
	_language = language;
	BOOL result = [self initEngine];
	
	/*
	 * "WARNING: On changing languages, all Tesseract parameters
	 * are reset back to their default values."
	 */
	if (result)
        [self loadVariables];
}

- (void)setImage:(UIImage *)image {
    
    if (image == nil || image.size.width <= 0 || image.size.height <= 0) {
        NSLog(@"WARNING: Image has not size!");
		return;
	}
    
    self.imageSize = image.size; //self.imageSize used in the characterBoxes method
	int width = self.imageSize.width;
	int height = self.imageSize.height;
    
    CGImage *cgImage = image.CGImage;
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    _pixels = CFDataGetBytePtr(data);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    
    tesseract::ImageThresholder *imageThresholder = new tesseract::ImageThresholder();
    
    assert(bytesPerRow < MAX_INT32);
    {
        imageThresholder->SetImage(_pixels,width,height,(int)(bitsPerPixel/bitsPerComponent),(int)bytesPerRow);
        _tesseract->SetImage(imageThresholder->GetPixRect());
    }
    
    imageThresholder->Clear();
    CFRelease(data);
    delete imageThresholder;
    imageThresholder = nil;
}

- (void)setRect:(CGRect)rect {
    
	_tesseract->SetRectangle(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

- (NSString *)recognizedText {
	char* utf8Text = _tesseract->GetUTF8Text();
	if (!utf8Text) {
		NSLog(@"No recognized text. Check that -[Tesseract setImage:] is passed an image bigger than 0x0.");
		return nil;
	}
    NSString *text = [NSString stringWithUTF8String:utf8Text];
    delete[] utf8Text;
    return text;
}

- (NSDictionary *)characterBoxes {
    NSMutableDictionary *recognizedTextBoxes = [NSMutableDictionary dictionary];
    
    //  Get box info
    char* boxText = _tesseract->GetBoxText(0);
    NSString *stringBoxes = [NSString stringWithUTF8String:boxText];
    delete [] boxText;
    
    NSArray *arrayOfStringBoxes = [stringBoxes componentsSeparatedByString:@"\n"];
    for (NSString *stringBox in arrayOfStringBoxes) {
        //  A stringBox is of the format "c L B R T p"
        //  (L, T) is the top left corner of the box, and (R, B) is the bottom right corner
        //  Tesseract has (0, 0) in the bottom left corner and UIKit has (0, 0) in the top left corner
        //  Need to flip to work with UIKit
        //  c is the recognized character and p is the page it is recognized on
        NSArray *boxComponents = [stringBox componentsSeparatedByString:@" "];
        if (boxComponents.count > 5) {
            CGFloat x = [boxComponents[1] floatValue];
            CGFloat y = self.imageSize.height - [boxComponents[4] floatValue];
            CGFloat width = [boxComponents[3] floatValue] - [boxComponents[1] floatValue];
            CGFloat height = [boxComponents[4] floatValue] - [boxComponents[2] floatValue];
            CGRect box = CGRectMake(x, y, width, height);
            [recognizedTextBoxes setObject:boxComponents[0] forKey:[NSValue valueWithCGRect:box]];
        }
    }
    return recognizedTextBoxes;
}

- (short)progress {
    return _monitor->progress;
}

#pragma mark - Other functions

- (void)clear {
    // Free up all memory in dealloc.
    NSLog(@"clear is deprecated. Free up all memory in dealloc.");
}

- (BOOL)recognize {
    
	int returnCode = _tesseract->Recognize(_monitor);
	return (returnCode == 0) ? YES : NO;
}

- (void)tesseractProgressCallbackFunction:(int)words {
    
    SEL selector = @selector(progressImageRecognitionForTesseract:);
    
    if([self.delegate respondsToSelector:selector])
        [self.delegate progressImageRecognitionForTesseract:self];
}

- (BOOL)tesseractCancelCallbackFunction:(int)words {
    
    if (_monitor->ocr_alive == 1)
        _monitor->ocr_alive = 0;
    
    SEL selector = @selector(shouldCancelImageRecognitionForTesseract:);
    return [self.delegate respondsToSelector:selector] ? [self.delegate shouldCancelImageRecognitionForTesseract:self] : NO;
}

@end
