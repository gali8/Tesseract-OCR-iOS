Pod::Spec.new do |s|
  s.name                    = 'TesseractOCRiOS'
  s.version                 = '3.4.0'

  s.summary                 = 'Use Tesseract OCR in iOS projects written in either Objective-C or Swift.'

  s.homepage                = 'https://github.com/gali8/Tesseract-OCR-iOS'
  s.documentation_url       = 'https://github.com/gali8/Tesseract-OCR-iOS/blob/master/README.md'

  s.license                 = { :type => 'MIT',
                                :file => 'LICENSE.md' }

  s.authors                 = { 'Daniele Galiotto' => 'genius@g8production.com',
                                'Kevin Conley' => 'kcon@stanford.edu'}

  s.source                  = { :git => 'https://github.com/gali8/Tesseract-OCR-iOS.git',                                                         :tag => s.version.to_s }

  s.platform                = :ios, "7.0"
  s.source_files            = 'TesseractOCR/*.h', 'TesseractOCR/include/**/*.h'
  s.requires_arc            = true
  s.frameworks              = 'UIKit', 'Foundation'

  s.ios.deployment_target   = "7.0"
  s.ios.vendored_library    = 'TesseractOCR/lib/*.a'
  s.ios.vendored_frameworks = 'Products/TesseractOCR.framework'
  s.xcconfig                = { 'OTHER_LDFLAGS' => '-lstdc++ -weak_library /usr/lib/libstdc++.6.0.9.dylib',
                                'CLANG_CXX_LIBRARY' => 'compiler-default' }

end
