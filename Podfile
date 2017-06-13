use_frameworks!
inhibit_all_warnings!

platform :ios, '10.0'

def shared_pods
    pod 'Texture'
    pod 'RxSwift', '~> 3.0'
    pod 'Alamofire', '~> 4.4'
    pod 'Gloss'
    pod 'JHSpinner'
    pod 'Charts'
    pod 'RealmSwift'
    pod 'OneStore'
    pod 'Fabric'
    pod 'Crashlytics'
end

target 'pr' do
    pod 'TUSafariActivity'
    pod 'ESTabBarController-swift'
    pod 'Eureka'
    pod 'URLNavigator', '~> 1.2'
    pod 'Pages'
    shared_pods
end

target 'urlaction' do
    shared_pods
end
