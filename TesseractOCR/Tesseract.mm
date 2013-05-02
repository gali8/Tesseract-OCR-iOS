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

namespace tesseract {
    class TessBaseAPI;
};

@interface Tesseract () {
    tesseract::TessBaseAPI* _tesseract;
    uint32_t* _pixels;
}

@end

@implementation Tesseract

+ (NSString *)version {
    return [NSString stringWithFormat:@"%s", tesseract::TessBaseAPI::Version()];
}

- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language {
    self = [super init];
    if (self) {
        _dataPath = dataPath;
        _language = language;
        _variables = [[NSMutableDictionary alloc] init];
        
        [self copyDataToDocumentsDirectory];
        _tesseract = new tesseract::TessBaseAPI();
        
        BOOL success = [self initEngine];
        if (!success) {
            return NO;
        }
    }
    return self;
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
    
    // Copy data in Doc Directory
    if (![fileManager fileExistsAtPath:dataPath]) {
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:_dataPath];
        if (tessdataPath) {
            [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:NULL];
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:nil];
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

- (BOOL)setLanguage:(NSString *)language {
    _language = language;
    int returnCode = [self initEngine];
    if (returnCode != 0) return NO;
    
    /*
     * "WARNING: On changing languages, all Tesseract parameters
     * are reset back to their default values."
     */
    [self loadVariables];
    return YES;
}

- (BOOL)recognize {
    int returnCode = _tesseract->Recognize(NULL);
    return (returnCode == 0) ? YES : NO;
}

- (NSString *)recognizedText {
    char* utf8Text = _tesseract->GetUTF8Text();
    return [NSString stringWithUTF8String:utf8Text];
}

- (void)setImage:(UIImage *)image
{
    free(_pixels);
    
    CGSize size = [image size];
    int width = size.width;
    int height = size.height;
	
	if (width <= 0 || height <= 0) {
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

@end
