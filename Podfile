# Uncomment the next line to define a global platform for your project
platform :ios, '10.3'

# ignore all warnings from all pods
inhibit_all_warnings!

def shared_pods
  pod "DynamicColor"
end

["Confetti"].each do |t|
    target t do
      use_frameworks!
      shared_pods

      pod "AvatarImageView"
      pod "SDWebImage"
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

      pod 'AppCenter'
      pod 'AppCenter/Distribute'
      pod 'AppCenter/Push'
      pod 'SQLite.swift'
      pod 'CodableFirebase'
    end
end

target 'ConfettiKit' do
  use_frameworks!
  shared_pods
end

target 'ConfettiUITests' do
  use_frameworks!
  pod 'AppCenterXCUITestExtensions'
end
