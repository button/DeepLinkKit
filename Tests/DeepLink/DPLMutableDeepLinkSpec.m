#import "Specta.h"
#import "DPLMutableDeepLink.h"
#import "DPLDeepLink.h"

SpecBegin(DPLMutableDeepLink)

describe(@"Initialization", ^{
    
    it(@"returns a deep link when initialized with a valid URL string", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com/index"];
        expect(link)       .toNot.beNil();
        expect(link.scheme).to.equal(@"dpl");
        expect(link.host)  .to.equal(@"dpl.com");
        expect(link.path)  .to.equal(@"/index");
    });
    
    it(@"sets the query parameters when the URL string contains parameters", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com?foo=bar"];
        expect(link.queryParameters).to.equal(@{ @"foo": @"bar" });
    });
    
    it(@"does not return a deep link when the URL string is invalid", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"derp derp"];
        expect(link).to.beNil();
    });
});


describe(@"Serialization", ^{
    
    it(@"generates a serialized encoded URL representation", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com/here?url=dpl://dpl.com/there"];
        expect(link.URL.absoluteString).to.equal(@"dpl://dpl.com/here?url=dpl%3A%2F%2Fdpl.com%2Fthere");
    });
    
});


describe(@"Mutating Deep Links", ^{
    
    it(@"allows changing the query params", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com/here?foo=bar"];
        link.queryParameters[@"foo"] = @"baz";
        link.queryParameters[@"id"] = @"abc123";
        expect(link.URL.absoluteString).to.equal(@"dpl://dpl.com/here?foo=baz&id=abc123");
    });
    
    it(@"allows changing the scheme", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
        link.scheme = @"btn";
        expect(link.URL.absoluteString).to.equal(@"btn://dpl.com?");
    });
    
    it(@"allows changing the host", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
        link.host = @"usebutton.com";
        expect(link.URL.absoluteString).to.equal(@"dpl://usebutton.com?");
    });
    
    it(@"allows changing the path", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com/here"];
        link.path = @"/path/to/there";
        expect(link.URL.absoluteString).to.equal(@"dpl://dpl.com/path/to/there?");
    });
});


describe(@"Copying", ^{
    
    it(@"returns an immutable deep link via copy", ^{
        NSString *URLString = @"dpl://dpl.com/here?foo=bar&dpl_callback_url=dpl://back";
        DPLMutableDeepLink *mutableLink = [[DPLMutableDeepLink alloc] initWithString:URLString];
        DPLDeepLink *link = [mutableLink copy];
        
        expect(link).toNot.beNil();
        expect(link.URL).to.equal(mutableLink.URL);
        expect(link.queryParameters).to.equal(mutableLink.queryParameters);
        expect(link.callbackURL.absoluteString).to.equal(@"dpl://back");
    });
    
    it(@"returns a mutable deep link via mutableCopy", ^{
        NSString *URLString = @"dpl://dpl.com/here?foo=bar&dpl_callback_url=dpl://back";
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] initWithString:URLString];
        DPLMutableDeepLink *link2 = [link1 mutableCopy];
        
        expect(link2).toNot.beNil();
        expect(link1.scheme).to.equal(link2.scheme);
        expect(link1.host).to.equal(link2.host);
        expect(link1.path).to.equal(link2.path);
        expect(link1.queryParameters).to.equal(link2.queryParameters);
        expect(link1.URL).to.equal(link2.URL);
    });
});

SpecEnd
