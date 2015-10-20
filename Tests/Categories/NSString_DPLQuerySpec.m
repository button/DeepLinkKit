#import "Specta.h"
#import "NSString+DPLQuery.h"

SpecBegin(NSString_DPLQuery)

NSString *plainTestString   = @"plain";
NSString *decodedTestString = @"!*'();:@&=+$,/?%#[] ";
NSString *encodedTestString = @"%21%2A%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D%20";


describe(@"Percent Encoding", ^{
    
    it(@"encodes an extended set of illegal url characters", ^{
        NSString *encodedString = [decodedTestString DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(encodedString).to.equal(encodedTestString);
    });
    
    it(@"does not encode a string without illegal characters", ^{
        NSString *encodedString = [plainTestString DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(encodedString).to.equal(plainTestString);
    });
});


describe(@"Percent Decoding", ^{
    
    it(@"decodes a string with escaped url characters", ^{
        NSString *decodedString = [encodedTestString DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(decodedString).to.equal(decodedTestString);
    });
    
    it(@"does not decode a string without escaped characters", ^{
        NSString *decodedString = [plainTestString DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        expect(decodedString).to.equal(plainTestString);
    });
});


describe(@"Dictionary to Query String", ^{
    
    it(@"should construct a query string from a dictionary", ^{
        NSDictionary *params = @{ @"one": @1, @"two": @2 };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"one=1&two=2");
    });
    
    it(@"serializes keys with empty value", ^{
        NSDictionary *params = @{ @"one": @"", @"two": @2 };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"one&two=2");
    });
    
    it(@"should percent encode parameters from dictionary into the query string", ^{
        NSDictionary *params = @{ @"one": @"a one", @"two": @"http://www.example.com?foo=bar" };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"one=a%20one&two=http%3A%2F%2Fwww.example.com%3Ffoo%3Dbar");
    });
});


describe(@"Query String to Dictionary", ^{
   
    it(@"should parse a valid query string into a dictionary", ^{
        NSString *query = @"one=1&two=2";
        NSDictionary *params = [query DPL_parametersFromQueryString];
        expect(params[@"one"]).to.equal(@"1");
        expect(params[@"two"]).to.equal(@"2");
    });
    
    it(@"does NOT discard incomplete pairs in a query string", ^{
        NSString *query = @"one=1&two&three=3";
        NSDictionary *params = [query DPL_parametersFromQueryString];
        expect(params[@"one"]).to.equal(@"1");
        expect(params[@"two"]).to.equal(@"");
        expect(params[@"three"]).to.equal(@"3");
    });
    
    it(@"should decode query parameters into a dictionary", ^{
        NSString *query = @"one=a%20one&two=http%3A%2F%2Fwww.example.com%3Ffoo%3Dbar";
        NSDictionary *params = [query DPL_parametersFromQueryString];
        expect(params[@"one"]).to.equal(@"a one");
        expect(params[@"two"]).to.equal(@"http://www.example.com?foo=bar");
    });
});

SpecEnd
