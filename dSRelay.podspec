#
# Be sure to run `pod lib lint dSRelay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'dSRelay'
  s.version          = '0.1.0'
  s.summary          = 'A Swift library for connecting with Robot Electronics ethernet relay devices.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A Swift library to connect with devices from Robot Electronics such as the dS2824 over network connections.
                       DESC

  s.homepage         = 'https://github.com/Label305/dSRelay'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mèir Noordermeer' => 'meirnoordermeer@me.com' }
  s.source           = { :git => 'https://github.com/Label305/dSRelay.git', :tag => s.version.to_s }


  s.dependency 'SwiftSocket'
  s.dependency 'thenPromise'

  s.ios.deployment_target = '8.0'

  s.source_files = 'dSRelay/Classes/**/*'
end
