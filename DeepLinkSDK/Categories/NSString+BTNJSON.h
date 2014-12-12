#import <Foundation/Foundation.h>

@interface NSString (BTNJSON)

/**
 Converts a JSON object into a JSON encoded string.
 @param JSONObject A Foundation object to be converted to JSON.  
 @see NSJSONSerialization
 @return A JSON encoded string or nil if the object is not JSON compatible.
 */
+ (NSString *)BTN_stringWithJSONObject:(id)JSONObject;

/**
 Converts a JSON object into a JSON encoded string.
 @param JSONObject A Foundation object to be converted to JSON.
 @param error An error pointer to be set if an error occurs.
 @return A JSON encoded string or nil if the object is not JSON compatible.
 */
+ (NSString *)BTN_stringWithJSONObject:(id)JSONObject error:(NSError *__autoreleasing *)error;

/**
 Converts a JSON encoded string into a Foundation object (NSDictionary, NSArray).
 @return A Foundation representation of the JSON string.
 */
- (id)BTN_JSONObject;

/**
 Converts a JSON encoded string into a Foundation object (NSDictionary, NSArray).
 @param error An error pointer to be set if an error occurs.
 @return A Foundation representation of the JSON string.
 */
- (id)BTN_JSONObjectWithError:(NSError *__autoreleasing *)error;

@end
