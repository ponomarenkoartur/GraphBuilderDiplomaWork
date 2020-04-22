# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

['GraphBuilderDiplomaWork', 'GraphBuilderDiplomaWorkTests'].each do |t|
  target t do
    # Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for GraphBuilderDiplomaWork
    
    
    # Coding speedup
    
    pod 'SnapKit'
    pod 'R.swift'
    pod 'UIFontComplete'
    pod 'AttributedString'
    pod 'SwiftyAttributes'
    
    
    # Math
    
    pod 'iosMath'
    pod 'MathpixClient'
    
    # Rx
    
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxGesture'
    pod 'RxKeyboard'
    pod 'RxDataSources', '~> 4.0'
    
    
    # Defining Swift version
    if ['GraphBuilderDiplomaWork'].include? t
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
    
  end
end
