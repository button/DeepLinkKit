#import "DPLProduct.h"

@implementation DPLProduct

+ (instancetype)productWithName:(NSString *)name price:(NSInteger)price sku:(NSString *)sku  count:(NSInteger)count{
    DPLProduct *product = [[self alloc] initWithName:name price:price sku:sku count:count];
    return product;
}


- (instancetype)initWithName:(NSString *)name price:(NSInteger)price sku:(NSString *)sku  count:(NSInteger)count{
    self   = [super init];
    
    _name  = name;
    _price = price;
    _sku   = sku;
    _count = count;
    
    return self;
}

@end
