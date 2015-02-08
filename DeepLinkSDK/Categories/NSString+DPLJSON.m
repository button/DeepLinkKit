#import "NSString+DPLJSON.h"

@implementation NSString (DPLJSON)

+ (NSString *)DPL_stringWithJSONObject:(id)JSONObject {
    return [self DPL_stringWithJSONObject:JSONObject error:nil];
}


+ (NSString *)DPL_stringWithJSONObject:(id)JSONObject error:(NSError *__autoreleasing *)error {
    NSString *JSONString;
    
    if ([NSJSONSerialization isValidJSONObject:JSONObject]) {
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONObject options:0 error:error];
        JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    }
    
    return JSONString;
}


- (id)DPL_decodedJSONObject {
    return [self DPL_decodedJSONObjectWithError:nil];
}


- (id)DPL_decodedJSONObjectWithError:(NSError *__autoreleasing *)error {
    NSData *JSONData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:error];
    return JSONObject;
}

@end
