Tesseract OCR iOS [![Build Status](https://travis-ci.org/gali8/Tesseract-OCR-iOS.svg?branch=master)](https://travis-ci.org/gali8/Tesseract-OCR-iOS) ![](https://img.shields.io/cocoapods/v/TesseractOCRiOS.svg) ![](https://img.shields.io/cocoapods/l/TesseractOCRiOS.svg) ![](https://img.shields.io/cocoapods/p/TesseractOCRiOS.svg)
=================

**Use Tesseract OCR in iOS 7.0+ projects written in either Objective-C or Swift.
Easy and fast.**

These are the current versions of the upstream bundled libraries within the framework that this repository provides:

* Tesseract 3.03-rc1 ([homepage](https://code.google.com/p/tesseract-ocr/))
* Leptonica 1.71 ([homepage](http://leptonica.org/))

Getting Started
=================
See the [Installation](https://github.com/gali8/Tesseract-OCR-iOS/wiki/Installation) page in the wiki.

Building From Source
=================
You can generate "TesseractOCR.framework" yourself by building the
**TesseractOCRAggregate** target in "Tesseract OCR iOS.xcodeproj".

Example Usage
=======

### Objective-C

**MyViewController.h**

```Objective-C
#import <TesseractOCR/TesseractOCR.h>
@interface MyViewController : UIViewController <TesseractDelegate>
@end
```

**MyViewController.m**

```Objective-C
- (void)viewDidLoad
{
     [super viewDidLoad];

	// Languages are used for recognition (e.g. eng, ita, etc.). Tesseract will
    // search for the .traineddata language file in the tessdata directory. For
    // example, specifying "eng+ita" will search for "eng.traineddata" and
    // "ita.traineddata".

	// Create your Tesseract object using the initWithLanguage method:
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];

	// Set up the delegate to receive Tesseract's callbacks.
	// self should respond to TesseractDelegate and implement a
    // "- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract"
    // method to receive a callback to decide whether or not to interrupt
    // Tesseract before it finishes a recognition.
	tesseract.delegate = self;

    // Optional: Limit the character set Tesseract should try to recognize from
    [tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"];

    // See http://www.sk-spell.sk.cx/tesseract-ocr-en-variables for a complete
    // (but not up-to-date) list of Tesseract variables.

    // Specify the image Tesseract should recognize on
	[tesseract setImage:[[UIImage imageNamed:@"image_sample.jpg"] blackAndWhite]];

    // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
	[tesseract setRect:CGRectMake(20, 20, 100, 100)];

    // Start the recognition
	[tesseract recognize];

    // Retrieve the recognized text
	NSLog(@"%@", [tesseract recognizedText]);
}


- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES if you need to interrupt Tesseract before it finishes
}
```

###Swift
Make sure that you have used an Objective-C bridging header to include the
library. Instructions on configuring a bridging header file can be found in the
[Apple Developer Library](https://developer.apple.com/library/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-XID_77).

**ViewController.swift**

```Swift
import UIKit

class ViewController: UIViewController, TesseractDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        var tesseract:Tesseract = Tesseract();
        tesseract.language = "eng+ita";
        tesseract.delegate = self;
        tesseract.setVariableValue("01234567890", forKey: "tessedit_char_whitelist");
        tesseract.image = UIImage(named: "image_sample.jpg");
        tesseract.recognize();

        NSLog("%@", tesseract.recognizedText);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
}
```

Known Limitations
=================

- No OS X support.
- Strict requirement on language files existing in a referenced "tessdata"
    folder.

Beer
=================
[![](http://media.tumblr.com/3243ca9030c3fa14ca3042344ae3d510/tumblr_inline_ng26w7z8SG1qmlajm.png)](http://g8production.com/Beer)

If you like this work, please buy me a [beer](http://g8production.com/Beer)

Release Notes
=================

### 3.1.1 and greater

See the [Releases](https://github.com/gali8/Tesseract-OCR-iOS/releases) page

### Older releases

See the [Release Notes wiki page](https://github.com/gali8/Tesseract-OCR-iOS/wiki/Release-Notes)



License
=================

Tesseract OCR iOS and TesseractOCR.framework are distributed under the MIT
license (see LICENSE.md).

Tesseract, maintained by Google (http://code.google.com/p/tesseract-ocr/), is
distributed under the Apache 2.0 license (see
http://www.apache.org/licenses/LICENSE-2.0).


Contributors
=================

Daniele Galiotto (founder) - iOS Freelance Developer -
**[www.g8production.com](http://www.g8production.com)**

Kevin Conley - Stanford Graduate Fellow - **[www.kevintechnology.com](http://www.kevintechnology.com)**
