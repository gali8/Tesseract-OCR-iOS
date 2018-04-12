source 'https://github.com/CocoaPods/Specs.git'

workspace 'Tesseract-OCR-iOS'

def testing_pods
  pod 'Kiwi', '~> 2.4.0'
end

target 'TestsProjectTests' do
  project 'TestsProject/TestsProject.xcodeproj/', 'Coverage' => :debug
  platform :ios, '11.3'
  testing_pods
end

target 'TestsProjectmacOSTests' do
  project 'TestsProjectmacOS/TestsProjectmacOS.xcodeproj/', 'Coverage' => :debug
  platform :osx, '10.13'
  testing_pods
end
