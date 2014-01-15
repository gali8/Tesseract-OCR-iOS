Tesseract OCR iOS 1.61 (iOS7 ready & arm64 ready)
=================

**Tesseract OCR iOS is a Framework for iOS5+.**

It will help you to use OCR in iOS projects. Easy and fast.

<br/>
Template Framework Project
=================
You can use the "**Template Framework Project**". It's a starting point for use the Tesseract Framework. It's iOS7 and arm64 ready!

Alternatively you can create a **New Project** like explained below.

New Framework Project
=================

Add the framework "TesseractOCR.framework" (you can drag&drop it) from the **Products** folder in this repo, to your XCode Project under the frameworks folder.

If you are masochist :) you can generate your TesseractOCR.framework building the **TesseractOCRAggregate** target. 

- If you are using **iOS7** or greater, link <code>libstdc++.6.0.9.dylib</code> library (Your target => General => Linked Frameworks and Libraries => + => libstdc++.6.0.9)

- Go to your project, click on the project and in the Build Settings tab add <code>-lstdc++</code> to all the "Other Linker Flags" keys.

- Go to your project settings, and ensure that C++ Standard Library => Compiler Default. (thanks to https://github.com/trein)

- Import the <code>tessdata</code> folder under the root of your project. It contains the "tessdata" files. You can add more tessdata files copyng them here.

- Import the header in your classes writing <code>#import &lt;TesseractOCR/TesseractOCR.h&gt;</code>

Now you can use Tesseract class like explained here: https://github.com/ldiqual/
tesseract-ios

<br/>
How to use
=================

**MyViewController.h**
<pre><code>#import &lt;TesseractOCR/TesseractOCR.h&gt;</code>
<code>@interface MyViewController : UIViewController &lt;TesseractDelegate&gt;</code>
<code>@end</code></pre>
  
<br />
**MyViewController.m**
<pre><code>
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"<strong>eng+ita</strong>"];
	
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
	// Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:nil language:@"<strong>eng+ita</strong>"];
	// or
	// Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"<strong>eng+ita</strong>"];

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


- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}
</code></pre>


Set Tesseract variable key to value. See http://www.sk-spell.sk.cx/tesseract-ocr-en-variables for a complete (but not up-to-date) list.

For instance, use tessedit_char_whitelist to restrict characters to a specific set.

<br/>
Updates in this version 
=================
- Added delegate TesseractDelegate

- arm64 support. Thanks to Cyril

- Now you can compile yours libraries. Follow the README_howto_compile_libaries.md inside. Thanks to Simon Strangbaard

- Framework updated

- Bugs fixed. Thanks to Simon Strangbaard

- iOS7 libstdc++ issue solved (using libstdc++.6.0.9). 

- **Template Framework Project added.** It's the start point for use the Tesseract Framework. It's **iOS7** ready!

- 11 october 2013, tesseract is up to date with last https://github.com/ldiqual/tesseract-ios version available.

- Clear method updated:<pre><code>[tesseract clear]; //call Clear() end End() functions</code></pre>

- XCode 5 ready!

- Framework builded with the new Xcode 5.


<br/>
Dependencies
=================

Tesseract OCR iOS use UIKit, Foundation and CoreFoundation. They are already included in standard iOS Projects.

License
=================

Tesseract OCR iOS and TesseractOCR.framework are under MIT License.

Tesseract-ios, powered by ldiqual https://github.com/ldiqual/tesseract-ios, is under MIT License.

Tesseract, powered by Google http://code.google.com/p/tesseract-ocr/, is under Apache License.

Thanks
=================

Thanks to ldiqual for the good wrapper for Tesseract.

Author Infos
=================

Daniele Galiotto - iOS Freelance Developer - **www.g8production.com**

