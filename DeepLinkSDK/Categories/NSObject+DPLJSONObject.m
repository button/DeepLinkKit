#import "NSObject+DPLJSONObject.h"

@implementation NSObject (DPLJSONObject)

- (id)DPLJSONObject {
    return self.description;
}

@end


@implementation NSNumber (DPLJSONObject)

- (id)DPLJSONObject {
    if (isnan(self.doubleValue)) {
        return @"nan";
    }
    else if (isinf(self.doubleValue)) {
        return self.doubleValue < 0 ? @"-inf" : @"inf";
    }
    
    return self;
}

@end


@implementation NSArray (DPLJSONObject)

- (id)DPLJSONObject {

    if ([NSJSONSerialization isValidJSONObject:self]) {
        return self;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id value in self) {
        if (![value isEqual:[NSNull null]]) {
            [mutableArray addObject:[value DPLJSONObject]];
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

@end


@implementation NSDictionary (DPLJSONObject)

- (id)DPLJSONObject {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return self;
    }
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:self];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if (![key isKindOfClass:[NSString class]] || [value isEqual:[NSNull null]]) {
            [mutableDictionary removeObjectForKey:key];
        }
        else {
            mutableDictionary[key] = [value DPLJSONObject];
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

@end
