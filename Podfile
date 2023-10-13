# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'Weather3Days4ecast' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Weathersama', '~> 1.1.3'
  pod 'LatLongToTimezone'
  pod 'SwiftVideoBackground'

  # Pods for Weather3Days4ecast


  target 'Weather3Days4ecastTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Weather3Days4ecastUITests' do
    # Pods for testing
  end
  
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
           end
      end
    end
  end

end
