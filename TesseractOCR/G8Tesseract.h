//
//  G8Tesseract.h
//  Tesseract OCR iOS
//
//  Created by Loïs Di Qual on 24/09/12.
//  Copyright (c) 2012 Loïs Di Qual.
//  Under MIT License. See 'LICENCE' for more informations.
//

#import <UIKit/UIKit.h>
#import "G8Constants.h"
#import "G8TesseractDelegate.h"

/**
 *  Default value of `sourceResolution` property.
 */
extern NSInteger const kG8DefaultResolution;

/**
 *  Minimum alowed value of `sourceResolution` property.
 */
extern NSInteger const kG8MinCredibleResolution;

/**
 *  Maximum alowed value of `sourceResolution` property.
 */
extern NSInteger const kG8MaxCredibleResolution;

/**
 *  `G8Tesseract` encapsulates the Tesseract library and provides properties
 *  and methods for performing text recognition and analysis on a target image.
 */
@interface G8Tesseract : NSObject

/**
 *  Returns the current version of the underlying Tesseract library.
 *
 *  @return The version string.
 */
+ (NSString *)version;

/**
 *  Clear any library-level memory caches.
 *  There are a variety of expensive-to-load constant data structures (mostly
 *  language dictionaries) that are cached globally. This function allows the
 *  clearing of these caches. It's safe to call this method, while a 
 *  recognition is in progress. It's also called automatically on 
 *  UIApplicationDidReceiveMemoryWarningNotification
 */
+ (void)clearCache;

/**
 *  The language pack to use during recognition. A corresponding trained data
 *  file must exist in the "tessdata" folder of the project. For example, if
 *  you set `language` to "foo", then "foo.traineddata" must exist in the
 *  "tessdata" folder.
 */
@property (nonatomic, copy) NSString* language;

/**
 *  The absolute path to the tessdata folder, which may exist in either the
 *  application bundle or in the Caches directory depending on the argument to
 *  `cachesRelatedDataPath` in the designated initializer.
 */
@property (nonatomic, readonly, copy) NSString *absoluteDataPath;

/**
 *  The recognition mode to use. See `G8OCREngineMode` in G8Constants.h for the
 *  available recognition modes.
 */
@property (nonatomic, assign) G8OCREngineMode engineMode;

/**
 *  The page segmentation mode to use. See `G8PageSegmentationMode` in
 *  G8Constants.h for the available page segmentation modes.
 */
@property (nonatomic, assign) G8PageSegmentationMode pageSegmentationMode;

/**
 *  A white list of characters that Tesseract should recognize. Any
 *  recognition string that Tesseract returns will only contain characters from
 *  the intersection of this string and the characters Tesseract has been
 *  trained on.
 *
 *  @note It has been observed that `charWhitelist` is only respected when
 *        using the `G8OCREngineModeTesseractOnly` mode for `engineMode`.
 */
@property (nonatomic, copy) NSString *charWhitelist;

/**
 *  A black list of characters that Tesseract should not recognize. Any
 *  recognition string that Tesseract returns will not contain characters from
 *  this string.
 *
 *  @note It has been observed that `charBlacklist` is only respected when
 *        using the `G8OCREngineModeTesseractOnly` mode for `engineMode`.
 */
@property (nonatomic, copy) NSString *charBlacklist;

/**
 *  An image on which Tesseract should perform recognition.
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  A rectangle to specify the region of the image on which Tesseract should
 *  limit its recognition. Change it after setting image.
 */
@property (nonatomic, assign) CGRect rect;

/**
 *  The resolution of the source image in pixels per inch so font size
 *  information can be calculated in results. It should be from 70 to
 *  2400 or it will be clamped.
 *
 *  @default Default value is 72
 */
@property (nonatomic, assign) NSInteger sourceResolution;

/**
 *  A time limit (in seconds, via `NSTimeInterval`) to limit Tesseract's time
 *  spent during recognition.
 */
@property (nonatomic, assign) NSTimeInterval maximumRecognitionTime;

/**
 *  The percentage of progress of Tesseract's recognition (between 0 and 100).
 */
@property (nonatomic, readonly) NSUInteger progress;

/**
 *  A string of text that Tesseract has recognized from the target image.
 */
@property (nonatomic, readonly) NSString *recognizedText;

/**
 *  Make an HTML-formatted string with hOCR markup from the internal Tesseract
 *  data structures.
 *  page_number is 0-based but will appear in the output as 1-based.
 *
 *  @param pageNumber The page number within the image of interest. If you
 *                    aren't using a multipage image or don't know what this
 *                    means, use `0` for `pageNumber`.
 *
 *  @return The HTML-formatted string with hOCR markup.
 */
- (NSString *)recognizedHOCRForPageNumber:(int)pageNumber;

