source 'https://github.com/CocoaPods/Specs.git'

workspace 'Tesseract-OCR-iOS'
xcodeproj 'TestsProject/TestsProject.xcodeproj/', 'Coverage': :debug

def testing_pods
  pod 'Kiwi', '~> 2.3.1'
end

target 'TestsProjectTests' do
  testing_pods
end

target 'TestsProjectmacOSTests' do
  testing_pods
end
