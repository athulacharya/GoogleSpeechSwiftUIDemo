Pod::Spec.new do |s|
  s.name     = 'googleapis'
  s.version  = '0.0.2'
  s.license  = 'Apache 2.0'
  s.authors  = { 'Google Inc.' => 'timburks@google.com', "Athul K. Acharya" => ""}
  s.homepage = 'https://github.com/athulacharya/GoogleSpeechSwiftUIDemo/'
  s.source   = { :git => 'https://github.com/athulacharya/GoogleSpeechSwiftUIDemo.git',
                 :tag => '0.0.2' }
  s.summary  = 'Service definitions for Google Cloud Platform APIs'	  

  s.ios.deployment_target = '16.4'
  s.osx.deployment_target = '10.15'

  s.dependency 'gRPC-ProtoRPC'
  s.dependency 'Protobuf', '3.22.1' # Do we even need this anymore?

  # Just include the files you generated
  s.source_files = "google/**/*.pbobjc.{h,m}"
  s.header_mappings_dir = "."

  s.subspec 'Messages' do |ms|
    ms.requires_arc = false
    ms.source_files = 'google/**/*.pbobjc.{h,m}'
    ms.dependency 'Protobuf', '3.22.1'
  end

  s.subspec 'Services' do |ss|
    ss.requires_arc = true
    ss.source_files = 'google/**/*.pbrpc.{h,m}'
    ss.dependency 'gRPC-ProtoRPC'
  end

  s.pod_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1',
	  'USER_HEADER_SEARCH_PATHS' => '$SRCROOT/..'
  }
  
end