/**
 *  Run Tesseract's page analysis on the target image.
 *
 *  @note You must have a file called "osd.traineddata" in the "tessdata"
 *        folder to use this method. You can download this file from:
 *        https://code.google.com/p/tesseract-ocr/downloads/list
 */
- (void)analyseLayout;

/**
 *  The result of Tesseract's orientation analysis of the target image. See
 *  `G8Orientation` in G8Constants.h for the possible orientations.
 *  
 *  @note You must have a file called "osd.traineddata" in the "tessdata"
 *        folder to use this method. You can download this file from:
 *        https://code.google.com/p/tesseract-ocr/downloads/list
 */
@property (nonatomic, readonly) G8Orientation orientation;

/**
 *  The result of Tesseract's writing direction analysis of the target image. 
 *  See `G8WritingDirection` in G8Constants.h for the possible writing 
 *  directions.
 *
 *  @note You must have a file called "osd.traineddata" in the "tessdata"
 *        folder to use this method. You can download this file from:
 *        https://code.google.com/p/tesseract-ocr/downloads/list
 */
@property (nonatomic, readonly) G8WritingDirection writingDirection;

/**
 *  The result of Tesseract's textline order analysis of the target image.
 *  See `G8TextlineOrder` in G8Constants.h for the possible textline orderings.
 *
 *  @note You must have a file called "osd.traineddata" in the "tessdata"
 *        folder to use this method. You can download this file from:
 *        https://code.google.com/p/tesseract-ocr/downloads/list
 */
@property (nonatomic, readonly) G8TextlineOrder textlineOrder;

/**
 *  The result of Tesseract's deskew angle analysis of the target image.
 *  This quantity is the number of radians required to rotate the image
 *  counter-clockwise for the text to be level. The deskew angle will be 
 *  between -Pi/4 and Pi/4.
 *
 *  @note You must have a file called "osd.traineddata" in the "tessdata"
 *        folder to use this method. You can download this file from:
 *        https://code.google.com/p/tesseract-ocr/downloads/list
 */
@property (nonatomic, readonly) CGFloat deskewAngle;

/**
 *  An array of arrays, where each subarray contains `G8RecognizedBlock`'s
 *  representing the choices Tesseract considered for each symbol in the target
 *  image. See G8RecognizedBlock.h for more information about the available
 *  fields for this data structure.
 *
 *  @note It has been observed that this method only works when using the 
 *        `G8OCREngineModeTesseractOnly` mode for `engineMode`.
 */
@property (nonatomic, readonly) NSArray *characterChoices;

/**
 *  Retrieve Tesseract's recognition result based on a provided resolution.
 *  For example, the pageIteratorLevel == G8PageIteratorLevelSymbol returns
 *  an array of `G8RecognizedBlock`'s representing the characters recognized
 *  in the target image, including the bounding boxes for each character.
 *
 *  @param pageIteratorLevel A `G8PageIteratorLevel` representing the resolution
 *                           of interest. See G8Constants.h for the available 
 *                           resolution options.
 *
 *  @return An array of `G8RecognizedBlock`'s, each containing a confidence
 *          value and a bounding box for the text it represents. See 
 *          G8RecognizedBlock.h for more information about the available fields 
 *          for this data structure.
 */
- (NSArray *)recognizedBlocksByIteratorLevel:(G8PageIteratorLevel)pageIteratorLevel;

#pragma mark - Debug methods

/**
 *  The result of Tesseract's internal thresholding on the target image.
 */
@property (nonatomic, readonly) UIImage *thresholdedImage;

/**
 *  Create a copy of the target image with boxes (and optionally labels) drawn 
 *  for each provided recognition block.
 *
 *  @param blocks      An array of `G8RecognizedBlock`'s to draw on the image.
 *  @param drawText    Whether or not to draw text on the image.
 *  @param thresholded Whether or not to use Tesseract's thresholded image.
 *
 *  @return The resulting image.
 */
- (UIImage *)imageWithBlocks:(NSArray *)blocks
                    drawText:(BOOL)drawText
                 thresholded:(BOOL)thresholded;

/**
 *  An optional delegate for Tesseract's recognition.
 */
@property (nonatomic, weak) id<G8TesseractDelegate> delegate;

/// The default initializer should not be used since the language Tesseract
/// uses needs to be explicit.
- (instancetype)init __attribute__((unavailable("Use initWithLanguage:language instead")));

/**
 *  Initialize Tesseract with the provided language.
 *
 *  @param language The language to use in recognition. See `language`.
 *
 *  @return The initialized Tesseract object, or `nil` if there was an error.
 */
- (id)initWithLanguage:(NSString*)language;

