# Uncomment the next line to define a global platform for your project
platform :ios, '10.3'

def shared_pods
  pod "DynamicColor", '~> 3.3'
end

["Confetti"].each do |t|
    target t do
      use_frameworks!
      shared_pods

      pod "AvatarImageView", '~> 2.0.3'
      pod "SDWebImage", '~> 4.0.0'
      pod "FRStretchImageView"

      pod 'FacebookCore'
      pod 'FacebookLogin'
      pod 'FacebookShare'

      pod 'Firebase/Core'
      pod 'Firebase/Auth'
      pod 'Firebase/Database'
      pod 'Firebase/Storage'
      pod 'Firebase/Performance'
      pod 'FirebaseUI/Storage'

      pod 'MobileCenter'
      pod 'MobileCenter/MobileCenterDistribute'
      pod 'MobileCenter/MobileCenterPush'
    end
end

target 'ConfettiKit' do
  use_frameworks!
  shared_pods
end

target 'ConfettiUITests' do
  use_frameworks!
  pod 'VSMobileCenterExtensions'
end
