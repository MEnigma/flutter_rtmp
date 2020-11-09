#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_rtmp'
  s.version          = '0.0.1'
  s.summary          = 'A rtmp plugin'
  s.description      = <<-DESC
A rtmp plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.dependency 'FlutterMacOS'
  
    s.platform = :osx, '10.11'
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
    s.swift_version = '5.0'
    
      
    # s.dependency 'LFLiveKit'
    # s.dependency 'MJExtension'

  end