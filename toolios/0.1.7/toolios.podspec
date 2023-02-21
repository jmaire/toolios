#
# Be sure to run `pod lib lint toolios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'toolios'
  s.version          = '0.1.7'
  s.summary          = 'A tiny description of toolios.' #TODO: @jmaire

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A longer description of toolios.' #TODO: @jmaire
  
  s.homepage         = 'https://bitbucket.org/dazz_tv/toolios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Julien Maire' => 'julien.maire@dazz.fun' }
  s.source           = { :git => 'https://julien_maire@bitbucket.org/dazz_tv/toolios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*'
  
  s.swift_version = '4.2'
  
  # s.resource_bundles = {
  #   'toolios' => ['toolios/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
