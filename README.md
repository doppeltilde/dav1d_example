# fvp with dav1d
Example on how to use dav1d with the fvp package.

## Steps for iOS:
1. Download and unzip [libdav1d.dll/libdav1d.dylib/dav1d.framework/libdav1dso](https://sourceforge.net/projects/mdk-sdk/files/deps/dep.7z/download) to support av1 software decoding.
2. Create a `Frameworks` folder in the `ios` folder.
3. inside of the unzipped `dep`folder go to `lib>iOS` and move the entire dav1d.framework folder into the created `Frameworks` folder.
4. Create a new `dav1d.podspec` file inside of ios, with values:
```ruby
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
```

5. Add this dependency declaration into the Podfile under `target 'Runner' do`.
```ruby
pod 'dav1d', :path => '.', :configurations => ['Release']
```