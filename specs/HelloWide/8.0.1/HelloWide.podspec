Pod::Spec.new do |s|
  s.name         = "HelloWide"
  s.version      = "8.0.1"
  s.summary      = "HelloWide iOS SDK"
  s.description  = <<-DESC
  HelloWide is one of products from Wide Technologies Indonesia.
                   DESC
  s.homepage     = "https://github.com/widetechid/HelloWide"
  s.license = { :type => "MIT", :text => "MIT License" }
  s.author       = { "WideTechId" => "github.mobile@primecash.co.id" }
  s.platform     = :ios, "12.0"
  s.ios.deployment_target = "12.0"
  s.swift_version = '5.0'
  s.source = { :http => 'https://maven.primecash.co.id/repository/maven-releases/id/co/widetechnologies/component/mobile/hellowide-ios/8.0.1/hellowide-ios-8.0.1.zip' }
  s.vendored_frameworks = 'HelloWide.xcframework'
  s.dependency 'SocketRocket'
  s.dependency 'JitsiWebRTC', '~> 106.0.0'
  s.dependency 'Giphy', '2.1.20'
end
