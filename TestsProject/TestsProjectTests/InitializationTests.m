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

SPEC_BEGIN(TesseractInitialization)

describe(@"Tesseract initialization", ^{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *resourcePath = [[NSBundle bundleForClass:G8Tesseract.class].resourcePath stringByAppendingString:@"/"];
    NSString *tessdataFolderName = @"tessdata";
    NSString *tessdataFolderPathFromTheBundle = [[resourcePath stringByAppendingPathComponent:tessdataFolderName] stringByAppendingString:@"/"];
    NSString *debugConfigsFileName = @"debugConfigs.txt";
    NSString *recognitionConfigsFileName = @"recognitionConfis.txt";
    NSString *tessConfigsFolderName = @"tessconfigs";
    
    void (^checkVariablesAreSetForTesseract)(G8Tesseract *tesseract) = ^(G8Tesseract *tesseract){
        [[[tesseract variableValueForKey:kG8ParamTessdataManagerDebugLevel] should] equal:@"1"];
        [[[tesseract variableValueForKey:kG8ParamLoadSystemDawg] should] equal:@"0"];
        [[[tesseract variableValueForKey:kG8ParamLoadFreqDawg] should] equal:@"0"];
        [[[tesseract variableValueForKey:kG8ParamUserWordsSuffix] should] equal:@"user-words"];
        [[[tesseract variableValueForKey:kG8ParamUserPatternsSuffix] should] equal:@"user-patterns"];
    };
    
    context(@"nil cachesRelatedDataPath", ^{
        
        it(@"Should initialize simple", ^{
            [[fileManager shouldNot] receive:@selector(createSymbolicLinkAtPath:withDestinationPath:error:)];
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
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
                                                          configDictionary:@{
                                                                             kG8ParamTessdataManagerDebugLevel  : @"1",
                                                                             kG8ParamLoadSystemDawg             : @"F",
                                                                             kG8ParamLoadFreqDawg               : @"F",
                                                                             kG8ParamUserWordsSuffix            : @"user-words",
                                                                             kG8ParamUserPatternsSuffix         : @"user-patterns",
                                                                             }
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

    context(@"not nil cachesRelatedDataPath", ^{
        
        // helper
        BOOL (^doFoldersContainTheSameElements)(void) = ^(void){
            NSError *error = nil;
            NSArray *contentsOfTessdataFromTheBundle = [fileManager contentsOfDirectoryAtPath:tessdataFolderPathFromTheBundle error:&error];
            [[contentsOfTessdataFromTheBundle should] haveCountOfAtLeast:1];
            if (error != nil) {
                NSLog(@"Error getting the content of the Tessdata folder from the app bundle: %@", error);
            }
            
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
            
            it(@"Should simple init", ^{
                // proof Caches folder is empty
                BOOL folderExists = [fileManager fileExistsAtPath:cachesTessDataPath];
                [[theValue(folderExists) should] beNo];
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:nil
                                                               configFileNames:nil
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                [[theValue(doFoldersContainTheSameElements()) should] beYes];
            });
            
            it(@"Should initialize with config dictionary", ^{
                
                G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                              configDictionary:@{
                                                                                 kG8ParamTessdataManagerDebugLevel  : @"1",
                                                                                 kG8ParamLoadSystemDawg             : @"F",
                                                                                 kG8ParamLoadFreqDawg               : @"F",
                                                                                 kG8ParamUserWordsSuffix            : @"user-words",
                                                                                 kG8ParamUserPatternsSuffix         : @"user-patterns",
                                                                                 }
                                                               configFileNames:nil
                                                         cachesRelatedDataPath:tessdataPath
                                                                    engineMode:G8OCREngineModeTesseractOnly];
                [[tesseract shouldNot] beNil];
                [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
                
                checkVariablesAreSetForTesseract(tesseract);
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
            });
        });
        
        it(@"Should initialize with config file path, while there is no tessdata folder yet", ^{
            
            NSLog(@"debugConfigsFilePathFromTheCaches: %@", debugConfigsFilePathFromTheCaches);
            NSLog(@"recognitionConfigsFilePathFromTheCaches: %@", recognitionConfigsFilePathFromTheCaches);
            [[[fileManager attributesOfItemAtPath:debugConfigsFilePathFromTheCaches error:nil] should] beNil];
            [[[fileManager attributesOfItemAtPath:recognitionConfigsFilePathFromTheCaches error:nil] should] beNil];
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:@[debugConfigsFilePathFromTheCaches, recognitionConfigsFilePathFromTheCaches]
                                                     cachesRelatedDataPath:tessdataPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
            
            checkVariablesAreSetForTesseract(tesseract);
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
                                                              configDictionary:@{
                                                                                 kG8ParamTessdataManagerDebugLevel  : @"1",
                                                                                 kG8ParamLoadSystemDawg             : @"F",
                                                                                 kG8ParamLoadFreqDawg               : @"F",
                                                                                 kG8ParamUserWordsSuffix            : @"user-words",
                                                                                 kG8ParamUserPatternsSuffix         : @"user-patterns",
                                                                                 }
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
        });
    });
});

SPEC_END
