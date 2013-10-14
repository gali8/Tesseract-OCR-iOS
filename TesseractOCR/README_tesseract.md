Tesseract for iOS
=================


About
-----

Tesseract-ios is an Objective-C wrapper for [Tesseract OCR](http://code.google.com/p/tesseract-ocr/).

This project couldn't exist without the [Ângelo Suzuki's blog post](http://tinsuke.wordpress.com/2011/11/01/how-to-compile-and-use-tesseract-3-01-on-ios-sdk-5/). A lot of code came from his article.


Requirements
------------

 - iOS SDK 6.0, iOS 5.0+ (there is no support for armv6)
 - Tesseract and Leptonica libraries from the [tesseract-ios-lib](https://github.com/ldiqual/tesseract-ios-lib) repo.
 

Installation
------------

 - Download [tesseract-ios-lib](https://github.com/ldiqual/tesseract-ios-lib) and put it somewhere in your project.
 - Put the `Classes` content (from this repo) somewhere in your project.
 - Go to your project settings, and ensure that `C++ Standard Library => Compiler Default`.
 

Usage
-----

Here is the default workflow to extract text from an image:

 - Instantiate Tesseract with data path and language
 - Set variables (character set, …)
 - Set the image to analyze
 - Start recognition
 - Get recognized text
 - Clear
 
 
Code Sample
-----------

    #import "Tesseract.h"
    
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"];
    [tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]];
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);
    [tesseract clear];
 
 
Method reference
----------------

### -initWithDataPath:language: ###

`- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language`

Initialize a new `Tesseract` instance.

 - `dataPath`: a relative path from the application bundle to the `.traineddata` files. You can find these files from [the tesseract downloads section](http://code.google.com/p/tesseract-ocr/downloads/list).
 - `language`: language used for recognition. Ex: `eng`. Tesseract will search for a `eng.traineddata` file in the `dataPath` directory.
 
Returns `nil` if instanciation failed.
 

### -setVariableValue:forKey: ###

`- (void)setVariableValue:(NSString *)value forKey:(NSString *)key`

Set Tesseract variable `key` to `value`. See <http://www.sk-spell.sk.cx/tesseract-ocr-en-variables> for a complete (but not up-to-date) list.

For instance, use `tessedit_char_whitelist` to restrict characters to a specific set.

### -setImage: ###

`- (void)setImage:(UIImage *)image`

Set the image to recognize.

### -setLanguage: ###

`- (BOOL)setLanguage:(NSString *)language`

Override the language defined with `-initWithDataPath:language:`.

### -recognize ###

`- (BOOL)recognize`

Start text recognition. You might want to launch this process in background with `NSObject`'s `-performSelectorInBackground:withObject:`. 

### -recognizedText ###

`- (NSString *)recognizedText`

Get the text extracted from the image.

### -clear ###

`- (void) clear`

Clears Tesseract object after text has been recognized from image. Preventing memory leaks.