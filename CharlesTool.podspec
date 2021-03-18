#
# Be sure to run `pod lib lint CharlesTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CharlesTool'
  s.version          = '1.0.0'
  s.summary          = 'A short description of CharlesTool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kongyhui@163.com/CharlesTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kongyhui@163.com' => 'konghui@cdeledu.com' }
  s.source           = { :git => 'https://github.com/kongyhui@163.com/CharlesTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CharlesTool/Classes/**/*'
  
  s.resource = 'CharlesTool/Assets/*.*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry', '>= 0.6.0'
  s.dependency 'ReactiveCocoa', '2.3.1'
  s.dependency 'JSONKit-NoWarning', '>= 1.2'
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  s.prefix_header_contents = '#define MAS_SHORTHAND',
  '#define MAS_SHORTHAND_GLOBALS',
  '#import <Masonry/Masonry.h>',
  '#import <ReactiveCocoa/ReactiveCocoa.h>',
  '#import <ReactiveCocoa/RACEXTScope.h>'

end
