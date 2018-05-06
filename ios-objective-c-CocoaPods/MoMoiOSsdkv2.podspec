#
# Be sure to run `pod lib lint MoMoiOSsdkv2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MoMoiOSsdkv2'
  s.version          = '2.2.0'
  s.summary          = 'MoMo Sdk framework for ObjC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'MoMo SDK is designed to work with iOS 8.0 or newest. Swift 2.0 , ObjC supported'

  s.homepage         = 'https://github.com/momodevelopment/MoMoiOSsdkv2'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'momodevelopment' => 'lanhluu.vn@gmail.com' }
  s.source           = { :git => 'https://github.com/momodevelopment/MoMoiOSsdkv2.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  s.source_files = 'MoMoiOSsdkv2/Classes/**/*'
  s.resource_bundles = {
    'MoMoiOSsdkv2' => ['MoMoiOSsdkv2/Assets/*.png']
  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
