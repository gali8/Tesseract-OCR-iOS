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
	uint32_t* _pixels;
    ETEXT_DESC *_monitor;
}

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
    if (_pixels != nullptr) {
        free(_pixels);
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
    
    if (_pixels != nullptr) {
        free(_pixels);
        _pixels = nullptr;
    }
	
	CGSize size = [image size];
	int width = size.width;
	int height = size.height;
	
	if (width <= 0 || height <= 0) {
        NSLog(@"WARNING: Image has not size!");
		return;
	}
	
	_pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
	// Clear the pixels so any transparency is preserved
	memset(_pixels, 0, width * height * sizeof(uint32_t));
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// Create a context with RGBA _pixels
	CGContextRef context = CGBitmapContextCreate(_pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
								   kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
	// Paint the bitmap to our context which will fill in the _pixels array
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
	
	// We're done with the context and color space
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	_tesseract->SetImage((const unsigned char *) _pixels, width, height, sizeof(uint32_t), width * sizeof(uint32_t));
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
