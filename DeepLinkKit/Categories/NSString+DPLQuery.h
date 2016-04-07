@import Foundation;

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
 Parses the receiver (when formatted as a query string) into an NSDictionary.
 @return An NSDictionary of parameters parsed from the receiver.
 */
- (NSDictionary *)DPL_parametersFromQueryString;



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
