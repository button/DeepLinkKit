Pod::Spec.new do |s|
  s.name             = "DeepLinkKit"
  s.version          = "1.5.0"
  s.summary          = "A splendid route-matching, block-based way to handle your deep links."
  s.description      = <<-DESC
                       DeepLink Kit is a splendid route-handling block-based way to handle deep links. Use DeepLink Kit to parse incoming URLs, extract parameters from the host, url etc.. and even build outgoing deep links. All with a simple, block-based interface.
                       DESC
  s.homepage         = "https://www.usebutton.com/developers/deep-link-kit/"
  s.license          = 'MIT'
  s.author           = 'Button, Inc.'
  s.source           = { :git => "https://github.com/button/DeepLinkKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/buttondev'

  s.ios.deployment_target     = "7.0"
  s.tvos.deployment_target    = "9.0"

  s.requires_arc     = true

  s.source_files        = 'DeepLinkKit/**/*.{h,m}'
  s.private_header_files = [
    "DeepLinkKit/**/DeepLinkKit_Private.h",
    "DeepLinkKit/**/DPLDeepLink_Private.h",
    "DeepLinkKit/**/DPLSerializable.h",
    "DeepLinkKit/**/DPLMatchResult.h",
    "DeepLinkKit/**/DPLRouteMatcher.h",
    "DeepLinkKit/**/DPLRegularExpression.h",
    "DeepLinkKit/**/NSString+DPLTrim.h",
    "DeepLinkKit/**/NSString+DPLQuery.h",
    "DeepLinkKit/**/NSString+DPLJSON.h",
    "DeepLinkKit/**/NSObject+DPLJSONObject.h",
    "DeepLinkKit/**/UINavigationController+DPLRouting.h",
]
end
