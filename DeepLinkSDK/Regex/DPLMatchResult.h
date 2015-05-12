#import <Foundation/Foundation.h>

@interface DPLMatchResult : NSObject

@property (nonatomic, assign, getter=isMatch) BOOL match;
@property (nonatomic, strong) NSDictionary *namedProperties;

@end
