#import <UIKit/UIKit.h>

@class DPLProduct;

typedef NS_ENUM(NSInteger, DPLProductDataSourceType) {
    DPLProductDataSourceTypePrice,
    DPLProductDataSourceTypeCount
};

@interface DPLProductDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithSourceType:(DPLProductDataSourceType)sourceType;

@property (nonatomic, assign, readonly) DPLProductDataSourceType sourceType;

- (DPLProduct *)productWithSku:(NSString *)sku;

- (DPLProduct *)productAtIndexPath:(NSIndexPath *)indexPath;

@end
