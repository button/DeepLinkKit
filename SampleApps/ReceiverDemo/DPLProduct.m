#import "DPLProduct.h"

@implementation DPLProduct

+ (instancetype)productWithName:(NSString *)name price:(NSInteger)price sku:(NSString *)sku {
    DPLProduct *product = [[self alloc] initWithName:name price:price sku:sku];
    return product;
}


- (instancetype)initWithName:(NSString *)name price:(NSInteger)price sku:(NSString *)sku {
    self   = [super init];
    
    _name  = name;
    _price = price;
    _sku   = sku;
    
    return self;
}

@end
