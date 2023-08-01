# Uncomment the next line to define a global platform for your project
# platform :ios, '16.0'

target 'Giftify' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Giftify
  pod 'SnapKit', '~> 5.6.0'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'Swinject'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseFirestoreSwift'
  pod 'GoogleSignIn'

     post_install do |installer|
         installer.generated_projects.each do |project|
               project.targets.each do |target|
                   target.build_configurations.each do |config|
                       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                    end
               end
        end
	installer.pods_project.build_configurations.each do |config|
    		config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "x86_64"
  	end
     end


  target 'GiftifyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GiftifyUITests' do
    # Pods for testing
  end

end