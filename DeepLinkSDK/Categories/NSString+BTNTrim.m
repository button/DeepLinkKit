#import "NSString+BTNTrim.h"

@implementation NSString (BTNTrim)

- (NSString *)BTN_trimPath {
    NSMutableCharacterSet *trimCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"/"];
    [trimCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self stringByTrimmingCharactersInSet:trimCharacterSet];
}

@end
