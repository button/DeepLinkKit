#import "Specta.h"
#import "NSString+DLCTrim.h"

SpecBegin(NSString_DLCTrim)

describe(@"Trimming a URL Path", ^{
    
    it(@"trims whitespace, newlines, and forward slashes", ^{
        expect([@"/foo/bar/ \n" DLC_trimPath]).to.equal(@"foo/bar");
    });
    
    it(@"does not remove whitespace, newlines, and forward slashes within a string", ^{
        expect([@"foo/ \n bar" DLC_trimPath]).to.equal(@"foo/ \n bar");
    });
});

SpecEnd
