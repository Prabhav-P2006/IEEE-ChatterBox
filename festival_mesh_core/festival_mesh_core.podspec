Pod::Spec.new do |s|
  s.name             = 'festival_mesh_core'
  s.version          = '1.0.0'
  s.summary          = 'Mesh Core C++ library.'
  s.homepage         = 'https://github.com'
  s.license          = { :type => 'MIT' }
  s.author           = { 'PRABHAV' => 'prabhav' }
  s.source           = { :path => '.' }
  s.ios.deployment_target = '13.0'
  s.source_files = 'src/**/*.{cpp,c}', 'include/**/*.{h}'
  s.public_header_files = 'include/**/*.h'
  s.pod_target_xcconfig = { 
    'GCC_PREPROCESSOR_DEFINITIONS' => 'USING_MONOCYPHER=1',
    'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/include' 
  }
end
