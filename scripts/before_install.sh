#in xcode7 build envirenment there is no pip installed
sudo easy_install pip		

sudo pip install PyYAML
sudo pip install cpp-coveralls

# uncomment the following to build TesseractOCR under Travis,
# but be aware that it takes quiet long and Travis may fail due to build time limit, which is 50 min
#cd TesseractOCR
#make
#cd ..

