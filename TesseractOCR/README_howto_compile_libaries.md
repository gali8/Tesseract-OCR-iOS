# Compiling the .a library files your self


### Step 1 - Prerequisites
First you need to install these tools:

- Xcode 6.1 (6A1052d) with command line tools
- M4
- Autoconf
- Automake
- Libtool


### Step 2 - Download and unzip
Download the source code for `leptonica-1.71` from the Internet here: http://leptonica.org/source/leptonica-1.71.tar.gz.
Unzip it in this folder.


Download the source code for `tesseract-3.03` from the Internet here: https://tesseract-ocr.googlecode.com/archive/3.03-rc1.tar.gz.
Unzip it in this folder.


### Step 3 - Compile
Run `build_dependencies.sh` from the terminal. This first compiles leptonica and then tesseract for every architecture iOS/simulator uses (arm7 arm7s arm64 i386 x86_64), and then combines the resulting libs into one library file. It does this for both leptonica and tesseract, so the final results of the script are "libtesseract_all.a", "liblept.a", and "include" directories for both leptonica and tesseract. Finally, the script copies these results into the "lib" and "include" directories inside this directory.


### Step 4 - Build
Finally, with `Tesseract OCR iOS.xcodeproj` open in Xcode, build the target "TesseractOCRAggregate". This will use the "lib" and "include" directories to create the Tesseract OCR iOS framework.
