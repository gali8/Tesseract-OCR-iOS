Pod::Spec.new do |s|
  s.header_dir		             = 'TesseractOCR'
  s.name                       = 'TesseractOCRiOS'
  s.version                    = '4.0.0'

  s.summary                    = 'Use Tesseract OCR in iOS projects written in either Objective-C or Swift.'

  s.homepage                   = 'https://github.com/gali8/Tesseract-OCR-iOS'
  s.documentation_url          = 'https://github.com/gali8/Tesseract-OCR-iOS/blob/master/README.md'

  s.license                    = { type: 'MIT', file: 'LICENSE.md' }

  s.authors                    = { 'Daniele Galiotto' => 'genius@g8production.com',
                                   'Kevin Conley' => 'kcon@stanford.edu' }

  s.source                     = { git: 'https://github.com/gali8/Tesseract-OCR-iOS.git', tag: s.version.to_s }

  s.platform                   = :ios, '8.0'

  s.ios.source_files           = 'TesseractOCR/*.{h,m,mm}', 'TesseractOCR/ios/include/**/*.h'
  s.ios.private_header_files   = 'TesseractOCR/ios/include/**/*.h'
  s.ios.frameworks             = 'UIKit', 'Foundation'

  s.ios.deployment_target      = '8.0'
  s.ios.vendored_library       = 'TesseractOCR/ios/lib/*.a'

  s.platform                   = :macos, '10.11'

  s.macos.source_files         = 'TesseractOCR/*.{h,m,mm}', 'TesseractOCR/macos/include/**/*.h'
  s.macos.private_header_files = 'TesseractOCR/macos/include/**/*.h'
  s.macos.frameworks           = 'AppKit', 'Foundation'

  s.macos.deployment_target    = '10.11'
  s.macos.vendored_library     = 'TesseractOCR/macos/lib/*.a'

  s.requires_arc               = true

  s.xcconfig                   = { 'OTHER_LDFLAGS' => '-lstdc++ -lz',
                                   'CLANG_CXX_LIBRARY' => 'compiler-default' }

end
