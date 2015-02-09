#import "Specta.h"
#import "DPLMutableDeepLink+AppLinks.h"
#import "DPLDeepLink_Private.h"

SpecBegin(DPLMutableDeepLink_AppLinks)


describe(@"Building App Links", ^{
    
    context(@"with input data", ^{
        
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://applinks"];
        link.targetURL           = [NSURL URLWithString:@"http://applinks.org/documentation"];
        link.extras[@"foo"]      = @"bar";
        link.userAgent           = @"Derp 1.0";
        link.referrerTargetURL   = [NSURL URLWithString:@"http://example.com/docs"];
        link.referrerURL         = [NSURL URLWithString:@"example://docs"];
        link.referrerAppName     = @"Derp";
        
        it(@"creates a valid App Link structure", ^{
            NSDictionary *data = @{ DPLAppLinksTargetURLKey: @"http://applinks.org/documentation",
                                    DPLAppLinksExtrasKey: @{ @"foo": @"bar" },
                                    DPLAppLinksVersionKey: @"1.0",
                                    DPLAppLinksUserAgentKey: @"Derp 1.0",
                                    DPLAppLinksReferrerAppLinkKey: @{
                                            DPLAppLinksReferrerTargetURLKey: @"http://example.com/docs",
                                            DPLAppLinksReferrerURLKey: @"example://docs",
                                            DPLAppLinksReferrerAppNameKey: @"Derp" } };
            
            expect(link.appLinkData).to.equal(data);
        });
        
        xit(@"generates a valid App Link URL", ^{
            
            NSString *URLString = @"dpl://applinks?al_applink_data=%7B%22target_url%22%3A%22http%3A%5C%2F%5C%2Fapplinks.org%5C%2Fdocumentation%22%2C%22extras%22%3A%7B%22foo%22%3A%22bar%22%7D%2C%22user_agent%22%3A%22Derp%201.0%22%2C%22referer_app_link%22%3A%7B%22target_url%22%3A%22http%3A%5C%2F%5C%2Fexample.com%5C%2Fdocs%22%2C%22url%22%3A%22example%3A%5C%2F%5C%2Fdocs%22%2C%22app_name%22%3A%22Derp%22%7D%2C%22version%22%3A%221.0%22%7D";
            NSURL *appLinkURL = [NSURL URLWithString:URLString];
            
            expect(link.URL).to.equal(appLinkURL);
        });
    });

    context(@"with nil input data", ^{
        
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://applinks"];
        link.targetURL           = nil;
        link.extras              = nil;
        link.userAgent           = nil;
        link.referrerTargetURL   = nil;
        link.referrerURL         = nil;
        link.referrerAppName     = nil;
        
        it(@"creates an empty App Links structure", ^{
            
            NSDictionary *data = @{ DPLAppLinksTargetURLKey: @"",
                                    DPLAppLinksExtrasKey: @{ },
                                    DPLAppLinksVersionKey: @"1.0",
                                    DPLAppLinksUserAgentKey: @"",
                                    DPLAppLinksReferrerAppLinkKey: @{
                                            DPLAppLinksReferrerTargetURLKey: @"",
                                            DPLAppLinksReferrerURLKey: @"",
                                            DPLAppLinksReferrerAppNameKey: @"" } };
            
            expect(link.appLinkData).to.equal(data);
        });
        
        xit(@"generates an empty App Link URL", ^{
            NSString *URLString = @"dpl://applinks?al_applink_data=%7B%22target_url%22%3A%22%22%2C%22extras%22%3A%7B%7D%2C%22user_agent%22%3A%22%22%2C%22referer_app_link%22%3A%7B%22target_url%22%3A%22%22%2C%22url%22%3A%22%22%2C%22app_name%22%3A%22%22%7D%2C%22version%22%3A%221.0%22%7D";
            NSURL *appLinkURL = [NSURL URLWithString:URLString];
            
            expect(link.URL).to.equal(appLinkURL);
        });
    });
});

SpecEnd
