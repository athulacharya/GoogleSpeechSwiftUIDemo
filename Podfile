app_ios_deployment_target = Gem::Version.new('16.4') # Change to your current deployment target
platform :ios, app_ios_deployment_target.version

target 'GoogleSpeechSwiftUIDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GoogleSpeechSwiftUIDemo
  pod 'googleapis', :path => '.'

end

# Let Pods targets inherit deployment target from the app
# This solution is suggested here: https://github.com/CocoaPods/CocoaPods/issues/4859
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      pod_ios_deployment_target = Gem::Version.new(configuration.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
      if pod_ios_deployment_target <= app_ios_deployment_target
        configuration.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end

    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end
