#import "NSString+DPLQuery.h"

@interface NSString (DPLQuery_Private)



///---------------------
/// @name Array Literals
///---------------------


/**
 Checks if string ends with array literal ('[]')
 @return YES if string ends with '[]', NO otherwise
 */
- (BOOL)DPL_containsArrayLiteral;


/**
 Removes array literal ('[]') from the string
 @return String without array literal ('[]')
 */
- (NSString *)DPL_stringByRemovingArrayLiteral;

@end