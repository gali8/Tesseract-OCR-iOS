//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8ViewController.h"
#import <TesseractOCR/TesseractOCR.h>

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
	
	Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
	//language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
	//eng.traineddata is in your "tessdata" folder.
	
	[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
	[tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]]; //image to check
	[tesseract recognize];
	
	NSLog(@"%@", [tesseract recognizedText]);
	
	[tesseract clear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
