#import <Foundation/Foundation.h>

@interface NSString (DLCTrim)

/// Trims whitespace, new lines, and forward slashes from the receiver.
- (NSString *)DLC_trimPath;

@end
