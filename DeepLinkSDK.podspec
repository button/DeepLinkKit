Pod::Spec.new do |s|
  s.name             = "DeepLinkSDK"
  s.version          = "0.0.1"
  s.summary          = "A splendid way to handle DPL/AppLinks compliant deep links."
  s.description      = <<-DESC
                       Making deep linking easy. A splendid way to handle DPL/AppLinks compliant deep links.
                       DESC
  s.homepage         = "http://www.usebutton.com"
  s.license          = 'Private'
  s.author           = 'Button, Inc.'
  s.source           = { :git => "https://github.com/usebutton/ios-deeplink-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/usebutton'

  s.platform         = :ios, '7.0'
  s.requires_arc     = true

  s.source_files     = 'DeepLinkSDK/**/*.{h,m}'
#  s.resources        = ['DeepLinkSDK/Resources/*.{png,xib}']
end
