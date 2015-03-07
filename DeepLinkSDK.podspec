Pod::Spec.new do |s|
  s.name             = "DeepLinkSDK"
  s.version          = "0.2.4"
  s.summary          = "A splendid route-matching, block-based way to handle your deep links."
  s.description      = <<-DESC
                       The Button DeepLink SDK is a splendid route-handling block-based way to handle deep links. Rather than decide how to format your URLs, parse them, pass data, and navigate to specific content or perform actions, this SDK and a few lines of code will get you on your way.
                       DESC
  s.homepage         = "http://www.usebutton.com/sdk/deep-links"
  s.license          = 'MIT'
  s.author           = 'Button, Inc.'
  s.source           = { :git => "https://github.com/usebutton/ios-deeplink-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/buttondev'

  s.platform         = :ios, '7.0'
  s.requires_arc     = true

  s.source_files     = 'DeepLinkSDK/**/*.{h,m}'
end
