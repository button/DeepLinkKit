#import "NSObject+DPLJSONObject.h"
#import "DPLSerializable.h"

@implementation NSObject (DPLJSONObject)

- (id)DPL_JSONObject {
    if ([self conformsToProtocol:@protocol(DPLSerializable)]
        && [self respondsToSelector:@selector(dictionaryRepresentation)]) {
        
        return [(id <DPLSerializable>)self dictionaryRepresentation];
    }
    
    return self.description;
}

@end


@implementation NSNumber (DPLJSONObject)

- (id)DPL_JSONObject {
    if (isnan(self.doubleValue)) {
        return @"nan";
    }
    else if (isinf(self.doubleValue)) {
        return self.doubleValue < 0 ? @"-inf" : @"inf";
    }
    
    return self;
}

@end


@implementation NSDate (DPLJSONObject)

- (id)DPL_JSONObject {
    return @([self timeIntervalSinceReferenceDate]);
}

@end


@implementation NSArray (DPLJSONObject)

- (id)DPL_JSONObject {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return self;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id value in self) {
        if (![value isEqual:[NSNull null]]) {
            [mutableArray addObject:[value DPL_JSONObject]];
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

@end


@implementation NSDictionary (DPLJSONObject)

- (id)DPL_JSONObject {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return self;
    }
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:self];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if (![key isKindOfClass:[NSString class]] || [value isEqual:[NSNull null]]) {
            [mutableDictionary removeObjectForKey:key];
        }
        else {
            mutableDictionary[key] = [value DPL_JSONObject];
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

@end
