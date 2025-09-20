# ios/dav1d.podspec
Pod::Spec.new do |s|
  s.name         = 'dav1d'
  s.version      = '1.0.0'
  s.summary      = 'dav1d AV1 decoder for MDK'
  s.homepage     = 'https://code.videolan.org/videolan/dav1d'
  s.license      = 'BSD'
  s.author       = 'VideoLAN'
  s.ios.deployment_target = '9.0'
  s.vendored_frameworks = 'Frameworks/dav1d.framework'
  s.source = { :path => '.' }
end