//
//  RecognitionTests.m
//  TestsProjectTests
//
//  Created by Nikolay Volosatov on 15.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <Kiwi/Kiwi.h>

#import "UIImage+G8Equal.h"

static NSString *const kG8Languages = @"eng";

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

    context(@"not nil dataPath", ^{
        
        let(tessdataPath, ^id{
            return @"tes";
        });
        
        it(@"no tessdata folder in the Documents yet", ^{
            
            G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:kG8Languages
                                                          configDictionary:nil
                                                           configFileNames:nil
                                                                  dataPath:tessdataPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
            
            NSString *path = [[NSBundle bundleForClass:[G8Tesseract class]].bundlePath stringByAppendingPathComponent:@"tessdata"];
            NSError *error = nil;
            NSArray *contentsOfTessdataFromTheBundle = [fileManager contentsOfDirectoryAtPath:path error:&error];
            [[contentsOfTessdataFromTheBundle should] haveCountOfAtLeast:1];
            if (error != nil) {
                NSLog(@"Error getting the content of the Tessdata folder from the app bundle: %@", error);
            }
            
            NSArray *contentsOfTheTessdataPathFolder = [fileManager contentsOfDirectoryAtPath:[tesseract.dataPath stringByAppendingPathComponent:@"tessdata"] error:&error];
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
                                                                  dataPath:tessdataPath
                                                                engineMode:G8OCREngineModeTesseractOnly];
            [[tesseract shouldNot] beNil];
        });
        
        afterEach(^{
            // make sure Documents folder is empty
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = documentPaths.firstObject;
            
            NSLog(@"Removing previous tessdata folder from Documents");
            NSError *error = nil;
            NSString *path = [documentPath stringByAppendingPathComponent:tessdataPath];
            BOOL fileIsRemoved = [fileManager removeItemAtPath:path error:&error];
            [[theValue(fileIsRemoved) should] equal:theValue(YES)];
            if (error != nil) {
                NSLog(@"Error deleting tessdata folder from the Documents: %@", error);
            }
            
            // check tessdata folder was deleted
            NSArray *documentsContent = [fileManager contentsOfDirectoryAtPath:documentPath error:&error];
            [[documentsContent shouldNot] contain:tessdataPath];
            if (error != nil) {
                NSLog(@"Error getting the contents of the Documents folder: %@", error);
            }
        });
    });
});

SPEC_END
