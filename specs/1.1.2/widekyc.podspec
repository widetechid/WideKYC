#
#  Be sure to run `pod spec lint widekyc.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "widekyc"
  s.version      = "1.1.2"
  s.summary      = "WideKYC offered by PT. Wide Technologies Indonesia"
  s.description  =  <<-DESC
  WideKYC is All in one eKYC (Electronic Know Your Customer) solution offered by PT. Wide Technologies Indonesia
                    DESC
  s.homepage     = 'https://github.com/widetechid/WideKYC.git'
  s.license = { :type => "MIT", :text => "MIT License" }
  s.author       = { 'widetechid' => 'github.mobile@primecash.co.id' }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.platform    = :ios, '11.0'
  s.source = { :http => 'https://maven.primecash.co.id/repository/maven-releases/id/co/widetechnologies/component/mobile/widekyc-ios/1.1.2/widekyc-ios-1.1.2.zip' }      
  s.vendored_frameworks = 'widekyc.framework'
  s.frameworks = 'CoreTelephony', 'Foundation', 'SystemConfiguration'
  s.static_framework = true
  s.requires_arc = true
  s.libraries = 'c++', 'z'
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.dependency 'SwiftyJSON'
  s.dependency 'SVProgressHUD'
  s.dependency 'GoogleMLKit/TextRecognition', '2.2.0'
  s.dependency 'GoogleMLKit/FaceDetection'

end
