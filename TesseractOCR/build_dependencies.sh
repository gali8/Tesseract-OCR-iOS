#!/bin/sh

# Written by @kevincon, based on @williamsodell's modifications to @gali8's
# original build_dependencies.sh script.

# See README_howto_compile_libaries.md for full instructions.

GLOBAL_OUTDIR="`pwd`/build"
LOCAL_OUTDIR="./outdir"
LEPTON_LIB="`pwd`/leptonica-1.71"
TESSERACT_LIB="`pwd`/tesseract-3.03"

IOS_BASE_SDK="7.0"
IOS_DEPLOY_TGT="7.0"

export CXX=`xcrun -find c++`
export CC=`xcrun -find cc`

export LD=`xcrun -find ld`
export AR=`xcrun -find ar`
export AS=`xcrun -find as`
export NM=`xcrun -find nm`
export RANLIB=`xcrun -find ranlib`

XCODE_DEVELOPER_PATH=/Applications/Xcode.app/Contents/Developer
XCODETOOLCHAIN_PATH=$XCODE_DEVELOPER_PATH/Toolchains/XcodeDefault.xctoolchain
SDK_IPHONEOS_PATH=$(xcrun --sdk iphoneos --show-sdk-path)
SDK_IPHONESIMULATOR_PATH=$(xcrun --sdk iphonesimulator --show-sdk-path)

export PATH="$XCODETOOLCHAIN_PATH/usr/bin:$PATH"

declare -a archs
archs=(arm7 arm7s arm64 i386 x86_64)

declare -a arch_name
arch_names=(arm-apple-darwin7 arm-apple-darwin7s arm-apple-darwin64 i386-apple-darwin x86_64-apple-darwin)

setenv_all() {
# Add internal libs
export CFLAGS="$CFLAGS -I$GLOBAL_OUTDIR/include -L$GLOBAL_OUTDIR/lib -Qunused-arguments"

export LDFLAGS="-L$SDKROOT/usr/lib/"

export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
}

setenv_arm7() {
unset DEVROOT SDKROOT CFLAGS CPP CXXCPP LDFLAGS CPPFLAGS CXXFLAGS

export SDKROOT=$SDK_IPHONEOS_PATH

export CFLAGS="-arch armv7 -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT -I$SDKROOT/usr/include/"

setenv_all
}

setenv_arm7s() {
unset DEVROOT SDKROOT CFLAGS CPP CXXCPP LDFLAGS CPPFLAGS CXXFLAGS

export SDKROOT=$SDK_IPHONEOS_PATH

export CFLAGS="-arch armv7s -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT -I$SDKROOT/usr/include/"

setenv_all
}

setenv_arm64() {
unset DEVROOT SDKROOT CFLAGS CPP CXXCPP LDFLAGS CPPFLAGS CXXFLAGS

export SDKROOT=$SDK_IPHONEOS_PATH

export CFLAGS="-arch arm64 -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT -I$SDKROOT/usr/include/"

setenv_all
}

setenv_i386() {
unset DEVROOT SDKROOT CFLAGS CPP CXXCPP LDFLAGS CPPFLAGS CXXFLAGS

export SDKROOT=$SDK_IPHONESIMULATOR_PATH

export CFLAGS="-arch i386 -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT"

setenv_all
}

setenv_x86_64() {
unset DEVROOT SDKROOT CFLAGS CPP CXXCPP LDFLAGS CPPFLAGS CXXFLAGS

export SDKROOT=$SDK_IPHONESIMULATOR_PATH

export CFLAGS="-arch x86_64 -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT"

setenv_all
}

create_outdir_lipo() {
for file in `find $LOCAL_OUTDIR/i386 -name "lib*.a"`; do
lib_arm7=`echo $file | sed "s/i386/arm7/g"`
lib_arm7s=`echo $file | sed "s/i386/arm7s/g"`
lib_arm64=`echo $file | sed "s/i386/arm64/g"`
lib_x86_64=`echo $file | sed "s/i386/x86_64/g"`
lib_i386=`echo $file`
lib=`echo $file | sed "s/i386//g"`
xcrun -sdk iphoneos lipo -arch armv7s $lib_arm7s -arch armv7 $lib_arm7 -arch arm64 $lib_arm64 -arch i386 $lib_i386 -arch x86_64 $lib_x86_64 -create -output $lib
done
}

merge_libfiles() {
DIR=$1
LIBNAME=$2

cd $DIR
for i in `find . -name "lib*.a"`; do
$AR -x $i
done
$AR -r $LIBNAME *.o
rm -rf *.o __*
cd -
}

#######################
# Start clean
#######################

rm -rf GLOBAL_OUTDIR lib include

#######################
# LEPTONLIB
#######################
cd $LEPTON_LIB
rm -rf $LOCAL_OUTDIR

for n in "${!archs[@]}"
do
mkdir -p "$LOCAL_OUTDIR/${archs[$n]}"
make clean 2> /dev/null
make distclean 2> /dev/null
eval "setenv_${archs[$n]}"
./configure --host="${arch_names[$n]}" --enable-shared=no --disable-programs --without-zlib --without-libpng --without-jpeg --without-giflib --without-libtiff
make -j12
cp -rvf src/.libs/lib*.a "$LOCAL_OUTDIR/${archs[$n]}"
done

create_outdir_lipo
mkdir -p $GLOBAL_OUTDIR/include/leptonica && find ./ -name '*.h' -exec cp {} $GLOBAL_OUTDIR/include/leptonica/  \;
mkdir -p $GLOBAL_OUTDIR/lib && cp -rvf $LOCAL_OUTDIR/lib*.a $GLOBAL_OUTDIR/lib
cd ..


#######################
# TESSERACT-OCR
#######################
cd $TESSERACT_LIB
rm -rf $LOCAL_OUTDIR

for n in "${!archs[@]}"
do
mkdir -p "$LOCAL_OUTDIR/${archs[$n]}"
make clean 2> /dev/null
make distclean 2> /dev/null
eval "setenv_${archs[$n]}"
bash autogen.sh
LIBLEPT_HEADERSDIR=$GLOBAL_OUTDIR/include ./configure --host="${arch_names[$n]}" --enable-shared=no --disable-graphics
make -j12
for i in `find . -name "lib*.a" | grep -v $LOCAL_OUTDIR`; do cp -rvf $i "$LOCAL_OUTDIR/${archs[$n]}"; done
merge_libfiles "$LOCAL_OUTDIR/${archs[$n]}" libtesseract_all.a
done

create_outdir_lipo

mkdir -p $GLOBAL_OUTDIR/include/tesseract && find ./ -name '*.h' -exec cp {} $GLOBAL_OUTDIR/include/tesseract/  \;
mkdir -p $GLOBAL_OUTDIR/lib && cp -rvf $LOCAL_OUTDIR/lib*.a $GLOBAL_OUTDIR/lib
make clean 2> /dev/null
make distclean 2> /dev/null
cd ..

#######################
# Copying
#######################

cp -rf $GLOBAL_OUTDIR/include .
mkdir -p lib
cp -rf $GLOBAL_OUTDIR/lib/libtesseract_all.a $GLOBAL_OUTDIR/lib/liblept.a lib/

echo "Finished!"
