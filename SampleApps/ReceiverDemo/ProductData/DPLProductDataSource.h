#import <UIKit/UIKit.h>

@class DPLProduct;

@interface DPLProductDataSource : NSObject <UITableViewDataSource>

- (DPLProduct *)productWithSku:(NSString *)sku;

- (DPLProduct *)productAtIndexPath:(NSIndexPath *)indexPath;

@end
