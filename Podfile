source 'https://github.com/CocoaPods/Specs.git'

workspace 'Tesseract-OCR-iOS'

def testing_pods
  pod 'Kiwi', '~> 3.0.0'
end

target 'Tests-iOSTests' do
  project 'Tests-iOS/Tests-iOS.xcodeproj/'
  platform :ios, '11.3'
  testing_pods
end

target 'Tests-macOSTests' do
  project 'Tests-macOS/Tests-macOS.xcodeproj/'
  platform :osx, '10.13'
  testing_pods
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
