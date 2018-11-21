Pod::Spec.new do |s|
  s.name             = 'dSRelay'
  s.version          = '0.1.0'
  s.summary          = 'A Swift library for connecting with Robot Electronics ethernet relay devices.'

  s.description      = <<-DESC
A Swift library to connect with devices from Robot Electronics such as the dS2824 over network connections.
                       DESC

  s.homepage         = 'https://github.com/Label305/dSRelay'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mèir Noordermeer' => 'meirnoordermeer@me.com' }
  s.source           = { :git => 'https://github.com/Label305/dSRelay.git', :tag => s.version.to_s }
  s.swift_version = '4.2'

  s.dependency 'SwiftSocket'
  s.dependency 'thenPromise'


  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'dSRelay/Classes/**/*'
end
