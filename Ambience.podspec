#
# Be sure to run `pod lib lint Ambience.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Ambience'
  s.version          = '0.0.5'
  s.summary          = 'An ambient light accessibility framework for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Ambience, a brightness aware ambient lightning accessibility framework. Although Apple has yet to publicize the APIs for the ambient light sensor, it does let a given app look for screen brightness events. And that’s exactly what Ambience does. It listens to events and relays state thresholds to your app so it can adapt its looks and layout.
                       DESC

  s.homepage         = 'https://github.com/tmergulhao/Ambience'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tmergulhao' => 'me@tmergulhao.com' }
  s.source           = { :git => 'https://github.com/tmergulhao/Ambience.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Ambience/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Ambience' => ['Ambience/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
