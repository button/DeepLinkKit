#
# Be sure to run `pod lib lint DeepLinkSDK.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DeepLinkSDK"
  s.version          = "0.1.0"
  s.summary          = "A short description of DeepLinkSDK."
  s.description      = <<-DESC
                       An optional longer description of DeepLinkSDK

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/usebutton/DeepLinkSDK"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = 'Button, Inc.'
  s.source           = { :git => "https://github.com/usebutton/DeepLinkSDK.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/usebutton'

  s.platform         = :ios, '7.0'
  s.requires_arc     = true

  s.source_files     = 'DeepLinkSDK/**/*.{h,m}'
  s.resources        = ['DeepLinkSDK/Resources/*.{png,xib}']

  # s.public_header_files = 'DeepLinkSDK/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
