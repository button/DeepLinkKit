#import "NSString+DPLTrim.h"

SpecBegin(NSString_DPLTrim)

describe(@"Trimming a URL Path", ^{
    
    it(@"trims whitespace, newlines, and forward slashes", ^{
        expect([@"/foo/bar/ \n" DPL_trimPath]).to.equal(@"foo/bar");
    });
    
    it(@"does not remove whitespace, newlines, and forward slashes within a string", ^{
        expect([@"foo/ \n bar" DPL_trimPath]).to.equal(@"foo/ \n bar");
    });
});

SpecEnd
