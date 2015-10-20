#import "NSString+DPLQuery.h"

@implementation NSString (UBRQuery)

+ (NSString *)DPL_queryStringWithParameters:(NSDictionary *)parameters {
    NSMutableString *query = [NSMutableString string];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *value = [parameters[key] description];
        key   = [key DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        value = [value DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [query appendFormat:@"%@%@%@%@", (idx > 0) ? @"&" : @"", key, (value.length > 0) ? @"=" : @"", value];
    }];
    return [query copy];
}


- (NSDictionary *)DPL_parametersFromQueryString {
    NSArray *params = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:[params count]];
    for (NSString *param in params) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if (pairs.count == 2) {
            // e.g. ?key=value
            NSString *key   = [pairs[0] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [pairs[1] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            paramsDict[key] = value;
        }
        else if (pairs.count == 1) {
            // e.g. ?key
            NSString *key = [[pairs firstObject] DPL_stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            paramsDict[key] = @"";
        }
    }
    return [paramsDict copy];
}


#pragma mark - URL Encoding/Decoding

- (NSString *)DPL_stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *allowedCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharactersSet];
}


- (NSString *)DPL_stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    return [self stringByRemovingPercentEncoding];
}

@end
