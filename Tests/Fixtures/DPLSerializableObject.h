#import "DPLSerializable.h"

@interface DPLSerializableObject : NSObject <DPLSerializable>

@property (nonatomic,   copy) NSString  *someID;
@property (nonatomic,   copy) NSString  *someString;
@property (nonatomic,   copy) NSURL     *someURL;
@property (nonatomic, assign) NSInteger someInteger;

@end
