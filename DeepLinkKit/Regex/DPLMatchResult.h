@import Foundation;

@interface DPLMatchResult : NSObject

@property (nonatomic, assign, getter=isMatch) BOOL match;
@property (nonatomic, strong, nullable) NSDictionary *namedProperties;

@end
