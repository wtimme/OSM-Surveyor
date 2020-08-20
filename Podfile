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
    pod 'Alamofire', '~> 5.1'
    pod 'SwiftOverpassAPI'
    pod 'SQLite.swift'
    pod 'OAuthSwift', '~> 2.1.0'
    pod 'OAuthSwiftAlamofire', :git => 'https://github.com/OAuthSwift/OAuthSwiftAlamofire.git', :branch => 'master'
    pod 'KeychainAccess'
  end

end
