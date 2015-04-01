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

@interface G8Tesseract (Tests)
+ (void)didReceiveMemoryWarningNotification:(NSNotification*)notification;
- (BOOL)configEngine;
- (BOOL)resetEngine;
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
    });

    NSString *customTessDataPath = [customDirectoryPath stringByAppendingPathComponent:@"tessdata"];
    void(^cleanCustomTessdataFolder)() = ^{
        NSError *error = nil;
        BOOL fileIsRemoved = [fileManager removeItemAtPath:customTessDataPath error:&error];
        if (error != nil) {
            NSLog(@"Error deleting tessdata folder from the custom directory: %@", error);
        }
        NSAssert(fileIsRemoved == YES, @"Error cleaning tessdata from the custom directory");

        // check tessdata folder was deleted
        NSArray *directoryContent = [fileManager contentsOfDirectoryAtPath:customDirectoryPath error:&error];
        if (error != nil) {
            NSLog(@"Error getting the contents of the custom directory: %@", error);
        }
        NSAssert([directoryContent containsObject:customDirectoryPath] == NO, @"Assert! Tessdata path was not removed from the Caches folder");
    };

    BOOL(^copyDataToCustomDirectory)() = ^{
        {
            // Useful paths
            NSString *tessdataFolderName = @"tessdata";
            NSString *tessdataPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:tessdataFolderName];
            NSString *destinationPath = customTessDataPath;
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
    };

    context(@"initialize with absoluteDataPath", ^{

        it(@"Should initialize simple", ^{
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil absoluteDataPath:nil engineMode:G8OCREngineModeTesseractOnly copyFilesFromResources:NO];
            [[tesseract shouldNot] beNil];

            [[tesseract.absoluteDataPath should] equal:resourcePath];

            tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil absoluteDataPath:customDirectoryPath engineMode:G8OCREngineModeTesseractOnly copyFilesFromResources:NO];
            [[tesseract should] beNil];

            BOOL isDirectory = NO;
            [[theValue([fileManager fileExistsAtPath:customTessDataPath isDirectory:&isDirectory]) should] beNo];
            [[theValue(isDirectory) should] beNo];

            copyDataToCustomDirectory();

            isDirectory = NO;
            [[theValue([fileManager fileExistsAtPath:customTessDataPath isDirectory:&isDirectory]) should] beYes];
            [[theValue(isDirectory) should] beYes];

            tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil absoluteDataPath:customDirectoryPath engineMode:G8OCREngineModeTesseractOnly copyFilesFromResources:NO];
            [[tesseract shouldNot] beNil];

            [[tesseract.absoluteDataPath should] equal:customDirectoryPath];

            isDirectory = NO;
            [[theValue([fileManager fileExistsAtPath:customTessDataPath isDirectory:&isDirectory]) should] beYes];
            [[theValue(isDirectory) should] beYes];

            cleanCustomTessdataFolder();

            tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil absoluteDataPath:customDirectoryPath engineMode:G8OCREngineModeTesseractOnly copyFilesFromResources:YES];
            [[tesseract shouldNot] beNil];

            [[tesseract.absoluteDataPath should] equal:customDirectoryPath];

            isDirectory = NO;
            [[theValue([fileManager fileExistsAtPath:[customDirectoryPath stringByAppendingPathComponent:@"tessdata"] isDirectory:&isDirectory]) should] beYes];
            [[theValue(isDirectory) should] beYes];

            cleanCustomTessdataFolder();

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
            
            [[tesseract should] beNil];
            
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
    NSString *tessdataPath = @"foo/bar";
    NSString *cachesTessDataPath = [cachesPath stringByAppendingPathComponent:tessdataPath];
    
    void(^cleanTessdataFolder)() = ^{
        //NSLog(@"Removing previous tessdata folder from Caches folder");
        NSError *error = nil;
        BOOL fileIsRemoved = [fileManager removeItemAtPath:cachesTessDataPath error:&error];
        if (error != nil) {
            NSLog(@"Error deleting tessdata folder from the Caches folder: %@", error);
        }
        NSAssert(fileIsRemoved == YES, @"Error cleaning tessdata from the Caches folder");
        
        // check tessdata folder was deleted
        NSArray *cachesContent = [fileManager contentsOfDirectoryAtPath:cachesPath error:&error];
        if (error != nil) {
            NSLog(@"Error getting the contents of the Caches folder: %@", error);
        }
        NSAssert([cachesContent containsObject:tessdataPath] == NO, @"Assert! Tessdata path was not removed from the Caches folder");
    };
    
    context(@"moveTessdataToCachesDirectoryIfNecessary", ^{
        
        void (^checkInitializationWithFailedSelectorReturnValueAndCount)(SEL selector, id returnValue, NSUInteger count) = ^(SEL selector, id returnValue, NSUInteger count){
            G8Tesseract *wrongTesseract = [G8Tesseract alloc];
            [[wrongTesseract shouldNot] beNil];
            [[[NSFileManager defaultManager] should] receive:selector andReturn:returnValue withCount:count];
            wrongTesseract = [wrongTesseract initWithLanguage:kG8Languages configDictionary:nil configFileNames:nil cachesRelatedDataPath:tessdataPath engineMode:G8OCREngineModeTesseractOnly];
            [[wrongTesseract should] beNil];
        };
        
        it(@"Should return nil if createDirectoryAtPath fails", ^{
            checkInitializationWithFailedSelectorReturnValueAndCount(@selector(createDirectoryAtPath:withIntermediateDirectories:attributes:error:), theValue(NO), 1);
        });
        
        it(@"Should return nil if createSymbolicLinkAtPath fails", ^{
            NSError *error = nil;
            NSArray *contentsOfTessdataFromTheBundle = [fileManager contentsOfDirectoryAtPath:tessdataFolderPathFromTheBundle error:&error];
            NSAssert (error == nil, @"Error getting the content of the Tessdata folder from the app bundle: %@", error);

            checkInitializationWithFailedSelectorReturnValueAndCount(@selector(createSymbolicLinkAtPath:withDestinationPath:error:), theValue(NO), contentsOfTessdataFromTheBundle.count);
            cleanTessdataFolder();
        });
        
        it(@"Should return nil if contentsOfDirectoryAtPath fails", ^{
            checkInitializationWithFailedSelectorReturnValueAndCount(@selector(contentsOfDirectoryAtPath:error:), nil, 2);
            cleanTessdataFolder();
        });
    });
    
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
            
            it(@"Should set variables from dictionary and reinit correctly", ^{
                
                G8Tesseract *tesseract = tesseractInitializedWithTessData();

                NSDictionary *dictionaryForRuntime = @{
                                                       kG8ParamTessdataManagerDebugLevel  : @"1",
                                                       kG8ParamUserWordsSuffix            : @"user-words",
                                                       };
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
                [tesseract setVariablesFromDictionary:dictionaryForRuntime];
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
            
            // helper
            BOOL (^moveTessdataToCachesDirectoryIfNecessary)(NSString *dataPath) = ^(NSString *dataPath){
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                // Useful paths
                NSString *tessdataSourcePath = [resourcePath stringByAppendingPathComponent:tessdataFolderName];
                NSString *destinationPath = [[cachesPath stringByAppendingPathComponent:dataPath] stringByAppendingPathComponent:tessdataFolderName];
                
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

            beforeEach(^{
                // copy files to the Caches dir first
                BOOL res = moveTessdataToCachesDirectoryIfNecessary(tessdataPath);
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
            cleanTessdataFolder();
        });
    });
});

SPEC_END
