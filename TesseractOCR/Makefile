LEPTON_NAME = leptonica-1.72
PNG_NAME    = libpng-1.6.18
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

IMAGE_LIB_DIR = $(shell pwd)/lib/
IMAGE_INC_DIR = $(shell pwd)/include/
LEPT_INC_DIR  = $(shell pwd)/include
TESS_INC_DIR  = $(shell pwd)/include
LIB_FAT_DIR   = $(shell pwd)/lib

libtessallfiles = libtesseract_all.a
libtessfiles = ccmain/.libs/libtesseract_main.a ccstruct/.libs/libtesseract_ccstruct.a \
                ccutil/.libs/libtesseract_ccutil.a classify/.libs/libtesseract_classify.a cube/.libs/libtesseract_cube.a cutil/.libs/libtesseract_cutil.a \
                dict/.libs/libtesseract_dict.a neural_networks/runtime/.libs/libtesseract_neural.a opencl/.libs/libtesseract_opencl.a \
                textord/.libs/libtesseract_textord.a viewer/.libs/libtesseract_viewer.a wordrec/.libs/libtesseract_wordrec.a \
				api/.libs/libtesseract.a api/.libs/libtesseract_api.a
libleptfiles = liblept.a
libpngfiles = libpng.a
libjpegfiles = libjpeg.a
libtifffiles = libtiff.a

sdks = $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONESIMULATOR_PATH) $(SDK_IPHONESIMULATOR_PATH)
archs = armv7 armv7s arm64 i386 x86_64
arch_names = arm-apple-darwin7 arm-apple-darwin7s arm-apple-darwin64 i386-apple-darwin x86_64-apple-darwin

libleptfolders = $(foreach arch, $(arch_names), $(LEPTON_SRC)/$(arch)/)
libtessfolders = $(foreach arch, $(arch_names), $(TESSERACT_SRC)/$(arch)/)
libpngfolders  = $(foreach arch, $(arch_names), $(PNG_SRC)/$(arch)/)
libjpegfolders = $(foreach arch, $(arch_names), $(JPEG_SRC)/$(arch)/)
libtifffolders = $(foreach arch, $(arch_names), $(TIFF_SRC)/$(arch)/)

libleptmakefile = $(foreach folder, $(libleptfolders), $(addprefix $(folder), Makefile) )
libtessmakefile = $(foreach folder, $(libtessfolders), $(addprefix $(folder), Makefile) )
libpngmakefile  = $(foreach folder, $(libpngfolders), $(addprefix $(folder), Makefile) )
libjpegmakefile = $(foreach folder, $(libjpegfolders), $(addprefix $(folder), Makefile) )
libtiffmakefile = $(foreach folder, $(libtifffolders), $(addprefix $(folder), Makefile) )

libleptfat = $(LIB_FAT_DIR)/$(libleptfiles)
libtessfat = $(LIB_FAT_DIR)/$(libtessallfiles)
libpngfat  = $(addprefix $(IMAGE_LIB_DIR), $(libpngfiles))
libjpegfat = $(addprefix $(IMAGE_LIB_DIR), $(libjpegfiles))
libtifffat = $(addprefix $(IMAGE_LIB_DIR), $(libtifffiles))

libtessall = $(foreach folder, $(libtessfolders), $(addprefix $(folder), $(libtessallfiles)) )
libtess    = $(foreach folder, $(libtessfolders), $(addprefix $(folder), $(libtessfiles)) )
liblept    = $(foreach folder, $(addsuffix src/.libs/, $(libleptfolders) ), $(addprefix $(folder), $(libleptfiles)) )
libpng     = $(foreach folder, $(libpngfolders), $(addprefix $(folder)/lib/, $(libpngfiles)) )
libjpeg    = $(foreach folder, $(libjpegfolders), $(addprefix $(folder)/lib/, $(libjpegfiles)) )
libtiff    = $(foreach folder, $(libtifffolders), $(addprefix $(folder)/lib/, $(libtifffiles)) )

libtessautogen = $(TESSERACT_SRC)/autogen.sh
libtessconfig = $(TESSERACT_SRC)/configure
libleptconfig = $(LEPTON_SRC)/configure
libpngconfig  = $(PNG_SRC)/configure
libjpegconfig = $(JPEG_SRC)/configure
libtiffconfig = $(TIFF_SRC)/configure

index = $(words $(shell a="$(2)";echo $${a/$(1)*/$(1)} ))
swap  = $(word $(call index,$(1),$(2)),$(3))

dependant_libs = $(libtessfat) $(libleptfat) $(libpngfat) $(libjpegfat) $(libtifffat)

.PHONY : all
all : $(dependant_libs)

#######################
# TESSERACT-OCR
#######################
$(libtessfat) : $(libtessall)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $^ -create -output $@
	mkdir -p $(TESS_INC_DIR)
	cp -rvf $(firstword $(libtessfolders))/include/tesseract $(TESS_INC_DIR)

$(libtessall) : $(libtess)
	cd $(@D) ; \
	xcrun libtool -static -o $@ `find . -name "lib*.a"` -no_warning_for_no_symbols

