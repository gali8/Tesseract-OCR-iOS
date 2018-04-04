LEPTON_NAME = leptonica-1.72
PNG_NAME    = libpng-1.6.20
JPEG_NAME   = jpeg-9a
TIFF_NAME   = tiff-4.0.4

SDK_IPHONEOS_PATH=$(shell xcrun --sdk iphoneos --show-sdk-path)
SDK_IPHONESIMULATOR_PATH=$(shell xcrun --sdk iphonesimulator --show-sdk-path)
XCODE_DEVELOPER_PATH=/Applications/Xcode.app/Contents/Developer
XCODETOOLCHAIN_PATH=$(XCODE_DEVELOPER_PATH)/Toolchains/XcodeDefault.xctoolchain
IOS_DEPLOY_TGT="7.0"

TESSERACT_SRC = $(shell pwd)/tesseract-ocr
LEPTON_SRC = $(shell pwd)/$(LEPTON_NAME)
IMAGE_SRC = $(shell pwd)/libtiff-ios
PNG_SRC   = $(IMAGE_SRC)/$(PNG_NAME)
JPEG_SRC = $(IMAGE_SRC)/$(JPEG_NAME)
TIFF_SRC = $(IMAGE_SRC)/$(TIFF_NAME)

IMAGE_LIB_DIR = $(IMAGE_SRC)/dependencies/lib/
IMAGE_INC_DIR = $(IMAGE_SRC)/dependencies/include/
INCLUDE_DIR   = $(shell pwd)/include
LEPT_INC_DIR  = $(INCLUDE_DIR)
TESS_INC_DIR  = $(INCLUDE_DIR)
LIB_FAT_DIR   = $(shell pwd)/lib

libtessfiles = libtesseract.a
libleptfiles = liblept.a
libpngfiles = libpng.a
libjpegfiles = libjpeg.a
libtifffiles = libtiff.a

sdks = $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONESIMULATOR_PATH) $(SDK_IPHONESIMULATOR_PATH)
archs_all = armv7 armv7s arm64 i386 x86_64
arch_names_all = arm-apple-darwin7 arm-apple-darwin7s arm-apple-darwin64 i386-apple-darwin x86_64-apple-darwin
arch_names = $(foreach arch, $(ARCHS), $(call swap, $(arch), $(archs_all), $(arch_names_all) ) )
ARCHS ?= $(archs_all)

libleptfolders = $(foreach arch, $(arch_names), $(LEPTON_SRC)/$(arch)/)
libtessfolders = $(foreach arch, $(arch_names), $(TESSERACT_SRC)/$(arch)/)
libleptfolders_all = $(foreach arch, $(arch_names_all), $(LEPTON_SRC)/$(arch)/)
libtessfolders_all = $(foreach arch, $(arch_names_all), $(TESSERACT_SRC)/$(arch)/)

libleptmakefile = $(foreach folder, $(libleptfolders), $(addprefix $(folder), Makefile) )
libtessmakefile = $(foreach folder, $(libtessfolders), $(addprefix $(folder), Makefile) )
imagesmakefile  = $(addprefix $(IMAGE_SRC)/, Makefile)

libleptfat = $(LIB_FAT_DIR)/$(libleptfiles)
libtessfat = $(LIB_FAT_DIR)/$(libtessfiles)
imagesfat  = $(libpngfat) $(libjpegfat) $(libtifffat)
libpngfat  = $(LIB_FAT_DIR)/$(libpngfiles)
libjpegfat = $(LIB_FAT_DIR)/$(libjpegfiles)
libtifffat = $(LIB_FAT_DIR)/$(libtifffiles)

libtess    = $(foreach folder, $(libtessfolders), $(addprefix $(folder)/lib/, $(libtessfiles)) )
liblept    = $(foreach folder, $(libleptfolders), $(addprefix $(folder)/lib/, $(libleptfiles)) )
images     = $(libpng) $(libjpeg) $(libtiff)
libpng     = $(addprefix $(IMAGE_LIB_DIR), $(libpngfiles))
libjpeg    = $(addprefix $(IMAGE_LIB_DIR), $(libjpegfiles))
libtiff    = $(addprefix $(IMAGE_LIB_DIR), $(libtifffiles))

libtessautogen = $(TESSERACT_SRC)/autogen.sh
libtessconfig = $(TESSERACT_SRC)/configure
libleptconfig = $(LEPTON_SRC)/configure

index = $(words $(shell a="$(2)";echo $${a/$(1)*/$(1)} ))
swap  = $(word $(call index,$(1),$(2)),$(3))

dependant_libs = $(libtessfat) $(libleptfat) $(libpngfat) $(libjpegfat) $(libtifffat)

