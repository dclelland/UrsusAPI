Pod::Spec.new do |s|
  s.name = "UrsusAPI"
  s.version = "0.1.0"
  s.summary = "An Urbit API/`%gall` agent client for iOS/macOS."
  s.homepage = "https://github.com/dclelland/UrsusAPI"
  s.license = { type: 'MIT' }
  s.author = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source = { git: "https://github.com/dclelland/UrsusAPI.git", tag: "0.1.0" }
  s.swift_versions = ['5.1', '5.2']
  
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  
  s.source_files = 'Ursus API/**/*.swift'
  
  s.dependency 'UrsusAirlock', '~> 1.9'
end