$(libtess) : $(liblept) $(libtessmakefile)
	echo $(libtessmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(TESSERACT_SRC)/%/Makefile : $(libtessconfig)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names), $(sdks))" ; \
	export CFLAGS="-I$(TESSERACT_SRC)/$*/ -L$(IMAGE_LIB_DIR) -Qunused-arguments -arch $(call swap, $*, $(arch_names), $(archs)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
	export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(LEPTON_SRC)/$*/src/.libs" ; \
	export LIBLEPT_HEADERSDIR=$(TESSERACT_SRC)/$*/ ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	ln -s $(LEPTON_SRC)/src/ leptonica ; \
	../configure --host=$* --prefix=`pwd` --enable-shared=no --disable-graphics

$(libtessconfig) : $(libtessautogen)
	cd $(@D) ; \
	./autogen.sh

#######################
# LEPTONLIB
#######################
$(libleptfat) : $(liblept)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $^ -create -output $@
	mkdir -p $(LEPT_INC_DIR)
	cp -rvf $(firstword $(libleptfolders))/include/leptonica $(LEPT_INC_DIR)

$(liblept) : $(libleptmakefile)
	cd $(abspath $(@D)/../..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(LEPTON_SRC)/%/Makefile : $(libjpegfat) $(libpngfat) $(libtifffat) $(libleptconfig)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names), $(sdks))" ; \
	export CFLAGS="-I$(IMAGE_INC_DIR) -L$(IMAGE_LIB_DIR) -Qunused-arguments -arch $(call swap, $*, $(arch_names), $(archs)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
    export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(IMAGE_LIB_DIR)" ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
    ../configure --host=$* --prefix=`pwd` --enable-shared=no --disable-programs --with-zlib --with-libpng --with-jpeg --without-giflib --with-libtiff

#######################
# Build libtiff and all of it's dependencies
#######################
$(libtifffat) : $(libtiff)
	mkdir -p $(@D)
	xcrun lipo $(addsuffix lib/$(@F), $(libtifffolders)) -create -output $@
	mkdir -p $(IMAGE_INC_DIR)
	cp -rvf $(firstword $(libtifffolders))/include/*.h $(IMAGE_INC_DIR)

$(libtiff) :  $(libtiffmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(TIFF_SRC)/%/Makefile : $(libtiffconfig)
	export SDKROOT="$(call swap, $*, $(arch_names), $(sdks))" ; \
	export CFLAGS="-Qunused-arguments -arch $(call swap, $*, $(arch_names), $(archs)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	../configure --host=$* --enable-fast-install --enable-shared=no --prefix=`pwd` --without-x --with-jpeg-include-dir=$(abspath $(@D)/../../$(JPEG_NAME)/$*/include) --with-jpeg-lib-dir=$(abspath $(@D)/../../$(JPEG_NAME)/$*/lib)

$(libpngfat) : $(libpng)
	mkdir -p $(@D)
	xcrun lipo $(addsuffix lib/$(@F), $(libpngfolders)) -create -output $@
	mkdir -p $(IMAGE_INC_DIR)
	cp -rvf $(firstword $(libpngfolders))/include/*.h $(IMAGE_INC_DIR)

$(libpng) : $(libpngmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(PNG_SRC)/%/Makefile : $(libpngconfig)
	export SDKROOT="$(call swap, $*, $(arch_names), $(sdks))" ; \
	export CFLAGS="-Qunused-arguments -arch $(call swap, $*, $(arch_names), $(archs)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
    ../configure --host=$* --enable-shared=no --prefix=`pwd`

$(libjpegfat) : $(libjpeg)
	mkdir -p $(@D)
	xcrun lipo $(addsuffix lib/$(@F), $(libjpegfolders)) -create -output $@
	mkdir -p $(IMAGE_INC_DIR)
	cp -rvf $(firstword $(libjpegfolders))/include/*.h $(IMAGE_INC_DIR)

$(libjpeg) : $(libjpegmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(JPEG_SRC)/%/Makefile : $(libjpegconfig)
	export SDKROOT="$(call swap, $*, $(arch_names), $(sdks))" ; \
	export CFLAGS="-Qunused-arguments -arch $(call swap, $*, $(arch_names), $(archs)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	../configure --host=$* --enable-shared=no --prefix=`pwd`

#######################
# Download dependencies
#######################
$(libtiffconfig) $(libpngconfig) $(libjpegconfig) $(libtessautogen) :
	git submodule init
	git submodule update

$(libleptconfig) :
	curl http://leptonica.org/source/$(LEPTON_NAME).tar.gz | tar -xpf-

#######################
# Clean
#######################
.PHONY : clean
clean : cleanimage cleanlept cleantess

.PHONY : distclean
distclean : distcleanimage distcleanlept distcleantess

.PHONY : mostlyclean
mostlyclean : mostlycleanimage mostlycleanlept mostlycleantess

cleanimage :

.PHONY : cleanlept
cleanlept :
	for folder in $(libleptfolders); do \
		cd $$folder; \
		$(MAKE) clean; \
	done ; \

.PHONY : cleantess
cleantess :
	for folder in $(libtessfolders); do \
		cd $$folder; \
		$(MAKE) clean; \
    done ; \

mostlycleanimage :

.PHONY : mostlycleanlept
mostlycleanlept :
	for folder in $(libleptfolders); do \
		cd $$folder; \
		$(MAKE) mostlyclean; \
    done ; \

.PHONY : mostlycleantess
mostlycleantess :
	for folder in $(libtessfolders); do \
		cd $$folder; \
		$(MAKE) mostlyclean; \
    done ; \

.PHONY : distcleanimage
distcleanimage :
	-rm -rf $(IMAGE_LIB_DIR)
	-rm -rf $(IMAGE_INC_DIR)
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

