# fvp with dav1d
Example on how to use [dav1d](https://www.videolan.org/projects/dav1d.html) with the [fvp package](https://pub.dev/packages/fvp).

## Essential
Download and unzip [libdav1d.dll/libdav1d.dylib/dav1d.framework/libdav1dso](https://sourceforge.net/projects/mdk-sdk/files/deps/dep.7z/download) to support av1 software decoding.

## Steps for iOS
2. Create a new `frameworks`folder inside of the `iOS` folder.
3. Inside of the unzipped `dep` folder go to `lib>iOS` and move the entire `dav1d.framework` and `ass.framework` folders into the `frameworks` folder.
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
  s.vendored_frameworks = ['frameworks/dav1d.framework', 'frameworks/ass.framework']
  s.source = { :path => '.' }
end
```

5. Add this dependency declaration into the Podfile under `target 'Runner' do`:
```ruby
pod 'dav1d', :path => '.', :configurations => ['Release']
```

6. Set ios `video.decoders`:
```
'VT',
'dav1d',
'FFmpeg',
```

>[!NOTE]
> Does not work on `ios-simulator`.

## Steps for Android
1. Create a new `jniLibs` folder inside of `android/app/src/main`.
2. Move the `arm64-v8a` folder in the unzipped `dep` folder under `lib>android` into the new `jniLibs` folder.
3. Set android `video.decoders`:
```
'AMediaCodec',
'dav1d',
'FFmpeg',
```