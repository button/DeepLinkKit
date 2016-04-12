#import "DPLMutableDeepLink.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLQuery.h"

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

    NSArray       *arr = @[ @{ @"baz": @"qux" }, @"Derp" ];
    NSDictionary *dict = @{ @"foo": @"bar", @"arr": arr };

    it(@"generates a serialized encoded URL representation", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com/here?url=dpl://dpl.com/there"];
        expect(link.URL.absoluteString).to.equal(@"dpl://dpl.com/here?url=dpl%3A%2F%2Fdpl.com%2Fthere");
    });
    
    
    it(@"serializes dictionary parameters as string encoded JSON", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
        link.queryParameters[@"data"] = dict;
        
        DPLDeepLink *deepLink = [[DPLDeepLink alloc] initWithURL:link.URL];
        expect(deepLink.queryParameters[@"data"]).to.equal(dict);
    });
    
    it(@"serializes array parameters as string encoded JSON", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
        link.queryParameters[@"data"] = arr;
        
        DPLDeepLink *deepLink = [[DPLDeepLink alloc] initWithURL:link.URL];
        expect(deepLink.queryParameters[@"data"]).to.equal(arr);
    });
});


describe(@"Re-serialization", ^{

    it (@"should preserve the parameter order after reserialization, two arrays, case 1", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.com?liquors[]=vodka&liquors[]=whiskey&beers[]=stout&beers[]=ale"];
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:url.absoluteString];
        NSString *query = [link.URL.query DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(query).to.equal(@"liquors[]=vodka&liquors[]=whiskey&beers[]=stout&beers[]=ale");
    });

    it (@"should preserve the parameter order after reserialization, two arrays, case 2", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.com?beers[]=stout&beers[]=ale&liquors[]=vodka&liquors[]=whiskey"];
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:url.absoluteString];
        NSString *query = [link.URL.query DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(query).to.equal(@"beers[]=stout&beers[]=ale&liquors[]=vodka&liquors[]=whiskey");
    });

    it (@"should preserve the parameter order after reserialization, one array and one empty parameter, case 1", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.com?beers[]=stout&beers[]=ale&noliquor"];
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:url.absoluteString];
        NSString *query = [link.URL.query DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(query).to.equal(@"beers[]=stout&beers[]=ale&noliquor");
    });

    it (@"should preserve the parameter order after reserialization, one array and one empty parameter, case 2", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.com?noliquor&beers[]=stout&beers[]=ale"];
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:url.absoluteString];
        NSString *query = [link.URL.query DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(query).to.equal(@"noliquor&beers[]=stout&beers[]=ale");
    });

    it (@"should preserve the parameter order after reserialization, two not empty string parameters, case 1", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.com?foo=bar&here=there"];
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:url.absoluteString];
        NSString *query = [link.URL.query DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(query).to.equal(@"foo=bar&here=there");
    });

    it (@"should preserve the parameter order after reserialization, two not empty string parameters, case 2", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.com?here=there&foo=bar"];
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:url.absoluteString];
        NSString *query = [link.URL.query DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(query).to.equal(@"here=there&foo=bar");
    });

});


describe(@"Mutating Deep Links", ^{
    
    it(@"allows changing the query params", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com/here?foo=bar"];
        link.queryParameters[@"foo"] = @"baz";
        link.queryParameters[@"id"] = @"abc123";
        expect(link.URL.absoluteString).to.equal(@"dpl://dpl.com/here?foo=baz&id=abc123");
    });

    it(@"allows changing the query param from array to string", ^{
        NSString *urlString = [[NSURL URLWithString:@"dpl://dpl.com/here?foo[]=bar&foo[]=baz"] absoluteString];
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:urlString];
        link.queryParameters[@"foo"] = @"qux";
        expect(link.URL.absoluteString).to.equal(@"dpl://dpl.com/here?foo=qux");
    });
    
    it(@"allows setting query params when there are none to start", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
        link.queryParameters[@"id"] = @"abc123";
        expect(link.URL.absoluteString).to.equal(@"dpl://dpl.com?id=abc123");
        expect(link.orderedParameterNames).to.haveCountOf(0);
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
    
    it(@"preserves key only query items", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"seamlessapp://menu?293147"];
        expect(link.queryParameters[@"293147"]).to.equal(@"");
        expect(link.URL.absoluteString).to.equal(@"seamlessapp://menu?293147");
    });

});


