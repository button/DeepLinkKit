#import "DPLDeepLink.h"

/**
 A mutable deep link for constructing deep links.
 */
@interface DPLMutableDeepLink : DPLDeepLink <NSCopying, NSMutableCopying>

/// The scheme URL component, or nil if not present.
@property (nonatomic, copy) NSString *scheme;


/// The host URL subcomponent, or nil if not present.
@property (nonatomic, copy) NSString *host;


/// The path URL component, or nil if not present.
@property (nonatomic, copy) NSString *path;


/// The query URL component as a mutable dictionary.
@property (nonatomic, copy, readwrite) NSMutableDictionary *queryParameters;


/// A URL object derived from the mutable deep link components.
@property (nonatomic, copy, readonly) NSURL *URL;


/**
 Initializes a DPLMutableDeepLink with a URL string. 
 @param URLString The URL string for the deep link.
 @note If the URLString is malformed, nil is returned.
 */
- (instancetype)initWithString:(NSString *)URLString;

@end
