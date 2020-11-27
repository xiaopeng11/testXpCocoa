#
#  Be sure to run `pod spec lint testXpCocoa.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "testXpCocoa"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of TestCocoapods."
  spec.description  = <<-DESC
                        一个测试包
                        DESC

  spec.homepage     = "https://github.com/xiaopeng11/testXpCocoa"
  spec.license      = "MIT"
  spec.author       = { "肖鹏" => "xiaopeng@upplus.net" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/xiaopeng11/testXpCocoa.git", :tag => "1.0.0" }

  spec.source_files = "testXpCocoa/*.{h,m}"
  spec.frameworks   = "UIKit","AVFoundation","Foundation"
  spec.resources    = "testXpCocoa/*.png"


end
