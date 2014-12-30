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
    
    context(@"nil dataPath", ^{
        
        it(@"", ^{
            [[fileManager shouldNot] receive:@selector(createSymbolicLinkAtPath:withDestinationPath:error:)];
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages];
            [[tesseract shouldNot] beNil];
        });
    });

    let(cashesPath, ^id{
        NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = cachesPaths.firstObject;
        return cachesPath;
    });

    context(@"not nil dataPath", ^{
        
        let(tessdataPath, ^id{
            return @"tes";
        });
        
        let(tessdataFolderName, ^id{
            return @"tessdata";
        });
        
        let(bundle, ^id{
            return [NSBundle bundleForClass:G8Tesseract.class];
        });
        
        it(@"no tessdata folder in the Documents yet", ^{
            
            // proof Documents folder is empty
            BOOL folderExists = [fileManager fileExistsAtPath:[cashesPath stringByAppendingPathComponent:tessdataFolderName]];
            [[theValue(folderExists) should] equal:theValue(NO)];
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:nil
                                                     cachesRelatedDataPath:tessdataPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            
            NSError *error = nil;
            NSString *path = [[NSBundle bundleForClass:[G8Tesseract class]].bundlePath stringByAppendingPathComponent:@"tessdata"];
            NSArray *contentsOfTessdataFromTheBundle = [fileManager contentsOfDirectoryAtPath:path error:&error];
            [[contentsOfTessdataFromTheBundle should] haveCountOfAtLeast:1];
            if (error != nil) {
                NSLog(@"Error getting the content of the Tessdata folder from the app bundle: %@", error);
            }
            
            NSArray *contentsOfTheTessdataPathFolder = [fileManager contentsOfDirectoryAtPath:[tesseract.absoluteDataPath stringByAppendingPathComponent:@"tessdata"] error:&error];
            [[contentsOfTheTessdataPathFolder should] haveCountOfAtLeast:1];
            if (error != nil) {
                NSLog(@"Error getting the content of the Tessdata folder from the Documents folder: %@", error);
            }
            
            [[contentsOfTessdataFromTheBundle should] containObjectsInArray:contentsOfTheTessdataPathFolder];
        });
        
        it(@"tessdata are already in the Documents", ^{
            // helper
            BOOL (^moveTessdataToDocumentsDirectoryIfNecessary)(NSString *dataPath) = ^(NSString *dataPath){
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                // Useful paths
                NSString *tessdataFolderName = @"tessdata";
                NSString *tessdataDestinationPath = [[NSBundle bundleForClass:G8Tesseract.class].resourcePath
                                                     stringByAppendingPathComponent:tessdataFolderName];
                NSString *destinationPath = [[[NSBundle bundleForClass:G8Tesseract.class].resourcePath
                                              stringByAppendingPathComponent:dataPath]
                                             stringByAppendingPathComponent:tessdataFolderName];
                
                if ([fileManager fileExistsAtPath:destinationPath] == NO) {
                    NSError *error = nil;
                    [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:&error];
                    if (error != nil) {
                        NSLog(@"Test: Error creating folder %@: %@", destinationPath, error);
                        return NO;
                    }
                }
                
                NSError *error = nil;
                NSArray *files = [fileManager contentsOfDirectoryAtPath:tessdataDestinationPath error:&error];
                if (error != nil) {
                    NSLog(@"Test: ERROR! %@", error.description);
                    return NO;
                }
                for (NSString *filename in files) {
                    
                    NSString *destinationFileName = [destinationPath stringByAppendingPathComponent:filename];
                    if ([fileManager fileExistsAtPath:destinationFileName]) {
                        
                        NSString *filePath = [tessdataDestinationPath stringByAppendingPathComponent:filename];
                        //NSLog(@"found %@", filePath);
                        //NSLog(@"symlink in %@", destinationFileName);
                        
                        BOOL res = [fileManager createSymbolicLinkAtPath:destinationFileName
                                                     withDestinationPath:filePath
                                                                   error:&error];
                        if (res == NO) {
                            NSLog(@"Test: The result of createSymbolicLinkAtPath == NO");
                            return NO;
                        }
                        if (error != nil) {
                            NSLog(@"Test: Error creating symlink %@: %@", filePath, error);
                            return NO;
                        }
                    }
                }
                
                return YES;
            };

            // copy files to the Documents dir first
            BOOL res = moveTessdataToDocumentsDirectoryIfNecessary(tessdataPath);
            [[theValue(res) should] equal:theValue(YES)];

            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:nil
                                                     cachesRelatedDataPath:tessdataPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
        });
        
        afterEach(^{
            NSLog(@"Removing previous tessdata folder from Documents");
            NSError *error = nil;
            NSString *path = [cashesPath stringByAppendingPathComponent:tessdataPath];
            BOOL fileIsRemoved = [fileManager removeItemAtPath:path error:&error];
            [[theValue(fileIsRemoved) should] equal:theValue(YES)];
            if (error != nil) {
                NSLog(@"Error deleting tessdata folder from the Documents: %@", error);
            }
            
            // check tessdata folder was deleted
            NSArray *documentsContent = [fileManager contentsOfDirectoryAtPath:cashesPath error:&error];
            [[documentsContent shouldNot] contain:tessdataPath];
            if (error != nil) {
                NSLog(@"Error getting the contents of the Documents folder: %@", error);
            }
        });
    });
});

SPEC_END
