#import "DPLSerializableObject.h"

@implementation DPLSerializableObject

+ (BOOL)canInitWithDictionary:(NSDictionary *)dictionary {
    return [dictionary isKindOfClass:[NSDictionary class]] && dictionary[@"some_id"];
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (![[self class] canInitWithDictionary:dictionary]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        [self updateWithRepresentation:dictionary];
    }
    
    return self;
}


- (void)updateWithRepresentation:(NSDictionary *)dictionary {
    self.someID      = dictionary[@"some_id"]     ?: self.someID;
    self.someString  = dictionary[@"some_string"] ?: self.someString;
    self.someURL     = [NSURL URLWithString:dictionary[@"some_url"]] ?: self.someURL;
   
    if (dictionary[@"some_int"]) {
        self.someInteger = [dictionary[@"some_int"] integerValue];
    }
}


- (NSDictionary *)dictionaryRepresentation {
    return @{ @"some_id":     self.someID     ?: @"",
              @"some_string": self.someString ?: @"",
              @"some_url":    self.someURL.absoluteString ?: @"",
              @"some_int":    @(self.someInteger) };
}

@end
