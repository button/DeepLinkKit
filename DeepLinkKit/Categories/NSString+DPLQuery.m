#import "NSString+DPLQuery.h"

@implementation NSString (UBRQuery)

+ (NSString *)DPL_queryStringWithParameters:(NSDictionary *)parameters {
    NSMutableString *query = [NSMutableString string];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *value = [parameters[key] description];
        key   = [key DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        value = [value DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [query appendFormat:@"%@%@=%@", (idx > 0) ? @"&" : @"", key, value];
    }];
    return [query copy];
}


- (NSDictionary *)DPL_parametersFromQueryString {
    NSArray *params = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:[params count]];
    for (NSString *param in params) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if ([pairs count] == 2) {
            NSString *key   = [pairs[0] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [pairs[1] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            paramsDict[key] = value;
        }
    }
    return [paramsDict copy];
}


#pragma mark - URL Encoding/Decoding

- (NSString *)DPL_stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}


- (NSString *)DPL_stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8);
}

@end
