#import "DPLProductDataSource.h"
#import "DPLProduct.h"

@interface DPLProductDataSource ()

@property (nonatomic, strong) NSArray *products;

@end


@implementation DPLProductDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _products = @[[DPLProduct productWithName:@"Southern Tier Pumking Ale"         price:799  sku:@"93127"],
                      [DPLProduct productWithName:@"Samuel Adams Winter Lager"         price:1399 sku:@"99542"],
                      [DPLProduct productWithName:@"Sierra Nevada Celebration Ale"     price:799  sku:@"93612"],
                      [DPLProduct productWithName:@"Anchor Christmas Ale"              price:1199 sku:@"93522"],
                      [DPLProduct productWithName:@"Woodchuck Pumpkin Private Reserve" price:1199 sku:@"93632"],
                      [DPLProduct productWithName:@"Lagunitas Brown Shugga'"           price:1099 sku:@"93742"],
                      [DPLProduct productWithName:@"Dogfish Head Festina Peche"        price:899  sku:@"93642"],
                      [DPLProduct productWithName:@"Shiner Oktoberfest"                price:899  sku:@"93598"],
                      [DPLProduct productWithName:@"Magic Hat Variety Winterland"      price:1299 sku:@"93312"],
                      [DPLProduct productWithName:@"Blue Moon Winter Abbey Ale"        price:849  sku:@"93648"]];
    }
    return self;
}


- (DPLProduct *)productWithSku:(NSString *)sku {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sku == %@", sku];
    return [[self.products filteredArrayUsingPredicate:predicate] firstObject];
}


- (DPLProduct *)productAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < self.products.count) ? self.products[indexPath.row] : nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"product-cell" forIndexPath:indexPath];
    DPLProduct *product   = self.products[indexPath.row];
    
    cell.textLabel.text       = product.name;
    cell.detailTextLabel.text = [@(product.price / 100.0) stringValue];
    
    return cell;
}

@end
