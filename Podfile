# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'OtocabTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for OtocabTask
  pod 'SwiftMessages', '~> 6.0.2'
  pod 'IQKeyboardManagerSwift', '~> 6.3.0'
  pod 'GoogleMaps', '~> 3.8.0'
  pod 'GooglePlaces', '~> 3.8.0'
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
