Tesseract OCR iOS 2.21 (iOS7 ready & arm64 ready)
=================

**Tesseract OCR iOS is a Framework for iOS5+.**

It helps you to use OCR in iOS projects, writing Objective-C. Easy and fast.

<br/>
Template Framework Project
=================
You can use the "**Template Framework Project**". It's a starting point for use the Tesseract Framework. It's iOS7 and arm64 ready!

Into the tessdata folder (linked like a referenced folder into the project), there are the .traineddata language files.

Alternatively you can create a **New Project** like explained below.

New Framework Project
=================

Add the framework "TesseractOCR.framework" (you can drag&drop it) from the **Products** folder in this repo, to your XCode Project under the frameworks folder.

If you are masochist :) you can generate your TesseractOCR.framework building the **TesseractOCRAggregate** target. 

- If you are using **iOS7** or greater, link <code>libstdc++.6.0.9.dylib</code> library (Your target => General => Linked Frameworks and Libraries => + => libstdc++.6.0.9)

- Go to your project, click on the project and in the Build Settings tab add <code>-lstdc++</code> to all the "Other Linker Flags" keys.

- Go to your project settings, and ensure that C++ Standard Library => Compiler Default. (thanks to https://github.com/trein)

- Copy and import the <code>tessdata</code> folder from the Template Framework Project under the root of your project. It contains the "tessdata" files. You can add more tessdata files copyng them here.

WARNING: Check the "Create folder references for any added folders" option and the correct target into the "Add to Targets" section.


- Import the header in your classes writing <code>#import &lt;TesseractOCR/TesseractOCR.h&gt;</code>

Now you can use Tesseract class like explained into the "How to use" section:

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

    tesseract = nil; //deallocate and free all memory
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
- 2.21 tesserackCallbackFunction: leak solved on iDevice. 

- The 2.2 is like 2.1... but shouldCancelImageRecognitionForTesseract works again! Thank you to Timo Formella! 

- Template project updated. Now with camera support.

- New release **2.1**

- Fixed memory leaks. Moved all freeing memory job to dealloc. Thanks to frank4565.

- Clear method is deprecated. Set tesseract = nil; to free all memory.

- Free the utf8Text according to the comment in Tesseract that “The recognized text is returned as a char* which is coded as UTF8 and must be freed with the delete [] operator.”.

- Template Framework Project updated.




- New release 2.0 with 64 bit support.

- The - (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language method is now deprecated. 

- Bug fixing!

- Removed tessdata folder from the framework project.

- The tessdata folder (follow the Template Framework Project) is now linked with the "folder references" option into the Template Project. <strong>REQUIRED!!!</strong>

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

Tesseract, powered by Google http://code.google.com/p/tesseract-ocr/, is under Apache License.


Author Infos
=================

Daniele Galiotto - iOS Freelance Developer - **www.g8production.com**

