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

@class G8Tesseract;

/**
 *  `G8TesseractDelegate` provides delegate methods for Tesseract recognition.
 */
@protocol G8TesseractDelegate <NSObject>

@optional
/**
 *  An optional method to be called periodically during recognition so
 *  the recognition's progress can be observed.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract;
/**
 *  An optional method to be called periodically during recognition so
 *  the user can choose whether or not to cancel recognition.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 *
 *  @return Whether or not to cancel the recognition in progress.
 */
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract;

@end

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
 *  The language pack to use during recognition. A corresponding trained data
 *  file must exist in the "tessdata" folder of the project. For example, if
 *  you set `language` to "foo", then "foo.traineddata" must exist in the
 *  "tessdata" folder.
 */
@property (nonatomic, copy) NSString* language;

/**
 * The path to the tessdata file, if it was specified in a call to initWithDataPath:language:(NSString engineMode:configFileNames:
 * Otherwise it's supposed that the tessdata folder is located in the application bundle
 */
@property (nonatomic, readonly, copy) NSString *dataPath;

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
 *  limit its recognition.
 */
@property (nonatomic, assign) CGRect rect;

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
 *  An array of `G8RecognizedBlock`'s representing the characters recognized
 *  in the target image, including the bounding boxes for each character. See
 *  G8RecognizedBlock.h for more information about the available fields for 
 *  this data structure.
 */
@property (nonatomic, readonly) NSArray *characterBoxes;

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
 *  Retrieve Tesseract's confidences for its recognition result based on a
 *  provided resolution.
 *
 *  @param pageIteratorLevel A `G8PageIteratorLevel` representing the resolution
 *                           of interest. See G8Constants.h for the available 
 *                           resolution options.
 *
 *  @return An array of `G8RecognizedBlock`'s, each containing a confidence 
 *          value for the text it represents. See G8RecognizedBlock.h for more
 *          information about the available fields for this data structure.
 */
- (NSArray *)confidencesByIteratorLevel:(G8PageIteratorLevel)pageIteratorLevel;

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
 *  @param dataPath
 *  @param language         The language to use in recognition. See `language`.
 *  @param engineMode       The engine mode to use in recognition. See `engineMode`.
 *  @param configFileNames
 *
 *  @return The initialized Tesseract object, or `nil` if there was an error.
 */

- (id)initWithDataPath:(NSString *)dataPath
              language:(NSString *)language
            engineMode:(G8OCREngineMode)engineMode
       configFileNames:(NSArray*)configFileNames NS_DESIGNATED_INITIALIZER;

/**
 *  Set a Tesseract variable. See G8TesseractParameters.h for the available
 *  options.
 *
 *  @param value The value to use for the option.
 *  @param key   The option to set.
 */
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;

/**
 *  Set Tesseract variables using a dictionary. See G8TesseractParameters.h for 
 *  the available options.
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
