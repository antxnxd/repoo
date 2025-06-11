platform :ios, '16.6'

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

target 'SixtemiaTest' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SixtemiaTest
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'IQKeyboardManagerSwift'
  pod 'OneSignal', '>= 2.6.2', '< 3.0'
  pod 'Zip'
  pod 'lottie-ios'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.6'
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.6'
    end
  end
end
