#import "DLCActionsViewController.h"
#import "DLCActionDataSource.h"
#import "DLCDemoAction.h"

@interface DLCActionsViewController ()

@property (nonatomic, strong) DLCActionDataSource *dataSource;

@end


@implementation DLCActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource           = [[DLCActionDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLCDemoAction *action = [self.dataSource actionAtIndexPath:indexPath];
    if (action) {
        [[UIApplication sharedApplication] openURL:action.actionURL];
    }
}

@end
