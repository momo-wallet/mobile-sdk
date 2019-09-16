#
# Be sure to run `pod lib lint MomoiOSSwiftSdkV2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MomoSdkiOSSwift'
  s.version          = '3.0.1'
  s.summary          = 'Momo iOS Swift Sdk V3'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Mobile sdk iOS '

  s.homepage         = 'https://github.com/momo-wallet/mobile-sdk/tree/release_swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'momodevelopment' => 'lanh.luu@mservice.com.vn' }
  s.source           = { :git => 'https://github.com/momo-wallet/mobile-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pod/**/*'

  s.resource_bundles = {
     'MomoSdkiOSSwift' => ['MomoSdkiOSSwift/Resources/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end