#import "Specta.h"
#import "NSString+BTNJSON.h"

SpecBegin(NSString_BTNJSON)

NSDictionary *JSONObject = @{ @"a": @"b", @"c": @{ @"d": @"f" }, @"g": @[ @"h", @"i" ]};
NSString     *JSONString = @"{\"a\":\"b\",\"c\":{\"d\":\"f\"},\"g\":[\"h\",\"i\"]}";

NSDictionary *invalidJSONObject = @{ @"a": @"b", @"a": @"c", @"c": @(0./0.)};
NSString     *invalidJSONString = @"{\"a\":\"b\",\"c\":\"d\":\"f\"},\"g\":[\"h\",\"i\"]}";

describe(@"Encoding JSON to a String", ^{
    
    it(@"returns a JSON encoded string", ^{
        NSString *string = [NSString BTN_stringWithJSONObject:JSONObject];
        expect(string).toNot.beNil();
        expect(string).to.equal(JSONString);
    });
    
    it(@"returns nil when JSON is invalid", ^{
        NSString *string = [NSString BTN_stringWithJSONObject:invalidJSONObject];
        expect(string).to.beNil();
    });
});


describe(@"Decoding a JSON string", ^{
    
    it(@"returns a JSON object", ^{
        id object = [JSONString BTN_JSONObject];
        expect(object).toNot.beNil();
        expect(object).to.equal(JSONObject);
    });

    it(@"returns nil when JSON is invalid", ^{
        id object = [invalidJSONString BTN_JSONObject];
        expect(object).to.beNil();
    });
    
    it(@"returns nil with an error when JSON is invalid", ^{
        NSError *error;
        id object = [invalidJSONString BTN_JSONObjectWithError:&error];
        expect(object).to.beNil();
        expect(error).toNot.beNil();
    });
});

SpecEnd
