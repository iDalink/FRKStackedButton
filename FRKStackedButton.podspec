Pod::Spec.new do |s|
  s.name         = "FRKStackedButton"
  s.version      = "0.1"
  s.summary      = "A UIButton subclass that stacks its image and title vertically"
  s.homepage     = "https://github.com/Frankacy/FRKStackedButton"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Frank Courville" => "frank.courville+oss@gmail.com" }
  s.social_media_url   = "http://twitter.com/frankacy"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Frankacy/FRKStackedButton", 
  		     :tag => "0.1" }
  s.source_files  = "classes/*.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true
end
