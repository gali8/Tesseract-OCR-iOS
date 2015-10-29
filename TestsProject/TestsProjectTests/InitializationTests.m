//
//  InitializationTests.m
//  TestsProjectTests
//
//  Created by ws233 on 29.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <Kiwi/Kiwi.h>
#import "Defaults.h"
#import "G8RecognitionTestsHelper.h"
#import "UIImage+G8Equal.h"

@interface G8Tesseract (Tests)
+ (void)didReceiveMemoryWarningNotification:(NSNotification*)notification;
- (BOOL)configEngine;
- (BOOL)resetEngine;
- (void*)pixForImage:(UIImage *)image;
@end

SPEC_BEGIN(TesseractInitialization)



describe(@"Tesseract initialization", ^{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *resourcePath = [NSBundle mainBundle].resourcePath;
    NSString *customDirectoryPath = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testDirectory"];
    NSString *tessdataFolderName = @"tessdata";
    NSString *tessdataFolderPathFromTheBundle = [[resourcePath stringByAppendingPathComponent:tessdataFolderName] stringByAppendingString:@"/"];
    NSString *debugConfigsFileName = @"debugConfigs.txt";
    NSString *recognitionConfigsFileName = @"recognitionConfigs.txt";
    NSString *tessConfigsFolderName = @"tessconfigs";
    
    // config dictionary and its proving block
    NSDictionary *initOnlyConfigDictionary = @{
                           kG8ParamTessdataManagerDebugLevel  : @"1",
                           kG8ParamLoadSystemDawg             : @"F",
                           kG8ParamLoadFreqDawg               : @"F",
                           kG8ParamUserWordsSuffix            : @"user-words",
                           kG8ParamUserPatternsSuffix         : @"user-patterns",
                           };
    void (^checkVariablesAreSetForTesseract)(G8Tesseract *tesseract) = ^(G8Tesseract *tesseract){
        // these variable could be set up during the initialization
        [[[tesseract variableValueForKey:kG8ParamTessdataManagerDebugLevel] should] equal:@"1"];
        [[[tesseract variableValueForKey:kG8ParamLoadSystemDawg] should] equal:@"0"];
        [[[tesseract variableValueForKey:kG8ParamLoadFreqDawg] should] equal:@"0"];
        [[[tesseract variableValueForKey:kG8ParamUserWordsSuffix] should] equal:@"user-words"];
        [[[tesseract variableValueForKey:kG8ParamUserPatternsSuffix] should] equal:@"user-patterns"];
    };
    
    void (^recognizeSimpleImageWithTesseract)(G8Tesseract *tesseract) = ^(G8Tesseract *tesseract) {
        tesseract.image = [UIImage imageNamed:@"image_sample.jpg"];
        [tesseract recognize];
        
        [[theValue(tesseract.progress) should] equal:theValue(100)];
        
        NSString *recognizedText = tesseract.recognizedText;
        [[recognizedText should] equal:@"1234567890\n\n"];
    };
    
    context(@"Should check common functions", ^{
        
        it(@"Should print version", ^{
            [[[G8Tesseract version] should] equal:@"3.03"];
        });
        
        it(@"Should not raise on cache clearing", ^{
            //
            for (int i = 0; i <= 10; i++) {
                G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:kG8Languages];
                operation.tesseract.image = [UIImage imageNamed:@"well_scaned_page"];
                operation.tesseract.language = kG8Languages;

                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                [queue addOperation:operation];
            }
            
            [[theBlock(^{
                [G8Tesseract clearCache];
            }) shouldNot] raise];
        });
        
        it(@"Should clear cache on memory warning", ^{
            // should be called on a memory warning notification
            [[G8Tesseract should] receive:@selector(didReceiveMemoryWarningNotification:)];
            [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        });
        
        it(@"Should test pixForImage returns nil", ^{
            G8RecognitionTestsHelper *helper = [[G8RecognitionTestsHelper alloc] init];
            [helper setupTesseract];
            helper.customPreprocessingType = G8CustomPreprocessingSimpleThreshold;
            
            G8Tesseract *tesseract = helper.tesseract;
            NSAssert(tesseract, @"Error! tesseract has not been initialized!");
            
            [tesseract stub:@selector(pixForImage:) andReturn:nil];
            tesseract.image = [UIImage imageNamed:@"image_sample.jpg"];
        });
                
        it(@"Should test pixForImage with zero image size", ^{
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
            
            [[tesseract should] receive:@selector(pixForImage:) withCount:0];
            tesseract.image = [[UIImage alloc] init];
            
            [[tesseract.image should] beNil];
        });
        
        it(@"Should call recognizedText before recognize", ^{
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
            NSString *text = tesseract.recognizedText;
            
            [[text should] beNil];
        });
      
        it(@"Should set original image if pixForImage for preprocessed image retuens nil", ^{
            G8RecognitionTestsHelper *helper = [[G8RecognitionTestsHelper alloc] init];
            [helper setupTesseract];
            helper.tesseract.delegate = helper;
            helper.customPreprocessingType = G8CustomPreprocessingSimpleThreshold;
            [helper.tesseract stub:@selector(pixForImage:) andReturn:nil];
          
            UIImage *inputImage = [UIImage imageNamed:@"image_sample.jpg"];
            helper.tesseract.image = inputImage;
          
            [[helper.tesseract.image should] equal:inputImage];
        });
        
        it(@"Should properly set isEngineConfigured property", ^{
            G8Tesseract *tesseract = [[G8Tesseract alloc] init];
            [[theValue(tesseract.isEngineConfigured) should] beYes];
            
            tesseract.language = @"rus";
            [[theValue(tesseract.isEngineConfigured) should] beNo];
            
            tesseract = [[G8Tesseract alloc] initWithLanguage:@"rus"];
            [[tesseract shouldNot] beNil];
            [[theValue(tesseract.isEngineConfigured) should] beNo];
        });
    });

    NSString *tessdataPath = @"foo/bar";
    void (^cleanTessdataFolderAtPath)(NSString *dataPath) = ^(NSString *dataPath) {
        //NSLog(@"Removing previous tessdata folder from Caches folder");
        NSError *error = nil;
        BOOL fileIsRemoved = [fileManager removeItemAtPath:dataPath error:&error];
        if (error != nil) {
            NSLog(@"Error deleting tessdata folder from the folder %@: %@", dataPath, error);
        }
        NSAssert(fileIsRemoved == YES, @"Error cleaning tessdata from the folder: %@", error);
        
        // check tessdata folder was deleted
        NSArray *cachesContent = [fileManager contentsOfDirectoryAtPath:dataPath error:&error];
        if (error != nil) {
            NSLog(@"Error getting the contents of the folder %@: %@", dataPath, error);
        }
        NSAssert([cachesContent containsObject:tessdataPath] == NO, @"Assert! Tessdata path was not removed from the Caches folder");
    };


    // helper
    BOOL (^moveTessdataToFolderIfNecessary)(NSString *dataPath) = ^(NSString *dataPath){
      
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Useful paths
        NSString *tessdataSourcePath = [resourcePath stringByAppendingPathComponent:tessdataFolderName];
        NSString *destinationPath = [dataPath stringByAppendingPathComponent:tessdataFolderName];
        
        if ([fileManager fileExistsAtPath:destinationPath] == NO) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error != nil) {
                NSLog(@"Test: Error creating folder %@: %@", destinationPath, error);
                return NO;
          }
        }
        
        NSError *error = nil;
        NSArray *files = [fileManager contentsOfDirectoryAtPath:tessdataSourcePath error:&error];
        if (error != nil) {
            NSLog(@"Test: ERROR! %@", error.description);
            return NO;
        }
        for (NSString *filename in files) {
          
            NSString *destinationFileName = [destinationPath stringByAppendingPathComponent:filename];
            if (![fileManager fileExistsAtPath:destinationFileName]) {
              
                NSString *sourceFilePath = [tessdataSourcePath stringByAppendingPathComponent:filename];
                //NSLog(@"found %@", filePath);
                //NSLog(@"symlink in %@", destinationFileName);
                
                BOOL res = [fileManager createSymbolicLinkAtPath:destinationFileName
                                             withDestinationPath:sourceFilePath
                                                           error:&error];
                if (res == NO) {
                    NSLog(@"Test: The result of createSymbolicLinkAtPath == NO");
                    return NO;
                }
                if (error != nil) {
                    NSLog(@"Test: Error creating symlink %@: %@", sourceFilePath, error);
                    return NO;
                }
            }
        }
        
        return YES;
    };
    
    it(@"Should initialize without any parameters", ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] init];
        [[tesseract shouldNot] beNil];
        
        recognizeSimpleImageWithTesseract(tesseract);
    });
    
    context(@"initialize with absoluteDataPath", ^{

        it(@"Should initialize simple", ^{
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil absoluteDataPath:nil engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];

            [[tesseract.absoluteDataPath should] equal:resourcePath];

            moveTessdataToFolderIfNecessary(customDirectoryPath);

            BOOL isDirectory = NO;
            NSString *customTessDataPath = [customDirectoryPath stringByAppendingPathComponent:tessdataFolderName];
            [[theValue([fileManager fileExistsAtPath:customTessDataPath isDirectory:&isDirectory]) should] beYes];
            [[theValue(isDirectory) should] beYes];

            tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil absoluteDataPath:customDirectoryPath engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];

            [[tesseract.absoluteDataPath should] equal:customDirectoryPath];

            isDirectory = NO;
            [[theValue([fileManager fileExistsAtPath:customTessDataPath isDirectory:&isDirectory]) should] beYes];
            [[theValue(isDirectory) should] beYes];

            cleanTessdataFolderAtPath(customDirectoryPath);

            tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil absoluteDataPath:customDirectoryPath engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];

            [[tesseract.absoluteDataPath should] equal:customDirectoryPath];

            isDirectory = NO;
            [[theValue([fileManager fileExistsAtPath:[customDirectoryPath stringByAppendingPathComponent:@"tessdata"] isDirectory:&isDirectory]) should] beYes];
            [[theValue(isDirectory) should] beYes];

            cleanTessdataFolderAtPath(customDirectoryPath);
        });
      
        it(@"Should not initialize engine if no tessdata folder in app bundle", ^{
          
            [[NSFileManager defaultManager] stub:@selector(fileExistsAtPath:isDirectory:)
                                       andReturn:theValue(NO)];
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:nil
                                                          absoluteDataPath:customDirectoryPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            [[theValue(tesseract.isEngineConfigured) should] beNo];
        });
    });
    
    context(@"nil cachesRelatedDataPath", ^{
        
        it(@"Should initialize simple", ^{
            [[fileManager shouldNot] receive:@selector(createSymbolicLinkAtPath:withDestinationPath:error:)];
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
            [[tesseract shouldNot] beNil];
            
            [[tesseract.absoluteDataPath should] equal:resourcePath];
            
            tesseract = [G8Tesseract alloc];
            [[tesseract shouldNot] beNil];
            NSAssert([tesseract respondsToSelector:@selector(configEngine)] == YES, @"Error! G8Tesseract instance does not contain configEngine selector");
            [[tesseract should] receive:@selector(configEngine) andReturn:theValue(NO)];
            tesseract = [tesseract initWithLanguage:kG8Languages];
            [[tesseract shouldNot] beNil];
            
            tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
            NSAssert([tesseract respondsToSelector:@selector(resetEngine)] == YES, @"Error! G8Tesseract instance does not contain resetEngine selector");
            [[tesseract should] receive:@selector(configEngine) andReturn:theValue(NO)];
            [[theValue([tesseract resetEngine]) should] beNo];
        });
        
        it(@"Should initialize simple with engine mode", ^{
            [[fileManager shouldNot] receive:@selector(createSymbolicLinkAtPath:withDestinationPath:error:)];
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            
            [[tesseract.absoluteDataPath should] equal:resourcePath];
        });
        
        NSString *debugConfigsFilePathFromTheBundle = [[tessdataFolderPathFromTheBundle stringByAppendingPathComponent:tessConfigsFolderName]  stringByAppendingPathComponent:debugConfigsFileName];
        NSString *recognitionConfigsFilePathFromTheBundle = [[tessdataFolderPathFromTheBundle stringByAppendingPathComponent:tessConfigsFolderName]  stringByAppendingPathComponent:recognitionConfigsFileName];
        
        it(@"Should initialize with config file path", ^{
            [[theBlock(^{
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:nil
                                                               configFileNames:(NSArray*)debugConfigsFilePathFromTheBundle
                                                         cachesRelatedDataPath:nil
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [tesseract recognize];
            }) should] raise];
            
            [[theValue([fileManager fileExistsAtPath:debugConfigsFilePathFromTheBundle]) should] beYes];
            [[theValue([fileManager fileExistsAtPath:recognitionConfigsFilePathFromTheBundle]) should] beYes];
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:@[debugConfigsFilePathFromTheBundle, recognitionConfigsFilePathFromTheBundle]
                                                     cachesRelatedDataPath:nil
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            [[tesseract.absoluteDataPath should] equal:resourcePath];
            
            checkVariablesAreSetForTesseract(tesseract);
        });
        
        it(@"Should initialize with config dictionary", ^{
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:initOnlyConfigDictionary
                                                           configFileNames:nil
                                                     cachesRelatedDataPath:nil
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            [[tesseract.absoluteDataPath should] equal:resourcePath];
            
            checkVariablesAreSetForTesseract(tesseract);
        });
        
        it(@"Should initialize with config dictionary and a file", ^{
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:@{
                                                                             kG8ParamTessdataManagerDebugLevel  : @"1",
                                                                             }
                                                           configFileNames:@[recognitionConfigsFilePathFromTheBundle]
                                                     cachesRelatedDataPath:nil
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            [[tesseract.absoluteDataPath should] equal:resourcePath];
            
            checkVariablesAreSetForTesseract(tesseract);
        });
    });
    
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = cachesPaths.firstObject;
    NSString *cachesTessDataPath = [cachesPath stringByAppendingPathComponent:tessdataPath];
    
    context(@"moveTessdataToCachesDirectoryIfNecessary", ^{
        
        void (^checkInitializationWithFailedSelectorReturnValueAndCount)(SEL selector, id returnValue, NSUInteger count) = ^(SEL selector, id returnValue, NSUInteger count){
            G8Tesseract *wrongTesseract = [G8Tesseract alloc];
            [[wrongTesseract shouldNot] beNil];
            [[[NSFileManager defaultManager] should] receive:selector andReturn:returnValue withCount:count];
            wrongTesseract = [wrongTesseract initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil cachesRelatedDataPath:tessdataPath engineMode:G8OCREngineModeTesseractOnly];
            [[wrongTesseract shouldNot] beNil];
            [[theValue(wrongTesseract.isEngineConfigured) should] beNo];
        };
        
        it(@"Should not initialize engine if createDirectoryAtPath fails", ^{
            checkInitializationWithFailedSelectorReturnValueAndCount(@selector(createDirectoryAtPath:withIntermediateDirectories:attributes:error:), theValue(NO), 1);
        });
        
        it(@"Should not initialize engine if createSymbolicLinkAtPath fails", ^{
            NSError *error = nil;
            NSArray *contentsOfTessdataFromTheBundle = [fileManager contentsOfDirectoryAtPath:tessdataFolderPathFromTheBundle error:&error];
            NSAssert (error == nil, @"Error getting the content of the Tessdata folder from the app bundle: %@", error);

            checkInitializationWithFailedSelectorReturnValueAndCount(@selector(createSymbolicLinkAtPath:withDestinationPath:error:), theValue(NO), contentsOfTessdataFromTheBundle.count);
            cleanTessdataFolderAtPath(cachesTessDataPath);
        });
        
        it(@"Should not initialize engine if contentsOfDirectoryAtPath fails", ^{
            checkInitializationWithFailedSelectorReturnValueAndCount(@selector(contentsOfDirectoryAtPath:error:), nil, 2);
            cleanTessdataFolderAtPath(cachesTessDataPath);
        });
    });
    
    NSDictionary *(^dictionaryForRuntime)() = ^NSDictionary *() {
        return @{
                 kG8ParamTessdataManagerDebugLevel  : @"1",
                 kG8ParamUserWordsSuffix            : @"user-words",
                 };
    };
    
    context(@"not nil cachesRelatedDataPath", ^{
        
        // helper
        BOOL (^doFoldersContainTheSameElements)(void) = ^(void){
            NSError *error = nil;
            NSArray *contentsOfTessdataFromTheBundle = [fileManager contentsOfDirectoryAtPath:tessdataFolderPathFromTheBundle error:&error];
            NSAssert(contentsOfTessdataFromTheBundle.count >= 1, @"Error! Tessdata folder is empty");
            NSAssert(error == nil, @"Error getting the content of the Tessdata folder from the app bundle: %@", error);
            
            NSArray *contentsOfTheTessdataPathFolder = [fileManager contentsOfDirectoryAtPath:[cachesTessDataPath stringByAppendingPathComponent:tessdataFolderName] error:&error];
            [[contentsOfTheTessdataPathFolder should] haveCountOfAtLeast:1];
            if (error != nil) {
                NSLog(@"Error getting the content of the Tessdata folder from the Caches folder: %@", error);
            }
            
            return [contentsOfTheTessdataPathFolder isEqualToArray:contentsOfTessdataFromTheBundle];
        };
        
        NSString *debugConfigsFilePathFromTheCaches = [[[cachesTessDataPath stringByAppendingPathComponent:tessdataFolderName] stringByAppendingPathComponent:tessConfigsFolderName] stringByAppendingPathComponent:debugConfigsFileName];
        NSString *recognitionConfigsFilePathFromTheCaches = [[[cachesTessDataPath stringByAppendingPathComponent:tessdataFolderName] stringByAppendingPathComponent:tessConfigsFolderName] stringByAppendingPathComponent:recognitionConfigsFileName];

        context(@"no tessdata folder in the Caches yet", ^{
            
            void (^moveRusLanguageFilesToTheCachesFolder)() = ^{
                // move rus language files to the folder created on previous steps
                NSString *rusTessdataSourcePath = [[resourcePath stringByAppendingPathComponent:tessdataFolderName] stringByAppendingString:@"-rus"];
                NSString *destinationPath = [[cachesPath stringByAppendingPathComponent:tessdataPath] stringByAppendingPathComponent:tessdataFolderName];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error = nil;
                NSArray *contents = [fileManager contentsOfDirectoryAtPath:rusTessdataSourcePath error:&error];
                for (NSString *filaName in contents) {
                    NSString *rusFileName = [rusTessdataSourcePath stringByAppendingPathComponent:filaName];
                    NSString *destinationFileName = [destinationPath stringByAppendingPathComponent:filaName];
                    if ([fileManager fileExistsAtPath:destinationFileName isDirectory:nil]) {
                        [fileManager removeItemAtPath:destinationFileName error:nil];
                    }
                    
                    BOOL res = [fileManager copyItemAtPath:rusFileName toPath:destinationFileName error:&error];
                    if (error) {
                        NSLog(@"Error copying rus traineddata: %@", error);
                    }
                    assert(res == YES);
                }
            };
            
            G8Tesseract* (^tesseractInitializedWithTessData)() = ^{
                // prove Caches folder is empty
                BOOL folderExists = [fileManager fileExistsAtPath:cachesTessDataPath];
                NSAssert(folderExists == NO, @"Error! Tessdata folder is already here: %@", cachesTessDataPath);
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:nil
                                                               configFileNames:nil
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                NSAssert(doFoldersContainTheSameElements() == YES, @"Error! The tessdata folder in the caches folder contains different elements!");
                
                return tesseract;
            };
            
            it(@"Should simple init, download rus language files and reinitialize tess with them", ^{
                G8Tesseract *tesseract = tesseractInitializedWithTessData();
                
                recognizeSimpleImageWithTesseract(tesseract);
                
                moveRusLanguageFilesToTheCachesFolder();
                
                // initialize with rus now
                G8Tesseract *rusTesseract = [[G8Tesseract alloc] initWithLanguage:@"rus"
                                                                 configDictionary:nil
                                                                  configFileNames:nil
                                                            cachesRelatedDataPath:tessdataPath
                                                                       engineMode:G8OCREngineModeTesseractOnly];
                [[rusTesseract shouldNot] beNil];
                
                [[rusTesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                recognizeSimpleImageWithTesseract(tesseract);
            });
            
            context(@"Reinit with correct language", ^{
                
                it(@"Should set variables from dictionary and reinit correctly", ^{
                    
                    G8Tesseract *tesseract = tesseractInitializedWithTessData();
                    
                    NSString *whitelistString = @"1234567890";
                    NSString *blacklistString = @"aAbBcC";
                    void (^checkVariablesSetOnRuntime)(void) = ^{
                        [[[tesseract variableValueForKey:kG8ParamTessdataManagerDebugLevel] should] equal:@"1"];
                        [[[tesseract variableValueForKey:kG8ParamUserWordsSuffix] shouldNot] equal:@"user-words"];  // initial only, should not be set
                        [[[tesseract variableValueForKey:kG8ParamTesseditCharWhitelist] should] equal:whitelistString];
                        [[[tesseract variableValueForKey:kG8ParamTesseditCharBlacklist] should] equal:blacklistString];
                        
                        [[tesseract.charWhitelist should] equal:whitelistString];
                        [[tesseract.charBlacklist should] equal:blacklistString];
                    };
                    
                    tesseract.charWhitelist = whitelistString;
                    tesseract.charBlacklist = blacklistString;
                    [tesseract setVariablesFromDictionary:dictionaryForRuntime()];
                    checkVariablesSetOnRuntime();
                    
                    moveRusLanguageFilesToTheCachesFolder();
                    // reinit tesseract with different language to check that all the variables are reset after reinitialization
                    tesseract.language = @"rus";
                    checkVariablesSetOnRuntime();
                    
                    recognizeSimpleImageWithTesseract(tesseract);
                    
                    tesseract.engineMode = G8OCREngineModeCubeOnly;
                    checkVariablesSetOnRuntime();
                    
                    // uncomment this to see the error in cube mode with rus locale
                    //recognizeSimpleImageWithTesseract(tesseract);
                });

                it(@"Should restore image, rect, sourceResolution and pageSegmentationMode", ^{
                    
                    UIImage *testImage = [UIImage imageNamed:@"image_sample.jpg"];
                    NSAssert(testImage, @"Error! Test image is nil!");
                    CGRect testRect = CGRectInset(CGRectMake(0, 0, testImage.size.width, testImage.size.height), 10, 10);
                    NSUInteger testSourceResolution = 543;
                    
                    G8Tesseract *tesseract = tesseractInitializedWithTessData();
                    tesseract.image = testImage;
                    tesseract.rect = testRect;
                    tesseract.sourceResolution = testSourceResolution;
                    
                    moveRusLanguageFilesToTheCachesFolder();
                    tesseract.language = @"rus";
                    NSAssert([tesseract.language isEqualToString:@"rus"], @"Caouldn't set russian language file");
                    
                    [[tesseract.image should] equal:testImage];
                    [[theValue(tesseract.rect) should] equal:theValue(testRect)];
                    [[theValue(tesseract.sourceResolution) should] equal:theValue(testSourceResolution)];
                });
            });
            
            it(@"Should initialize with config dictionary", ^{

                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:initOnlyConfigDictionary
                                                               configFileNames:nil
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                checkVariablesAreSetForTesseract(tesseract);
                
                recognizeSimpleImageWithTesseract(tesseract);
            });
            
            it(@"Should initialize config dictionary and a file", ^{
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:@{
                                                                                 kG8ParamTessdataManagerDebugLevel  : @"1",
                                                                                 }
                                                               configFileNames:@[recognitionConfigsFilePathFromTheCaches]
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                checkVariablesAreSetForTesseract(tesseract);
                
                recognizeSimpleImageWithTesseract(tesseract);
            });
            
            it(@"Should initialize with 2 config files", ^{
                
                NSAssert([fileManager attributesOfItemAtPath:debugConfigsFilePathFromTheCaches error:nil] == nil, @"Error! %@ is already here!", debugConfigsFilePathFromTheCaches);
                NSAssert([fileManager attributesOfItemAtPath:recognitionConfigsFilePathFromTheCaches error:nil] == nil, @"Error! %@ cannot is already here!", recognitionConfigsFilePathFromTheCaches);
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:nil
                                                               configFileNames:@[debugConfigsFilePathFromTheCaches, recognitionConfigsFilePathFromTheCaches]
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                checkVariablesAreSetForTesseract(tesseract);
            });
        });
    
        context(@"tessdata are already in the Caches", ^{
          
            beforeEach(^{
                // copy files to the Caches dir first
                BOOL res = moveTessdataToFolderIfNecessary([cachesPath stringByAppendingPathComponent:tessdataPath]);
                NSAssert(res == YES, @"Error copying tessadata from the bundle to the Caches folder");
                
                [[theValue(doFoldersContainTheSameElements()) should] beYes];
            });
            
            it(@"Should initialize with no configs", ^{
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:nil
                                                               configFileNames:nil
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
            });
            

            it(@"Should initialize with config file path", ^{
                
                NSError *error = nil;
                [[[fileManager attributesOfItemAtPath:debugConfigsFilePathFromTheCaches error:&error] shouldNot] beNil];
                if (error) {
                    NSLog(@"Error traversing tessconfigs file: %@", error);
                }
                [[[fileManager attributesOfItemAtPath:recognitionConfigsFilePathFromTheCaches error:&error] shouldNot] beNil];
                if (error) {
                    NSLog(@"Error traversing tessconfigs file: %@", error);
                }
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:nil
                                                               configFileNames:@[debugConfigsFilePathFromTheCaches, recognitionConfigsFilePathFromTheCaches]
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                checkVariablesAreSetForTesseract(tesseract);
            });
            
            it(@"Should initialize with config dictionary", ^{
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:initOnlyConfigDictionary
                                                               configFileNames:nil
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                checkVariablesAreSetForTesseract(tesseract);
            });
            
            it(@"Should initialize with config dictionary and a file", ^{
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:@{
                                                                                 kG8ParamTessdataManagerDebugLevel  : @"1",
                                                                                 }
                                                               configFileNames:@[recognitionConfigsFilePathFromTheCaches]
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                checkVariablesAreSetForTesseract(tesseract);
            });
        });
        
        afterEach(^{
            cleanTessdataFolderAtPath(cachesTessDataPath);
        });
    });
    
    context(@"Reinitialization with wrong language", ^{
        it(@"Should not crach", ^{
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] init];
            
            tesseract.language = @"rus";
            [[tesseract.language should] beNil];
            [[theValue([tesseract recognize]) should] beNo];
            
            // set correct language back and check that no craches happen
            tesseract.language = kG8Languages;
            [[tesseract.language should] equal:kG8Languages];
            [[theBlock(^{
                recognizeSimpleImageWithTesseract(tesseract);
            }) shouldNot] raise];
        });
        
        it(@"Shouldn't crach while setting any parameters, but should cache them", ^{
            
            UIImage *testImage = [UIImage imageNamed:@"image_sample.jpg"];
            NSAssert(testImage, @"Error! Test image is nil!");
            CGRect testRect = CGRectInset(CGRectMake(0, 0, testImage.size.width, testImage.size.height), 10, 10);
            NSUInteger testSourceResolution = 543;
            
            __block G8Tesseract *tesseract = nil;
            [[theBlock(^{
                tesseract = [[G8Tesseract alloc] initWithLanguage:@"rus"];
                [[theValue(tesseract.isEngineConfigured) should] beNo];
                tesseract.image = testImage;
                tesseract.rect = testRect;
                tesseract.sourceResolution = testSourceResolution;
                
                [tesseract recognize];
                [[tesseract.recognizedText should] beNil];
                [[[tesseract recognizedHOCRForPageNumber:1] should] beNil];
                [[[tesseract recognizedPDFForImages:@[testImage, testImage]] should] beNil];
                [[[tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelTextline] should] beNil];
                
                [tesseract analyseLayout];
                
                [[tesseract.characterChoices should] beNil];
                [[tesseract.thresholdedImage should] beNil];
                
                [tesseract setVariablesFromDictionary:dictionaryForRuntime()];
                [[[tesseract variableValueForKey:kG8ParamTessdataManagerDebugLevel] should] equal:@"1"];
                [[[tesseract variableValueForKey:kG8ParamUserWordsSuffix] should] equal:@"user-words"];     // for noninitialized engine this value should be cached
                
            }) shouldNot] raise];
            
            [[tesseract.image should] equal:testImage];
            [[theValue(tesseract.rect) should] equal:theValue(testRect)];
            [[theValue(tesseract.sourceResolution) should] equal:theValue(testSourceResolution)];
        });
    });
});

SPEC_END
