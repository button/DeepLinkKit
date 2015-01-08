#import <Foundation/Foundation.h>

@interface DPLProduct : NSObject

@property (nonatomic, copy,   readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger price;
@property (nonatomic, copy,   readonly) NSString  *sku;

+ (instancetype)productWithName:(NSString *)name price:(NSInteger)price sku:(NSString *)sku;

@end
