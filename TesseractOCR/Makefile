SDK_IPHONEOS_PATH=$(shell xcrun --sdk iphoneos --show-sdk-path)
SDK_IPHONESIMULATOR_PATH=$(shell xcrun --sdk iphonesimulator --show-sdk-path)
XCODE_DEVELOPER_PATH=/Applications/Xcode.app/Contents/Developer
XCODETOOLCHAIN_PATH=$(XCODE_DEVELOPER_PATH)/Toolchains/XcodeDefault.xctoolchain
IOS_DEPLOY_TGT="7.0"

LEPTON_NAME = leptonica-1.72

TESSERACT_SRC = $(shell pwd)/tesseract-ocr
LEPTON_SRC = $(shell pwd)/$(LEPTON_NAME)
IMAGE_SRC = $(shell pwd)/libtiff-ios

IMAGE_LIB_DIR = $(IMAGE_SRC)/dependencies/lib/
IMAGE_INC_DIR = $(IMAGE_SRC)/dependencies/include/
LIB_FAT_DIR = $(shell pwd)/lib

libtessallfiles = libtesseract_all.a
libtessfiles = ccmain/.libs/libtesseract_main.a ccstruct/.libs/libtesseract_ccstruct.a \
                ccutil/.libs/libtesseract_ccutil.a classify/.libs/libtesseract_classify.a cube/.libs/libtesseract_cube.a cutil/.libs/libtesseract_cutil.a \
                dict/.libs/libtesseract_dict.a neural_networks/runtime/.libs/libtesseract_neural.a opencl/.libs/libtesseract_opencl.a \
                textord/.libs/libtesseract_textord.a viewer/.libs/libtesseract_viewer.a wordrec/.libs/libtesseract_wordrec.a \
				api/.libs/libtesseract.a api/.libs/libtesseract_api.a
libleptfiles = liblept.a
libpngfiles = libpng.a libpng16.a
libjpegfiles = libjpeg.a
libtifffiles = libtiff.a libtiffxx.a

sdks = $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONESIMULATOR_PATH) $(SDK_IPHONESIMULATOR_PATH)
archs = armv7 armv7s arm64 i386 x86_64
arch_names = arm-apple-darwin7 arm-apple-darwin7s arm-apple-darwin64 i386-apple-darwin x86_64-apple-darwin

libleptfolders = $(foreach arch, $(arch_names), $(LEPTON_SRC)/$(arch)/)
libleptmakefile = $(foreach folder, $(libleptfolders), $(addprefix $(folder), Makefile) )

libtessfolders = $(foreach arch, $(arch_names), $(TESSERACT_SRC)/$(arch)/)
libtessmakefile = $(foreach folder, $(libtessfolders), $(addprefix $(folder), Makefile) )

libleptfat = $(LIB_FAT_DIR)/$(libleptfiles)
libtessfat = $(LIB_FAT_DIR)/$(libtessallfiles)

libtessall = $(foreach folder, $(libtessfolders), $(addprefix $(folder), $(libtessallfiles)) )
libtess    = $(foreach folder, $(libtessfolders), $(addprefix $(folder), $(libtessfiles)) )
liblept    = $(foreach folder, $(addsuffix src/.libs/, $(libleptfolders) ), $(addprefix $(folder), $(libleptfiles)) )
libpng     = $(addprefix $(IMAGE_LIB_DIR), $(libpngfiles))
libjpeg    = $(addprefix $(IMAGE_LIB_DIR), $(libjpegfiles))
libtiff    = $(addprefix $(IMAGE_LIB_DIR), $(libtifffiles))

libtessautogen = $(TESSERACT_SRC)/autogen.sh
libtessconfig = $(TESSERACT_SRC)/configure
libleptconfig = $(LEPTON_SRC)/configure
libtiffconfig = $(IMAGE_SRC)

index = $(words $(shell a="$(2)";echo $${a/$(1)*/$(1)} ))
swap  = $(word $(call index,$(1),$(2)),$(3))

dependant_libs = $(libtessfat) $(libleptfat) $(libpng) $(libjpeg) $(libtiff)

.PHONY : all
all : $(dependant_libs)

#######################
# TESSERACT-OCR
#######################
$(libtessfat) : $(libtessall)
	xcrun lipo $^ -create -output $@

$(libtessall) : $(libtess)
	cd $(@D) ; \
	xcrun libtool -static -o $@ `find . -name "lib*.a"` -no_warning_for_no_symbols

$(libtess) : $(liblept) $(libtessmakefile)
	echo $(libtessmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE)

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
	../configure --host=$* --enable-shared=no --disable-graphics

$(libtessconfig) : $(libtessautogen)
	cd $(@D) ; \
	./autogen.sh

#######################
# LEPTONLIB
#######################
$(libleptfat) : $(liblept)
	xcrun lipo $^ -create -output $@

$(liblept) : $(libtiff) $(libleptmakefile)
	cd $(abspath $(@D)/../..) ; \
	$(MAKE)

$(LEPTON_SRC)/%/Makefile : $(libleptconfig)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names), $(sdks))" ; \
	export CFLAGS="-I$(IMAGE_INC_DIR) -L$(IMAGE_LIB_DIR) -Qunused-arguments -arch $(call swap, $*, $(arch_names), $(archs)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
    export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(IMAGE_LIB_DIR)" ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
    ../configure --host=$* --enable-shared=no --disable-programs --with-zlib --with-libpng --with-jpeg --without-giflib --with-libtiff

#######################
# Build libtiff and all of it's dependencies
#######################
$(libtiff) : $(libpng) $(libjpeg) $(libtiffconfig)
	cd $(IMAGE_SRC) ; \
	./build-tiff.sh

$(libpng) : $(libtiffconfig)
	cd $(IMAGE_SRC); \
    ./build-png.sh

$(libjpeg) : $(libtiffconfig)
	cd $(IMAGE_SRC) ;\
	./build-jpg.sh

#######################
# Download dependencies
#######################
$(libtiffconfig) $(libtessautogen) :
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

cleanlept :
	for folder in $(libleptfolders); do \
		cd $$folder; \
		$(MAKE) clean; \
	done ; \

cleantess :
	for folder in $(libtessfolders); do \
		cd $$folder; \
		$(MAKE) clean; \
    done ; \

mostlycleanimage :

mostlycleanlept :
	for folder in $(libleptfolders); do \
		cd $$folder; \
		$(MAKE) mostlyclean; \
    done ; \

mostlycleantess :
	for folder in $(libtessfolders); do \
		cd $$folder; \
		$(MAKE) mostlyclean; \
    done ; \

.PHONY : distcleanimage
distcleanimage :
	-rm -rf $(IMAGE_SRC)

PHONY : distcleanlept
distcleanlept :
	-rm -rf $(libleptfat)
	-rm -rf $(LEPTON_SRC)

.PHONY : distcleantess
distcleantess :
	-rm -rf $(libtessfat)
	-rm -rf $(TESSERACT_SRC)

