#in xcode7 build envirenment there is no pip installed
sudo easy_install pip		

sudo pip install PyYAML
sudo pip install cpp-coveralls

#build TesseractOCR
cd TesseractOCR
make
cd ..