describe(@"Object Subscripting", ^{
    
    it(@"allows setting query params via object subscripting", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
        link[@"foo"] = @"bar";
        expect(link.queryParameters[@"foo"]).to.equal(@"bar");
        expect(link.orderedParameterNames).to.haveCountOf(1);
        expect(link.orderedParameterNames).to.contain(@"foo");
    });
    
    it(@"allows getting query params via object subscripting", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com?foo=bar"];
        expect(link[@"foo"]).to.equal(@"bar");
        expect(link.orderedParameterNames).to.haveCountOf(1);
        expect(link.orderedParameterNames).to.contain(@"foo");
    });

    it(@"allows setting array query params via object subscripting", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
        link[@"foo"] = @[ @"bar", @"baz" ];
        expect(link.queryParameters[@"foo"]).to.equal(@[ @"bar", @"baz" ]);
        expect(link.orderedParameterNames).to.haveCountOf(1);
        expect(link.orderedParameterNames).to.contain(@"foo");
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
        expect(link.orderedParameterNames).to.equal(mutableLink.orderedParameterNames);
        expect(link.callbackURL.absoluteString).to.equal(@"dpl://back");
    });
    
    it(@"immutable copy includes route parameters", ^{
        NSString *URLString = @"dpl://dpl.com/here?foo=bar&dpl_callback_url=dpl://back";
        DPLMutableDeepLink *mutableLink = [[DPLMutableDeepLink alloc] initWithString:URLString];
        mutableLink.routeParameters = @{ @"where": @"here" };
        DPLDeepLink *link = [mutableLink copy];
        expect(link.routeParameters).to.equal(mutableLink.routeParameters);
    });
    
    it(@"returns a mutable deep link via mutableCopy", ^{
        NSString *URLString = @"dpl://dpl.com/here?foo=bar&dpl_callback_url=dpl://back";
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] initWithString:URLString];
        DPLMutableDeepLink *link2 = [link1 mutableCopy];
        
        expect(link2).toNot.beNil();
        expect(link2.scheme).to.equal(link1.scheme);
        expect(link2.host).to.equal(link1.host);
        expect(link2.path).to.equal(link1.path);
        expect(link2.queryParameters).to.equal(link1.queryParameters);
        expect(link2.orderedParameterNames).to.equal(link2.orderedParameterNames);
        expect(link2.URL).to.equal(link1.URL);
    });
    
    it(@"mutable copy includes route parameters", ^{
        NSString *URLString = @"dpl://dpl.com/here?foo=bar&dpl_callback_url=dpl://back";
        DPLMutableDeepLink *mutableLink = [[DPLMutableDeepLink alloc] initWithString:URLString];
        mutableLink.routeParameters = @{ @"where": @"here" };
        DPLDeepLink *link = [mutableLink mutableCopy];
        expect(link.routeParameters).to.equal(mutableLink.routeParameters);
    });

});


describe(@"Equality", ^{
    
    NSString *urlString1 = @"dpl://dpl.io/ride/abc123?partner=uber";
    NSString *urlString2 = @"dpl://dpl.io/book/def456?partner=airbnb";
    
    it(@"two identical deeps links are equal", ^{
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] initWithString:urlString1];
        DPLMutableDeepLink *link2 = [[DPLMutableDeepLink alloc] initWithString:urlString1];
        
        expect(link1).to.equal(link2);
    });
    
    it(@"two different deep links are inequal", ^{
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] initWithString:urlString1];
        DPLMutableDeepLink *link2 = [[DPLMutableDeepLink alloc] initWithString:urlString2];
        
        expect(link1).toNot.equal(link2);
    });

    it(@"two identical deep links with array query params are equal", ^{
        NSString *urlString = [[NSURL URLWithString:@"dpl://dpl.io/foo[]=bar&foo[]=baz"] absoluteString];
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] initWithString:urlString];
        DPLMutableDeepLink *link2 = [[DPLMutableDeepLink alloc] initWithString:urlString];

        expect(link1).to.equal(link2);
    });

    it(@"two deep links with array query params (different order) are inequal", ^{
        NSString *urlStringArray1 = [[NSURL URLWithString:@"dpl://dpl.io/foo[]=bar&foo[]=baz"] absoluteString];
        NSString *urlStringArray2 = [[NSURL URLWithString:@"dpl://dpl.io/foo[]=baz&foo[]=bar"] absoluteString];
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] initWithString:urlStringArray1];
        DPLMutableDeepLink *link2 = [[DPLMutableDeepLink alloc] initWithString:urlStringArray2];

        expect(link1).notTo.equal(link2);
    });
    
    it(@"nil is not equal to a deep link", ^{
        DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:urlString1];
        
        expect(link).toNot.equal(nil);
    });
    
    it(@"an empty deep link is not equal to a deep link", ^{
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] initWithString:urlString1];
        DPLMutableDeepLink *link2 = [[DPLMutableDeepLink alloc] init];
        
        expect(link1).toNot.equal(link2);
    });
    
    it(@"two empty deep links are equal", ^{
        DPLMutableDeepLink *link1 = [[DPLMutableDeepLink alloc] init];
        DPLMutableDeepLink *link2 = [[DPLMutableDeepLink alloc] init];
        
        expect(link1).to.equal(link2);
    });

});

SpecEnd
