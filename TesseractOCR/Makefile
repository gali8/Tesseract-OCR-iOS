PNG_NAME    = libpng-1.6.36
JPEG_NAME   = jpeg-9c
TIFF_NAME   = tiff-4.0.10

TESSERACT_SRC = $(shell pwd)/tesseract-ocr
LEPTON_SRC = $(shell pwd)/leptonica
IMG_SRC = $(shell pwd)/libtiff-ios

libtessfiles = libtesseract.a
libleptfiles = liblept.a
libpngfiles = libpng.a
libjpegfiles = libjpeg.a
libtifffiles = libtiff.a

libtessautogen = $(TESSERACT_SRC)/autogen.sh
libtessconfig = $(TESSERACT_SRC)/configure
libleptautogen = $(LEPTON_SRC)/autogen.sh
libleptconfig = $(LEPTON_SRC)/configure

XCODE_DEVELOPER_PATH="`xcode-select -p`"
XCODE_DEVELOPER_PATH_BIN=$(XCODE_DEVELOPER_PATH)/usr/bin
TARGET_CXX="$(XCODE_DEVELOPER_PATH_BIN)/g++"
TARGET_CXX_FOR_BUILD="$(XCODE_DEVELOPER_PATH_BIN)/g++"
TARGET_CC="$(XCODE_DEVELOPER_PATH_BIN)/gcc"

index = $(words $(shell a="$(2)";echo $${a/$(1)*/$(1)} ))
swap  = $(word $(call index,$(1),$(2)),$(3))

# platform specific config
#
# make platform=ios
ifeq ($(platform), ios)
	PLATFORM_PREFIX=ios
	SDK_IPHONEOS_PATH=$(shell xcrun --sdk iphoneos --show-sdk-path)
	SDK_IPHONESIMULATOR_PATH=$(shell xcrun --sdk iphonesimulator --show-sdk-path)
	IOS_DEPLOY_TGT="11.0"

	sdks = $(SDK_IPHONEOS_PATH) $(SDK_IPHONESIMULATOR_PATH)
	platform_version_mins = iphoneos-version-min=$(IOS_DEPLOY_TGT) ios-simulator-version-min=$(IOS_DEPLOY_TGT)
	archs_all = arm64 x86_64
	arch_names_all = arm-apple-darwin64 x86_64-apple-darwin
	arch_names = $(foreach arch, $(ARCHS), $(call swap, $(arch), $(archs_all), $(arch_names_all) ) )
	ARCHS ?= $(archs_all)
# make platform=macos
else ifeq ($(platform), macos)
	PLATFORM_PREFIX=macos
	SDK_MACOS_PATH=$(shell xcrun --sdk macosx --show-sdk-path)
	MACOS_DEPLOY_TGT="10.13"

	sdks = $(SDK_MACOS_PATH)
	platform_version_mins = macosx-version-min=$(MACOS_DEPLOY_TGT)
	archs_all = x86_64
	arch_names_all = x86_64-apple-darwin
	arch_names = $(foreach arch, $(ARCHS), $(call swap, $(arch), $(archs_all), $(arch_names_all) ) )
	ARCHS ?= $(archs_all)
# make platform=all
else ifeq ($(platform), all)
	# we will call make for all platforms, so nothing to do for now
endif


PNG_SRC   = $(IMG_SRC)/$(PNG_NAME)
JPEG_SRC  = $(IMG_SRC)/$(JPEG_NAME)
TIFF_SRC  = $(IMG_SRC)/$(TIFF_NAME)

# TOOD: Rename IMAGE_SRC and maybe IMG_SRC to be more descriptive
IMAGE_SRC = $(IMG_SRC)/$(PLATFORM_PREFIX)

IMAGE_LIB_DIR = $(IMAGE_SRC)/dependencies/lib/
IMAGE_INC_DIR = $(IMAGE_SRC)/dependencies/include
INCLUDE_DIR   = $(shell pwd)/$(PLATFORM_PREFIX)/include
LEPT_INC_DIR  = $(INCLUDE_DIR)
TESS_INC_DIR  = $(INCLUDE_DIR)
LIB_FAT_DIR   = $(shell pwd)/$(PLATFORM_PREFIX)/lib

libleptfolders = $(foreach arch, $(arch_names), $(LEPTON_SRC)/$(PLATFORM_PREFIX)/$(arch)/)
libtessfolders = $(foreach arch, $(arch_names), $(TESSERACT_SRC)/$(PLATFORM_PREFIX)/$(arch)/)
libleptfolders_all = $(foreach arch, $(arch_names_all), $(LEPTON_SRC)/$(PLATFORM_PREFIX)/$(arch)/)
libtessfolders_all = $(foreach arch, $(arch_names_all), $(TESSERACT_SRC)/$(PLATFORM_PREFIX)/$(arch)/)

libleptmakefile = $(foreach folder, $(libleptfolders), $(addprefix $(folder), Makefile) )
libtessmakefile = $(foreach folder, $(libtessfolders), $(addprefix $(folder), Makefile) )
imagesmakefile  = $(addprefix $(IMAGE_SRC)/, Makefile)

