platform :ios, '13.0'

target 'OSMSurveyor' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for OSMSurveyor
  pod 'Tangram-es', '~> 0.12.0'

  target 'OSMSurveyorTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OSMSurveyorFramework' do
    pod 'SwiftOverpassAPI', :git => 'https://github.com/wtimme/SwiftOverpassAPI.git', :branch => 'feature/1-Add-support-for-meta-data'
    pod 'SQLite.swift'
  end

end
