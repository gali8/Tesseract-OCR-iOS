Tesseract OCR iOS ![](https://img.shields.io/cocoapods/v/TesseractOCRiOS.svg) ![](https://img.shields.io/cocoapods/l/TesseractOCRiOS.svg) ![](https://img.shields.io/cocoapods/p/TesseractOCRiOS.svg)
=================

**Use Tesseract OCR in iOS 7.0+ projects written in either Objective-C or Swift.
Easy and fast.**

These are the current versions of the upstream bundled libraries within the framework that this repository provides:

* Tesseract 3.03-rc1 ([homepage](https://code.google.com/p/tesseract-ocr/))
* Leptonica 1.71 ([homepage](http://leptonica.org/))

Getting Started
=================

Use the provided template project
------------------------
The "**Template Framework Project**" in this repository provides an example of
how to use Tesseract in your iOS projects. It's iOS7 and arm64 ready!

Integrate the framework into an existing project
------------------------
### Option 1: Using [CocoaPods](http://cocoapods.org) (HIGHLY RECOMMENDED)
#### Stable version
Add the following line to your Podfile then run `pod update`

```
pod 'TesseractOCRiOS', '3.4.0'
```
#### Development version
Add the following line to your Podfile then run `pod update`

```
pod 'TesseractOCRiOS', :git => 'https://github.com/gali8/Tesseract-OCR-iOS.git'
```
** WARNING **: This uses the GitHub repository's master branch as the source
for the library. This is not based off of any stable Tesseract OCR iOS release.

### Option 2: Manual installation

1. Copy the framework file "TesseractOCR.framework" (you can drag and drop it)
    from the **Products** folder in this repo, to your XCode project under the
    **Frameworks** folder.
2. Link against the `libstdc++.6.0.9.dylib` library and the
    `CoreImage.framework` framework (Your target => General => Linked
    Frameworks and Libraries => + => libstdc++.6.0.9 and then
    CoreImage.framework).
3. Go to your project, click on the project and in the Build Settings tab add
    <code>-lstdc++</code> to all the "Other Linker Flags" keys.
4. Go to your project settings, and ensure that C++ Standard Library =>
    Compiler Default. (thanks to [@trein](https://github.com/trein))
5. Copy and import the `tessdata` folder from the **Template Framework
    Project** into the root of your project **AS A REFERENCED FOLDER** (see
    below). It contains the Tesseract trained data files. You can add your own
    trained data files here too.
6. Import the Tesseract header in your classes to start using Tesseract:

    ```#import <TesseractOCR/TesseractOCR.h>```

**NOTE: This library currently requires the tessdata folder to
be linked as a referenced folder instead of a symbolic group**. If Tesseract
can't find a language file in your own project, it's probably because you
created the tessdata folder as a symbolic group instead of a referenced folder.
It should look like this if you did it correctly:

![](https://cloud.githubusercontent.com/assets/817753/4598582/aeba675c-50ba-11e4-8d14-c7af9336b965.png)

Note how the tessdata folder has a blue icon, indicating it was imported as a
referenced folder instead of a symbolic group.

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

### 3.4.0
- Version bump to get past CocoaPods not respecting that 3.1.1 is a newer version than 3.03 (it thinks 3.03 == 3.3), see [#74](https://github.com/gali8/Tesseract-OCR-iOS/issues/74)

### 3.1.1
- Switched to [semantic versioning](http://semver.org/), as required by
    CocoaPods
- Fixed bug that affected support of x86_64 architectures (iOS 5S+ simulators)
- Updated leptonica library from 1.70 to 1.71

### 3.1 (Thanks to [Kevin Conley](https://github.com/kevincon))
- Fixed confidence value issue reported in #56
- Fixed the memory leak reported in #59
- Modified characterBoxes function to return characters in order
- Added some null checks to fix a bug where no text is recognized
- New implementation based off the [API examples for tesseract-ocr](https://code.google.com/p/tesseract-ocr/wiki/APIExample#Result_iterator_example)

### 2.3
- Bug fixes
- CoreImage filters: use `[img blackAndWhite];` to convert a UIImage to
    recognize into a RecognizeImageType
- Rect: use `[tesseract setRect:CGRectMake(20, 20, 100, 100)]` to define a
    rectangle where the text must be located to be recognized

### 2.23
- There is no need to draw an image for Tesseract anymore. Instead it's
    possible just to get raw data from the input image. This is better because
    in the case of a grayscale input image, there is no need to draw it in RGB
    color space, which increases memory consumption significantly.

### 2.22
- Added support for CocoaPods

### 2.21
- tesserackCallbackFunction: leak fixed

### 2.2
- `shouldCancelImageRecognitionForTesseract` works again (thanks to Timo
    Formella)
- Template project updated, now with camera support

### 2.1

- Fixed memory leaks
- Moved all freeing memory job to dealloc (thanks to @frank4565)
- Clear method is deprecated. Set `tesseract = nil;` to free all memory
- Free the utf8Text according to the comment in Tesseract that
    “The recognized text is returned as a char* which is coded as UTF8 and must
    be freed with the delete [] operator.”
- Template Framework Project updated

### 2.0

- 64-bit support
- The
    `- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language`
    method is now deprecated
- Bug fixes
- Removed tessdata folder from the framework project; the tessdata folder
    (in the Template Framework Project) is now linked with the "folder
    references" **REQUIRED!**
- Added delegate TesseractDelegate
- arm64 support (thanks to Cyril)
- Now you can compile the tesseract/leptonica libraries; follow the
    instructions in README_howto_compile_libaries.md (thanks to Simon
    Strangbaard)
- Framework updated
- Bugs fixed (thanks to Simon Strangbaard)
- iOS7 libstdc++ issue solved (using libstdc++.6.0.9)
- **Template Framework Project added.** It's the starting point for using the
    Tesseract Framework. It's **iOS7** ready!
- October 11, 2013: Tesseract is up-to-date with the
    [last version available](https://github.com/ldiqual/tesseract-ios)
- Clear method updated:`[tesseract clear]; //call Clear() end End() functions`
- XCode 5 ready!
- Framework built with the new Xcode 5

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
