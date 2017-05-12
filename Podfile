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
end

target 'pr' do
    pod 'TUSafariActivity'
    pod 'ESTabBarController-swift'
    pod 'Eureka'
    pod 'OneStore'
    pod 'URLNavigator', '~> 1.2'
    pod 'Pages'
    pod 'Fabric'
    pod 'Crashlytics'
    shared_pods
end

target 'urlaction' do
    shared_pods
end
