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
    
    let(fileManager, ^id{
        return [NSFileManager defaultManager];
    });
    
    let(resourcePath, ^id{
        return [[NSBundle bundleForClass:G8Tesseract.class].resourcePath stringByAppendingString:@"/"];
    });
    
    let(tessdataFolderName, ^id{
        return @"tessdata";
    });
    
    let(tessdataFolderPathFromTheBundle, ^id{
        return [[resourcePath stringByAppendingPathComponent:tessdataFolderName] stringByAppendingString:@"/"];
    });
    
    context(@"nil dataPath", ^{
        
        it(@"", ^{
            [[fileManager shouldNot] receive:@selector(createSymbolicLinkAtPath:withDestinationPath:error:)];
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
            [[tesseract shouldNot] beNil];
            
            [[tesseract.absoluteDataPath should] equal:resourcePath];
        });
    });

    let(cashesPath, ^id{
        NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = cachesPaths.firstObject;
        return cachesPath;
    });
    
    let(tessdataPath, ^id{
        return @"foo/bar";
    });
    
    let(cachesTessDataPath, ^id{
        return [cashesPath stringByAppendingPathComponent:tessdataPath];
    });

    context(@"not nil dataPath", ^{
        
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
        
        let(tessdataFolderName, ^id{
            return @"tessdata";
        });
        
        it(@"no tessdata folder in the Caches yet", ^{
            
            // proof Caches folder is empty
            BOOL folderExists = [fileManager fileExistsAtPath:cachesTessDataPath];
            [[theValue(folderExists) should] equal:theValue(NO)];
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:nil
                                                     cachesRelatedDataPath:tessdataPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            
            [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
            
            [[theValue(doFoldersContainTheSameElements()) should] equal:theValue(YES)];
        });
        
        it(@"tessdata are already in the Caches", ^{
            // helper
            BOOL (^moveTessdataToCachesDirectoryIfNecessary)(NSString *dataPath) = ^(NSString *dataPath){
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                // Useful paths
                NSString *tessdataSourcePath = [resourcePath stringByAppendingPathComponent:tessdataFolderName];
                NSString *destinationPath = [[cashesPath stringByAppendingPathComponent:dataPath] stringByAppendingPathComponent:tessdataFolderName];
                
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

            // copy files to the Caches dir first
            BOOL res = moveTessdataToCachesDirectoryIfNecessary(tessdataPath);
            [[theValue(res) should] equal:theValue(YES)];
            
            [[theValue(doFoldersContainTheSameElements()) should] equal:theValue(YES)];

            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:nil
                                                     cachesRelatedDataPath:tessdataPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            [[tesseract.absoluteDataPath should] equal:cachesTessDataPath];
        });
        
        afterEach(^{
            NSLog(@"Removing previous tessdata folder from Caches folder");
            NSError *error = nil;
            BOOL fileIsRemoved = [fileManager removeItemAtPath:cachesTessDataPath error:&error];
            [[theValue(fileIsRemoved) should] equal:theValue(YES)];
            if (error != nil) {
                NSLog(@"Error deleting tessdata folder from the Caches folder: %@", error);
            }
            
            // check tessdata folder was deleted
            NSArray *cachesContent = [fileManager contentsOfDirectoryAtPath:cashesPath error:&error];
            [[cachesContent shouldNot] contain:tessdataPath];
            if (error != nil) {
                NSLog(@"Error getting the contents of the Caches folder: %@", error);
            }
        });
    });
});

SPEC_END
