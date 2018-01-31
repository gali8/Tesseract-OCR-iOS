
### Step 1 - Prerequisites
First you need to install these tools:

- Xcode 7 with command line tools
- M4
- Autoconf
- Automake
- Libtool

### Step 2 - Build
Run `make` in the `TesseractOCR` subfolder. This first compiles dependent libraries (png, jpeg, tiff, leptonica) and then tesseract for every architecture iOS/simulator uses (arm7 arm7s arm64 i386 x86_64), and then combines the resulting libs into one library file. It does this for both dependent libraries and tesseract, so the final results of the script are "libpng.a", "libjpeg.a", "libtiff.a", "libtesseract.a", "liblept.a", and "include" directories for both leptonica, tesseract and image libraries. Finally, the script copies these results into the "lib" and "include" directories inside `TesseractOCR` directory.

The very first total build (includinf all architectures) may take half an hour or so depending on the processing power, but the later builds will not build dependencies until any files being changed.

By default every "fat" library will contain all architectures specified above. So it can be linked with apps either for devices or simulator. If you don't need all architectures above (for example, for AppStore submittion), just specify the necessary architectures in the `ARCHS` environement variable as follows:

    export ARCHS=armv7, armv7s, arm64
