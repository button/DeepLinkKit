@import Foundation;


/// Key to get query parameters dictionary from the result of `- (NSDictionary *)DPL_parametersDictionaryAndOrderFromQueryString'
static NSString * const DPL_ParametersValuesDictionaryKey = @"DPL_ParametersValuesDictionaryKey";


// Key to get query ordered parameter names set from the result of `- (NSDictionary *)DPL_parametersDictionaryAndOrderFromQueryString'
static NSString * const DPL_OrderedParameterNamesSetKey = @"DPL_OrderedParameterNamesSetKey";


@interface NSString (DPLQuery)



///---------------------------
/// @name Query String Parsing
///---------------------------


/**
 Returns a percent encoded query string from a dictionary of parameters.
 @param parameters A dictionary of parameters.
 */
+ (NSString *)DPL_queryStringWithParameters:(NSDictionary *)parameters;


/**
 Returns a percent encoded query string from a dictionary of parameters.
 @param parameters A dictionary of parameters.
 @param orderedParameterNames An ordered set of parameter names.
 @note if number of parameters in `orderedParameterNames' is less then number of keys in `parameters'
       or `orderedParameterNames' is nill then parameters are sorted using `localizedCaseInsensitiveCompare:'.
 @return String containing parameters.
 */
+ (NSString *)DPL_queryStringWithParameters:(NSDictionary *)parameters orderedParameterNames:(NSOrderedSet *)orderedParameterNames;


/**
 Parses the receiver (when formatted as a query string) into an NSDictionary.
 @return A NSDictionary which contains two key-value pairs:
    - NSDictionary of parameters keys and values parsed from the receiver (DPL_ParametersValuesDictionaryKey)
    - NSOrderedSet of ordered parameter names parsed from the receiver (DPL_OrderedParameterNamesSetKey).
 */
- (NSDictionary *)DPL_parametersDictionaryAndOrderFromQueryString;



///-------------------
/// @name URL Encoding
///-------------------


/**
 Adds all percent escapes necessary to convert the receiver into a legal URL string including the following: !*'();:@&=+$,/?%#[]
 @param encoding The encoding for determining the correct percent escapes (returning nil if the given encoding cannot encode a particular character).
 */
- (NSString *)DPL_stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding;


/**
 Replaces all percent escapes with the matching characters as determined by the given encoding. Returns nil if the transformation is not possible.
 @param encoding The encoding for determining characters matching the percent escapes.
 */
- (NSString *)DPL_stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding;

@end
