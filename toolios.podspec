#
# Be sure to run `pod lib lint toolios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'toolios'
  s.version          = '1.0.1'
  s.summary          = 'A bunch of tools for Swift developers.'
  s.description      = 'A bunch of tools for Swift developers.'
  s.homepage         = 'https://github.com/jmaire/toolios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Julien Maire' => 'julien.maire.pro@gmail.com' }
  s.source           = { :git => 'https://github.com/jmaire/toolios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/**/*'
  s.swift_version = '4.2'
end
