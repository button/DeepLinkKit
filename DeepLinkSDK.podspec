Pod::Spec.new do |s|
  s.name             = "DeepLinkSDK"
  s.version          = "0.1.0"
  s.summary          = "A splendid route-matching, block-based way to handle your deep links."
  s.description      = <<-DESC
                       The Button DeepLink SDK removes a all of the hard work of deciding how to uniformly handle incoming
                       deep links in your app. Rather than decide how to format your URLs, parse them, pass data, and navigate
                       to specific content or perform actions, this SDK and a few lines of code will get you on your way.
                       DESC
  s.homepage         = "http://www.usebutton.com/sdk/deep-links"
  s.license          = 'MIT'
  s.author           = 'Button, Inc.'
  s.source           = { :git => "https://github.com/usebutton/ios-deeplink-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/buttondev'

  s.platform         = :ios, '6.0'
  s.requires_arc     = true

  s.source_files     = 'DeepLinkSDK/**/*.{h,m}'
end
