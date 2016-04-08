#import "NSString+DPLQuery.h"
#import "NSString+DPLQuery_Private.h"

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

    it(@"should serialize array from dictionary into the query string", ^{
        NSDictionary *params = @{ @"beers": @[ @"stout", @"ale" ] };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"beers[]=stout&beers[]=ale");
    });

    it(@"should serialize empty array from dictionary into the query string", ^{
        NSDictionary *params = @{ @"beers": @[ ] };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"beers[]");
    });

    it(@"should serialize multiple arrays from dictionary into the query string", ^{
        NSDictionary *params = @{ @"beers": @[ @"stout", @"ale" ], @"liquors": @[ @"vodka", @"whiskey" ] };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"beers[]=stout&beers[]=ale&liquors[]=vodka&liquors[]=whiskey");
    });

    it(@"should serialize multiple arrays from dictionary into the query string and preserve order", ^{
        NSDictionary *params = @{ @"liquors": @[ @"vodka", @"whiskey" ], @"beers": @[ @"stout", @"ale" ] };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"beers[]=stout&beers[]=ale&liquors[]=vodka&liquors[]=whiskey");
    });

    it(@"should percent encode parameters from dictionary into the query array", ^{
        NSDictionary *params = @{ @"one": @"a one", @"two": @[ @"http://www.example.com?foo=bar", @"a two" ] };
        NSString *query = [NSString DPL_queryStringWithParameters:params];
        expect(query).to.equal(@"one=a%20one&two[]=http%3A%2F%2Fwww.example.com%3Ffoo%3Dbar&two[]=a%20two");
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

    it(@"should decode array query parameters into an array preserving order", ^{
        NSString *query = @"beers[]=stout&beers[]=ale";
        NSDictionary *params = [query DPL_parametersFromQueryString];
        expect(params[@"beers"]).notTo.beNil;
        expect([params[@"beers"] isKindOfClass:[NSArray class]]).to.beTruthy;
        expect([params[@"beers"] count]).to.equal(2);
        expect(params[@"beers"][0]).to.contain(@"stout");
        expect(params[@"beers"][1]).to.contain(@"ale");
    });

    it(@"should decode mixed arrays query parameters into appropriate arrays preserving order", ^{
        NSString *query = @"beers[]=stout&liquors[]=vodka&beers[]=ale&liquors[]=whiskey";
        NSDictionary *params = [query DPL_parametersFromQueryString];
        expect(params[@"beers"]).notTo.beNil;
        expect(params[@"liquors"]).notTo.beNil;
        expect([params[@"beers"] isKindOfClass:[NSArray class]]).to.beTruthy;
        expect([params[@"liquors"] isKindOfClass:[NSArray class]]).to.beTruthy;
        expect([params[@"beers"] count]).to.equal(2);
        expect([params[@"liquors"] count]).to.equal(2);
        expect(params[@"beers"][0]).to.contain(@"stout");
        expect(params[@"beers"][1]).to.contain(@"ale");
        expect(params[@"liquors"][0]).to.contain(@"vodka");
        expect(params[@"liquors"][1]).to.contain(@"whiskey");
    });

    it (@"should decode empty array in case values were not provided", ^{
        NSString *query = @"beers[]";
        NSDictionary *params = [query DPL_parametersFromQueryString];
        expect(params[@"beers"]).notTo.beNil;
        expect([params[@"beers"] isKindOfClass:[NSArray class]]).to.beTruthy;
        expect([params[@"beers"] count]).to.equal(0);
    });

});

describe(@"Array literals", ^{

    it (@"should return YES in case there's array literal in the key", ^{
        NSString *key = @"beers[]";
        expect([key DPL_containsArrayLiteral]).to.beTruthy;
    });

    it (@"should return NO in case there's no array literal in the key", ^{
        NSString *key = @"beers";
        expect([key DPL_containsArrayLiteral]).to.beFalsy;
    });

    it (@"should return NO in case there's array literal in the middle of the key", ^{
        NSString *key = @"be[]ers";
        expect([key DPL_containsArrayLiteral]).to.beFalsy;
    });

    it (@"should reply YES in case there's array literal in the key", ^{
        NSString *key = @"beers[]";
        expect([key DPL_containsArrayLiteral]).to.beTruthy;
    });

    it (@"should delete array literal at the end of a string", ^{
        NSString *key = @"beers[]";
        expect([key DPL_stringByRemovingArrayLiteral]).to.equal(@"beers");
    });

    it (@"should return the same string if there's no array literal", ^{
        NSString *key = @"beers";
        expect([key DPL_stringByRemovingArrayLiteral]).to.equal(@"beers");
    });

    it (@"should not delete array literal in the middle of a string", ^{
        NSString *key = @"be[]ers";
        expect([key DPL_stringByRemovingArrayLiteral]).to.equal(@"be[]ers");
    });

});

SpecEnd
