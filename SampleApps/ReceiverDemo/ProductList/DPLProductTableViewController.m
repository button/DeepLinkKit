#import "DPLProductTableViewController.h"
#import "DPLProductDetailViewController.h"
#import "DPLProductDataSource.h"

@interface DPLProductTableViewController ()

@property (nonatomic, strong) DPLProductDataSource *dataSource;

@end


@implementation DPLProductTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[DPLProductDataSource alloc] initWithSourceType:DPLProductDataSourceTypePrice];
    self.tableView.dataSource = self.dataSource;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[DPLProductDetailViewController class]] &&
        [sender isKindOfClass:[UITableViewCell class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        DPLProductDetailViewController *controller = segue.destinationViewController;
        controller.product = [self.dataSource productAtIndexPath:indexPath];
    }
}

@end
