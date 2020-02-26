#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'preloaded_images'
  s.version          = '1.0.2'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin to fetch latest 'X' images from the device storage.
                       DESC
  s.homepage         = 'http://github.com/sur950/preloaded_images'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Suresh' => 'konakanchisuresh950@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '9.0'
end

