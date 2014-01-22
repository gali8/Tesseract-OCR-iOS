//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8ViewController.h"

@interface G8ViewController ()
{
    
}
@end

@implementation G8ViewController

/****README****/
/*
 Tessdata folder is into the template project..
 TesseractOCR.framework is linked into the template project under the Framework group. It's builded by the main project.
 
 If you are using iOS7 or greater, import libstdc++.6.0.9.dylib (not libstdc++)!!!!!
 
 Follow the readme at https://github.com/gali8/Tesseract-OCR-iOS for first step.
 */

 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory; eng+ita will search for a eng.traineddata and ita.traineddata.
    
    //Like in the Template Framework Project:
	// Assumed that .traineddata files are in your "tessdata" folder and the folder is in the root of the project.
	// Assumed, that you added a folder references "tessdata" into your xCode project tree, with the ‘Create folder references for any added folders’ options set up in the «Add files to project» dialog.
	// Assumed that any .traineddata files is in the tessdata folder, like in the Template Framework Project

    //Create your tesseract using the initWithLanguage method:
	// Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"<strong>eng+ita</strong>"];
    
    // set up the delegate to recieve tesseract's callback
    // self should respond to TesseractDelegate and implement shouldCancelImageRecognitionForTesseract: method
    // to have an ability to recieve callback and interrupt Tesseract before it finishes
    
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];
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
