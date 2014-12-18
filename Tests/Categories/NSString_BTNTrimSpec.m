#import "Specta.h"
#import "NSString+BTNTrim.h"

SpecBegin(NSString_BTNTrim)

describe(@"Trimming a URL Path", ^{
    
    it(@"trims whitespace, newlines, and forward slashes", ^{
        expect([@"/foo/bar/ \n" BTN_trimPath]).to.equal(@"foo/bar");
    });
    
    it(@"does not remove whitespace, newlines, and forward slashes within a string", ^{
        expect([@"foo/ \n bar" BTN_trimPath]).to.equal(@"foo/ \n bar");
    });
});

SpecEnd
