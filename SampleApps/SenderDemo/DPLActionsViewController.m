#import "DPLActionsViewController.h"
#import "DPLActionDataSource.h"
#import "DPLDemoAction.h"

@interface DPLActionsViewController ()

@property (nonatomic, strong) DPLActionDataSource *dataSource;

@end


@implementation DPLActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource           = [[DPLActionDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DPLDemoAction *action = [self.dataSource actionAtIndexPath:indexPath];
    if (action) {
        [[UIApplication sharedApplication] openURL:action.actionURL];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
