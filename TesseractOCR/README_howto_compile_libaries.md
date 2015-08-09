
### Step 1 - Prerequisites
First you need to install these tools:

- Xcode 6.1 (6A1052d) with command line tools
- M4
- Autoconf
- Automake
- Libtool

### Step 2 - Build
With `Tesseract OCR iOS.xcodeproj` open in Xcode, build the target "TesseractOCR". This will run `make` in the TesseractOCR subfolder. This first compiles dependent libraries (png, jpeg, tiff, leptonica) and then tesseract for every architecture iOS/simulator uses (arm7 arm7s arm64 i386 x86_64), and then combines the resulting libs into one library file. It does this for both dependent libraries and tesseract, so the final results of the script are "libpng.a", "libpng16.a", "libjpeg.a", "libtiff.a", "libtiffxx.a", "libtesseract_all.a", "liblept.a", and "include" directories for both leptonica and tesseract. Finally, the script copies these results into the "lib" and "include" directories inside "TesseractOCR" directory.

The very first build may take half an hour or so depending on the processing power, but the later builds will not build dependencies until any files being changed.