common_cflags = -L$(LIB_FAT_DIR) -Qunused-arguments -arch $(call swap, $*, $(arch_names_all), $(archs_all)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2

.PHONY : all
all : $(dependant_libs)

#######################
# TESSERACT-OCR
#######################
$(libtessfat) : $(libtess)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libtessfolders_all)) ) -create -output $@
	mkdir -p $(TESS_INC_DIR)
	cp -rvf $(firstword $(libtessfolders))/include/tesseract $(TESS_INC_DIR)

$(libtess) : $(libtessmakefile)
	cd $(abspath $(@D)/..) && $(MAKE) -sj8 && $(MAKE) install

$(TESSERACT_SRC)/%/Makefile : $(libtessconfig) $(libleptfat)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-I$(TESSERACT_SRC)/$*/ $(common_cflags) -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="-I$(TESSERACT_SRC)/$*/ $(common_cflags) -Wno-deprecated-register"; \
	export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(LEPTON_SRC)/$*/src/.libs" ; \
	export LIBLEPT_HEADERSDIR=$(TESSERACT_SRC)/$*/ ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	ln -s $(LEPTON_SRC)/src/ leptonica ; \
	../configure --host=$* --prefix=`pwd` --enable-shared=no --disable-graphics

$(libtessconfig) : $(libtessautogen)
	cd $(@D) && ./autogen.sh 2> /dev/null

#######################
# LEPTONLIB
#######################
$(libleptfat) : $(liblept)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libleptfolders_all)) ) -create -output $@
	mkdir -p $(LEPT_INC_DIR)
	cp -rvf $(firstword $(libleptfolders))/include/leptonica $(LEPT_INC_DIR)

$(liblept) : $(libleptmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(LEPTON_SRC)/%/Makefile : $(imagesfat) $(libleptconfig)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-I$(INCLUDE_DIR) $(common_cflags) -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="-I$(INCLUDE_DIR) $(common_cflags) -Wno-deprecated-register"; \
    export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(LIB_FAT_DIR)" ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
    ../configure --host=$* --prefix=`pwd` --enable-shared=no --disable-programs --with-zlib --with-libpng --with-jpeg --without-giflib --with-libtiff

#######################
# Build libtiff and all of it's dependencies
#######################
$(imagesfat) : $(images)
	mkdir -p $(@D)
	cp -rvf $? $(@D)
	mkdir -p $(INCLUDE_DIR)
	cp -rvf $(IMAGE_INC_DIR) $(INCLUDE_DIR)

$(images) : $(imagesmakefile) FORCE
	cd $(IMAGE_SRC) ; \
	until `$(MAKE) -s`; do sleep 5; done

#######################
# Download dependencies
#######################
$(imagesmakefile) $(libtessautogen) :
	git submodule init
	git submodule update

$(libleptconfig) :
	curl http://leptonica.org/source/$(LEPTON_NAME).tar.gz | tar -xpf-

#######################
# Clean
#######################
.PHONY : clean
clean : cleanimages cleanlept cleantess

.PHONY : distclean
distclean : distcleanimages distcleanlept distcleantess

.PHONY : mostlyclean
mostlyclean : mostlycleanimages mostlycleanlept mostlycleantess

.PHONY : cleanimages
cleanimages :
	cd $(IMAGE_SRC) ; \
	$(MAKE) clean

.PHONY : cleanlept
cleanlept :
	for folder in $(realpath $(libleptfolders_all) ); do \
        cd $$folder; \
        $(MAKE) clean; \
	done ;

.PHONY : cleantess
cleantess :
	for folder in $(realpath $(libtessfolders_all) ); do \
        cd $$folder; \
        $(MAKE) clean; \
    done ;

.PHONY : mostlycleanimages
mostlycleanimages :

.PHONY : mostlycleanlept
mostlycleanlept :
	for folder in $(realpath $(libleptfolders) ); do \
        cd $$folder; \
        $(MAKE) mostlyclean; \
    done ;

.PHONY : mostlycleantess
mostlycleantess :
	for folder in $(realpath $(libtessfolders_all) ); do \
        cd $$folder; \
        $(MAKE) mostlyclean; \
    done ;

.PHONY : distcleanimages
distcleanimages :
	-rm -rf $(IMAGE_SRC)

PHONY : distcleanlept
distcleanlept :
	-rm -rf $(LEPT_INC_DIR)/leptonica
	-rm -rf $(libleptfat)
	-rm -rf $(LEPTON_SRC)

.PHONY : distcleantess
distcleantess :
	-rm -rf $(TESS_INC_DIR)/tesseract
	-rm -rf $(libtessfat)
	-rm -rf $(TESSERACT_SRC)

.PHONY : FORCE
FORCE :