/**
 *  Initialize Tesseract with the provided language and engine mode.
 *
 *  @param language   The language to use in recognition. See `language`.
 *  @param engineMode The engine mode to use in recognition. See `engineMode`.
 *
 *  @return The initialized Tesseract object, or `nil` if there was an error.
 */
- (id)initWithLanguage:(NSString*)language
            engineMode:(G8OCREngineMode)engineMode;

/**
 *  Initialize Tesseract with the provided language and engine mode.
 *
 *  @param language             The language to use in recognition. See 
 *                              `language`.
 *  @param configDictionary     A dictionary of config variables to set.
 *  @param configFileNames      An array of file names containing key-value 
 *                              config pairs. Config settings can be set at
 *                              initialization or run-time.  Furthermore, they 
 *                              could be specified at the same time, in which 
 *                              case Tesseract will get variables from every
 *                              config file as well as the dictionary.
 *                              The config files must exist in one of two 
 *                              possible folders:  tessdata/tessconfigs or 
 *                              tessdata/configs.
 *  @param cachesRelatedPath    If the cachesRelatedDataPath is specified, the 
 *                              whole contents of the tessdata folder in the
 *                              application bundle will be copied to 
 *                              Library/Caches/cachesRelatedDataPath/tessdata
 *                              and Tesseract will be set to use that path.
 *  @param engineMode           The engine mode to use in recognition. See 
 *                              `engineMode`.
 *
 *  @return The initialized Tesseract object, or `nil` if there was an error.
 */

- (id)initWithLanguage:(NSString *)language
      configDictionary:(NSDictionary *)configDictionary
       configFileNames:(NSArray *)configFileNames
 cachesRelatedDataPath:(NSString *)cachesRelatedDataPath
            engineMode:(G8OCREngineMode)engineMode;

/**
 *  Initialize Tesseract with the provided language and engine mode.
 *
 *  @param language                 The language to use in recognition. See
 *                                  `language`.
 *  @param configDictionary         A dictionary of config variables to set.
 *  @param configFileNames          An array of file names containing key-value
 *                                  config pairs. Config settings can be set at
 *                                  initialization or run-time.  Furthermore, they
 *                                  could be specified at the same time, in which
 *                                  case Tesseract will get variables from every
 *                                  config file as well as the dictionary.
 *                                  The config files must exist in one of two
 *                                  possible folders:  tessdata/tessconfigs or
 *                                  tessdata/configs.
 *  @param absoluteDataPath         If specified, Tesseract will be initialized to
 *                                  use this path as the path prefix for the
 *                                  tessdata folder. Consequently, you must have a
 *                                  folder named "tessdata" in this path for
 *                                  Tesseract to initialize properly (unless you
 *                                  also set the `copyFilesFromResources` flag to
 *                                  true, in which case the tessdata folder will
 *                                  be created for you in this path). If nil, the
 *                                  application bundle will be used instead as the
 *                                  path prefix for the tessdata folder.
 *  @param engineMode               The engine mode to use in recognition. See
 *                                  `engineMode`.
 *  @param copyFilesFromResources   Flag to determine if Tesseract should copy the
 *                                  whole contents of the tessdata folder in the
 *                                  application bundle to the
 *                                  absoluteDataPath/tessdata directory
 *
 *
 *  @return The initialized Tesseract object, or `nil` if there was an error.
 */
- (id)initWithLanguage:(NSString *)language
      configDictionary:(NSDictionary *)configDictionary
       configFileNames:(NSArray *)configFileNames
      absoluteDataPath:(NSString *)absoluteDataPath
            engineMode:(G8OCREngineMode)engineMode
copyFilesFromResources:(BOOL)copyFilesFromResources NS_DESIGNATED_INITIALIZER;

/**
 *  Set a Tesseract variable. See G8TesseractParameters.h for the available
 *  options.
 *
 *  @param value The value to use for the option.
 *  @param key   The option to set.
 */
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;

/**
 *  Returns a Tesseract variable for the given key. See G8TesseractParameters.h 
 *  for the available options.
 *
 *  @param key  The option to get.
 *
 *  @return     Returns the variable value for the given key, if it's been set. 
 *              nil otherwise.
 */
- (NSString*)variableValueForKey:(NSString *)key;

/**
 *  Set Tesseract variables using a dictionary. See G8TesseractParameters.h for 
 *  the available options. Only runtime variables could be set. To set up 
 *  initial time variables use 
 *  initWithLanguage:configDictionary:configFileNames:cachesRelatedDataPath:engineMode:
 *
 *  @param dictionary The dictionary of key/value pairs to set for Tesseract.
 */
- (void)setVariablesFromDictionary:(NSDictionary *)dictionary;

/**
 *  Execute recognition on the target image.
 *
 *  @return Whether or not the recognition completed successfully.
 */
- (BOOL)recognize;

@end
