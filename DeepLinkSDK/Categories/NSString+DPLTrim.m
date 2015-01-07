#import "NSString+DPLTrim.h"

@implementation NSString (DPLTrim)

- (NSString *)DPL_trimPath {
    NSMutableCharacterSet *trimCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"/"];
    [trimCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self stringByTrimmingCharactersInSet:trimCharacterSet];
}

@end
