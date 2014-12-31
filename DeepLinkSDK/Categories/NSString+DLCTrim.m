#import "NSString+DLCTrim.h"

@implementation NSString (DLCTrim)

- (NSString *)DLC_trimPath {
    NSMutableCharacterSet *trimCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"/"];
    [trimCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self stringByTrimmingCharactersInSet:trimCharacterSet];
}

@end
