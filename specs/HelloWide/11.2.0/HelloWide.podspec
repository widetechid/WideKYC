Pod::Spec.new do |s|
  s.name         = "HelloWide"
  s.version      = "11.2.0"
  s.summary      = "HelloWide iOS SDK"
  s.description  = <<-DESC
  HelloWide is one of products from Wide Technologies Indonesia.
                   DESC
  s.homepage     = "https://github.com/widetechid/HelloWide"
  s.license = { :type => "MIT", :text => "MIT License" }
  s.author       = { "WideTechId" => "github.mobile@primecash.co.id" }
  s.platform     = :ios, "15.1"
  s.ios.deployment_target = "15.1"
  s.swift_version = '5.0'
  s.source = { :http => 'https://maven.primecash.co.id/repository/maven-releases/id/co/widetechnologies/component/mobile/hellowide-ios/11.2.0/hellowide-ios-11.2.0.zip' }
  s.vendored_frameworks = 'Frameworks/HelloWide.xcframework', 'Frameworks/hermes.xcframework'
  s.dependency 'SocketRocket'
  s.dependency 'JitsiWebRTC', '~> 124.0.1'
  s.dependency 'Giphy', '2.2.12'
end
