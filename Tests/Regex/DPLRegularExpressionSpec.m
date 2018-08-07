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
    
    it(@"should NOT match named components with regex that does not match", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:do([a-zA-Z]+)/:this([0-9]+)/and/:that([a-zA-Z]+)"];
        
        DPLMatchResult *matchResult = [expression matchResultForString:@"/hello/dovalue/thisvalue/and/thatvalue"];
        expect(matchResult.match).to.beFalsy();
    });

    it(@"should match named components without regex but case insensitive", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:do/:this/and/:that"];

        DPLMatchResult *matchResult = [expression matchResultForString:@"/hEllo/dOvalue/Thisvalue/and/THATvalue"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"do": @"dOvalue",
                                                        @"this": @"Thisvalue",
                                                        @"that": @"THATvalue" });
    });

    it(@"should match named components with regex case insensitive", ^{
        DPLRegularExpression *expression = [DPLRegularExpression regularExpressionWithPattern:@"/hello/:do([a-zA-Z]+)/:this([a-zA-Z]+)/and/:that([a-zA-Z]+)"];

        DPLMatchResult *matchResult = [expression matchResultForString:@"/hEllo/dOvalue/Thisvalue/and/THATvalue"];
        expect(matchResult.match).to.beTruthy();
        expect(matchResult.namedProperties).to.equal(@{ @"do": @"dOvalue",
                                                        @"this": @"Thisvalue",
                                                        @"that": @"THATvalue" });
    });
});

SpecEnd
