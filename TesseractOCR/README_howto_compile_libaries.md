# Compiling the .a files your self


### Step 1 - Prerequisits
In order to compile you need these tools:
- Xcode 5.0.2 (5A3005)
- M4
- Autoconf
- Automake
- Libtool


### Step 2 - Download and unzip
Download the source code for `leptonica-1.69` from the internet.
Unzip it in this folder.


Download the source code for `tesseract-3.02.02` from the internet.
Unzip it in this folder.


### Step 3 - Compile
Run `build_dependencies.sh` from terminal, this compiles first leptonica and then tesseract.

This creates, after few minutes, a folder named `dependencies`.


### Step 4 - Done
Copy the file `dependencies/lib/liblept.a` and replace `lib/liblept.a`.
Copy the file `dependencies/lib/libtesseract_all.a` and replace `lib/libtesseract_all.a`.
Copy the folder `dependencies/include/leptonica` and replace `include/leptonica`.
Copy the folder `dependencies/include/tesseract` and replace `include/tesseract`.

