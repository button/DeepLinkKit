#import "DPLProductDetailViewController.h"
#import "DPLProductDataSource.h"
#import "DPLProduct.h"

#import <DeepLinkSDK/DPLDeepLink.h>

@interface DPLProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation DPLProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameLabel.text  = self.product.name;
    self.priceLabel.text = [@(self.product.price / 100.0) stringValue];
}


#pragma mark - DPLTargetViewController

- (void)configureWithDeepLink:(DPLDeepLink *)deepLink userInfo:(NSDictionary *)userInfo {
    
    NSString *sku = deepLink.routeParameters[@"sku"];
    
    DPLProductDataSource *dataSource = [[DPLProductDataSource alloc] init];
    self.product = [dataSource productWithSku:sku];
}

@end
