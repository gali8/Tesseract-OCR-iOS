Pod::Spec.new do |s|
  s.name              = 'TesseractOCRiOS'
  s.version           = '2.21'

  s.summary           = 'It helps you to use OCR in iOS projects, writing Objective-C. Easy and fast.'
 
  s.homepage          = 'https://code.google.com/p/tesseract-ocr/'
  s.documentation_url = 'https://code.google.com/p/tesseract-ocr/wiki/FAQ'

  s.license           = 'MIT'
  s.author            = { 'Daniele Galiotto' => '' }
  s.source            = { :git => 'https://github.com/gali8/Tesseract-OCR-iOS', :branch => "podspec" }

  s.platform          = :ios, '5.0'
  s.source_files      = 'Classes'
  s.requires_arc      = true
  
  s.frameworks              = 'UIKit', 'Foundation'
  s.ios.vendored_frameworks = 'Products/TesseractOCR.framework'
  s.xcconfig                = { 'OTHER_LDFLAGS' => '-lstdc++ -weak_library /usr/lib/libstdc++.6.0.9.dylib', 'CLANG_CXX_LIBRARY' => 'compiler-default' }

end