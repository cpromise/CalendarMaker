Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "CalendarMaker"
s.summary = "CalendarMaker lets a user create CalendarView easier using UIStackView."
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Rubberhammer" => "rubberhammer225@gmail.com" }

s.homepage = "https://github.com/cpromise/CalendarMaker"

s.source = { :git => "https://github.com/cpromise/CalendarMaker.git",
             :tag => "#{s.version}" }
             
s.framework = "UIKit"

s.source_files = "CalendarMaker/**/*.{swift}"

# s.resources = "CalendarMaker/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.swift_version = "5.2"

end
