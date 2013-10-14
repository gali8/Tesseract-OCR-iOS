Tesseract OCR iOS 1.4 (iOS7 ready)
=================

**Tesseract OCR iOS is a Framework for iOS5+.**

It will help you to use OCR in a iOS project. Easy and fast.

<br/>
Template Framework Project
=================
You can use the "**Template Framework Project**". It's a starting point for use the Tesseract Framework. It's iOS7 ready!

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

ex. from https://github.com/ldiqual/tesseract-ios but using the **"TesseractOCR.framework"**
<pre><code>#import &lt;TesseractOCR/TesseractOCR.h&gt;

Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"<strong>eng</strong>"];
//language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory. 
//eng.traineddata is in your "tessdata" folder.

[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
[tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]]; //image to check
[tesseract recognize];

NSLog(@"%@", [tesseract recognizedText]);
</code></pre>


Set Tesseract variable key to value. See http://www.sk-spell.sk.cx/tesseract-ocr-en-variables for a complete (but not up-to-date) list.

For instance, use tessedit_char_whitelist to restrict characters to a specific set.

<br/>
Updates in this version 
=================
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

Daniele Galiotto www.g8production.com

