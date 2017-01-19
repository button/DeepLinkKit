#import "DPLInventoryTableViewController.h"
#import "DPLProductDataSource.h"


@interface DPLInventoryTableViewController ()

@property (nonatomic, strong) DPLProductDataSource *dataSource;

@end

@implementation DPLInventoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[DPLProductDataSource alloc] initWithSourceType:DPLProductDataSourceTypeCount];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - DPLTargetViewController

- (void)configureWithDeepLink:(DPLDeepLink *)deepLink {
    //No Op
}

@end



