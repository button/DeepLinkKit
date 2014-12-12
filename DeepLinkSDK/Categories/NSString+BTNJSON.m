#import "NSString+BTNJSON.h"

@implementation NSString (BTNJSON)

+ (NSString *)BTN_stringWithJSONObject:(id)JSONObject {
    return [self BTN_stringWithJSONObject:JSONObject error:nil];
}


+ (NSString *)BTN_stringWithJSONObject:(id)JSONObject error:(NSError *__autoreleasing *)error {
    NSString *JSONString;
    
    if ([NSJSONSerialization isValidJSONObject:JSONObject]) {
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONObject options:0 error:error];
        JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    }
    
    return JSONString;
}

- (id)BTN_JSONObject {
    return [self BTN_JSONObjectWithError:nil];
}


- (id)BTN_JSONObjectWithError:(NSError *__autoreleasing *)error {
    NSData *JSONData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:error];
    return JSONObject;
}

@end
