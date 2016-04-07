#import "DPLRegularExpression.h"

SpecBegin(DPLRegularExpression)

describe(@"Matching named components", ^{
    
    it(@"should match named components without regex", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:do/:this/and/:that"];
        
        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/dovalue/thisvalue/and/thatvalue"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"do": @"dovalue",
                                                        @"this": @"thisvalue",
                                                        @"that": @"thatvalue" });
    });
    
    it(@"should match named components with regex", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:do([a-zA-Z]+)/:this([a-zA-Z]+)/and/:that([a-zA-Z]+)"];
        
        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/dovalue/thisvalue/and/thatvalue"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"do": @"dovalue",
                                                        @"this": @"thisvalue",
                                                        @"that": @"thatvalue" });
    });
    
    it(@"should match a mixture of with and without regex", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:do/:this([a-zA-Z]+)/and/:that([a-zA-Z]+)"];
        
        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/dovalue/thisvalue/and/thatvalue"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"do": @"dovalue",
                                                        @"this": @"thisvalue",
                                                        @"that": @"thatvalue" });
    });

    it(@"should match an array", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:list"];

        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/list[]=item1&list[]=item2"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"list": @[ @"item1", @"item2" ] });
    });

    it(@"should match an parameters with array literal in the middle of a key", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:list"];

        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/li[]st"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"list": @"li[]st" });
    });

    it(@"should match an empty array", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:list"];

        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/list[]"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"list": @[ ] });
    });

    it(@"should NOT match named components with regex that does not match", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:do([a-zA-Z]+)/:this([0-9]+)/and/:that([a-zA-Z]+)"];
        
        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/dovalue/thisvalue/and/thatvalue"];
        expect(matchResult.match).to.beFalsy();
    });
    
});

SpecEnd
