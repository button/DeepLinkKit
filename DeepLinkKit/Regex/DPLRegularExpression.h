@import Foundation;
#import "DPLMatchResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPLRegularExpression : NSRegularExpression

@property (nonatomic, strong) NSArray *groupNames;

+ (instancetype)regularExpressionWithPattern:(NSString *)pattern;

- (DPLMatchResult *)matchResultForString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
