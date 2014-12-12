Pod::Spec.new do |s|
  s.name             = "DeepLinkSDK"
  s.version          = "0.1.0"
  s.summary          = "A splendid way to handle DLC/AppLinks compliant deep links."
  s.description      = <<-DESC
                       Making deep linking easy. A splendid way to handle DLC/AppLinks compliant deep links.
                       DESC
  s.homepage         = "https://github.com/usebutton/DeepLinkSDK"
  s.license          = 'Private'
  s.author           = 'Button, Inc.'
  s.source           = { :git => "https://github.com/usebutton/DeepLinkSDK.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/usebutton'

  s.platform         = :ios, '7.0'
  s.requires_arc     = true

  s.source_files     = 'DeepLinkSDK/**/*.{h,m}'
  s.resources        = ['DeepLinkSDK/Resources/*.{png,xib}']
end