libleptfat = $(LIB_FAT_DIR)/$(libleptfiles)
libtessfat = $(LIB_FAT_DIR)/$(libtessfiles)
imagesfat  = $(libpngfat) $(libjpegfat) $(libtifffat)
libpngfat  = $(LIB_FAT_DIR)/$(libpngfiles)
libjpegfat = $(LIB_FAT_DIR)/$(libjpegfiles)
libtifffat = $(LIB_FAT_DIR)/$(libtifffiles)

libtess    = $(foreach folder, $(libtessfolders), $(addprefix $(folder)lib/, $(libtessfiles)) )
liblept    = $(foreach folder, $(libleptfolders), $(addprefix $(folder)lib/, $(libleptfiles)) )
images     = $(libpng) $(libjpeg) $(libtiff)
libpng     = $(addprefix $(IMAGE_LIB_DIR), $(libpngfiles))
libjpeg    = $(addprefix $(IMAGE_LIB_DIR), $(libjpegfiles))
libtiff    = $(addprefix $(IMAGE_LIB_DIR), $(libtifffiles))

dependant_libs = $(libpngfat) $(libjpegfat) $(libtifffat) $(libleptfat) $(libtessfat)

common_cflags = -arch $(call swap, $*, $(arch_names_all), $(archs_all)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -m$(call swap, $*, $(arch_names_all), $(platform_version_mins)) -O2

ifneq (,$(filter $(platform),ios macos))
.PHONY : all
all : $(dependant_libs)
else
.PHONY : all
all :
	$(MAKE) platform=ios
	$(MAKE) platform=macos
endif

#######################
# TESSERACT-OCR
#######################
$(libtessfat) : $(libtess)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libtessfolders_all)) ) -create -output $@
	mkdir -p $(TESS_INC_DIR)
	cp -rvf $(firstword $(libtessfolders))include/tesseract $(TESS_INC_DIR)

$(libtess) : $(libtessmakefile)
	cd $(abspath $(@D)/..) && $(MAKE) -sj8 && $(MAKE) install

$(TESSERACT_SRC)/$(PLATFORM_PREFIX)/%/Makefile : $(libtessconfig) $(libleptfat)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-I$(TESSERACT_SRC)/$(PLATFORM_PREFIX)/$*/ $(common_cflags) -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="-I$(TESSERACT_SRC)/$(PLATFORM_PREFIX)/$*/ $(common_cflags) -Wno-deprecated-register"; \
	export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(LIB_FAT_DIR) -L$(LEPTON_SRC)/$(PLATFORM_PREFIX)/$*/src/.libs" ; \
	export LIBLEPT_HEADERSDIR=$(TESSERACT_SRC)/$(PLATFORM_PREFIX)/$*/ ; \
	export PKG_CONFIG_PATH=$(LEPTON_SRC)/$(PLATFORM_PREFIX)/$*/ ; \
	export CXX="$(TARGET_CXX) --target=$*" ; \
	export CXX_FOR_BUILD="$(TARGET_CXX_FOR_BUILD) --target=$*" ; \
	export CC="$(TARGET_CC) --target=$*" ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	ln -s $(LEPTON_SRC)/src/ leptonica ; \
	../../configure CXX="$(TARGET_CXX) --target=$*" CC="$(TARGET_CC) --target=$*" --host=$* --prefix=`pwd` --enable-shared=no --disable-graphics

$(libtessconfig) : $(libtessautogen)
	cd $(@D) && ./autogen.sh 2> /dev/null

#######################
# LEPTONICA
#######################
$(libleptfat) : $(liblept)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libleptfolders_all)) ) -create -output $@
	mkdir -p $(LEPT_INC_DIR)
	cp -rvf $(firstword $(libleptfolders))include/leptonica $(LEPT_INC_DIR)

$(liblept) : $(libleptmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(LEPTON_SRC)/$(PLATFORM_PREFIX)/%/Makefile : $(imagesfat) $(libleptconfig)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-I$(INCLUDE_DIR) $(common_cflags) -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="-I$(INCLUDE_DIR) $(common_cflags) -Wno-deprecated-register"; \
	export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(LIB_FAT_DIR)" ; \
	export PKG_CONFIG_PATH=$(PNG_SRC)/$*/:$(JPEG_SRC)/$*/:$(TIFF_SRC)/$*/ ; \
	export CXX="$(TARGET_CXX) --target=$*" ; \
	export CXX_FOR_BUILD="$(TARGET_CXX_FOR_BUILD) --target=$*" ; \
	export CC="$(TARGET_CC) --target=$*" ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	../../configure CXX="$(TARGET_CXX) --target=$*" CC="$(TARGET_CC) --target=$*" --host=$* --prefix=`pwd` --enable-shared=no --disable-programs --with-zlib --with-libpng --with-jpeg --without-giflib --with-libtiff

$(libleptconfig) : $(libleptautogen)
	cd $(@D) && ./autogen.sh 2> /dev/null

#######################
# Build libtiff and all of its dependencies
#######################
$(imagesfat) : $(images)
	mkdir -p $(@D)
	cp -rvf $? $(@D)
	mkdir -p $(INCLUDE_DIR)
	cp -rvf $(IMAGE_INC_DIR) $(INCLUDE_DIR)

$(images) : $(imagesmakefile) FORCE
	cd $(IMG_SRC)/ ; \
	until `$(MAKE) -s platform=$(platform)`; do sleep 5; done

#######################
# Download dependencies
#######################
$(imagesmakefile) $(libtessautogen) :
	git submodule init
	git submodule update

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
