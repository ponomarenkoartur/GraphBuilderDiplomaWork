# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'GraphBuilderDiplomaWork' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for GraphBuilderDiplomaWork
  
  
  # Coding speedup
  
  pod 'SnapKit'
  pod 'R.swift'
  pod 'UIFontComplete'
  pod 'AttributedString'
  
  
  # Math
  
  pod 'iosMath'
  pod 'MathpixClient'
  
  # Rx
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  pod 'RxKeyboard'
  
  
  # Defining Swift version
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if ['MathpixClient'].include? target.name
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4'
        end
      end
    end
  end
  
end
