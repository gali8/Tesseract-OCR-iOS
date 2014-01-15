//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8ViewController.h"

@interface G8ViewController ()

@end

@implementation G8ViewController

/****README****/
/*
 tessdata group is linked into the template project, from the main project.
 TesseractOCR.framework is linked into the template project under the Framework group. It's builded by the main project.
 
 If you are using iOS7 or greater, import libstdc++.6.0.9.dylib (not libstdc++)!!!!!
 
 Follow the readme at https://github.com/gali8/Tesseract-OCR-iOS for first step.
 */

 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng+ita"];
    
    // language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
    // eng.traineddata is in your "tessdata" folder.
    // Assumed, that you added a group "tessdata" into your xCode project tree and .traineddata files to it.
    // This actually will not create a "tessdata" folder into your application bundle. Instead, all the files would be located into the root of the bundle.
    // This initializer will copy such 'traineddata' files located in the root folder of the application bundle to 'Documents/traneddata' folder of the application bundle to allow Tesseract to searcj for files into "tessdata".
    // This leads to two copies of the same huge files on user's disk.
    
    // If you'd like to avoid wasting user's disk space, pls, import the whole tessdata folder as a refernce to your project
    // with the ‘Create folder references for any added folders’ options set up in the «Add files to project» dialog
    // (In such case a folder in the xCode project tree will look blue instead of yellow).
    // So use the following initializer instead
    // Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:nil language:@"eng+ita"];
    // or
    // Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];
    
    // set up the delegate to recieve tesseract's callback
    // self should respond to TesseractDelegate and implement shouldCancelImageRecognitionForTesseract: method
    // to have an ability to recieve callback and interrupt Tesseract before it finishes
    
    tesseract.delegate = self;
    
    [tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
    [tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]]; //image to check
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);

    [tesseract clear];
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract {
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
