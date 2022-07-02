Pod::Spec.new do |s|
  s.name             = 'haishin_kit'
  s.version          = '0.0.1'
  s.summary          = 'HaishinKit Flutter plugin project.'
  s.description      = <<-DESC
  HaishinKit Flutter plugin project.
  DESC
  s.homepage         = 'https://github.com/shogo4405/HaishinKit.dart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'shogo4405' => 'shogo4405@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'HaishinKit'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.5'
end
