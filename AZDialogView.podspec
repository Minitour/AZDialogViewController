Pod::Spec.new do |s|
  s.name         = "AZDialogView"
  s.version      = "1.3.8"
  s.summary      = "A highly customizable alert dialog controller that mimics Snapchat's alert dialog."
  s.homepage     = "https://github.com/Minitour/AZDialogViewController"
  s.license      = "MIT"
  s.author       = { "Antonio Zaitoun" => "tony.z.1711@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/Minitour/AZDialogViewController.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/**/*.{swift}"
end
