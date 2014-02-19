//
//  G8ViewController.h
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface G8ViewController : UIViewController <TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)openCamera:(id)sender;

@end
