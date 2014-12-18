#import "BTNActionsViewController.h"
#import "BTNActionDataSource.h"
#import "BTNDemoAction.h"

@interface BTNActionsViewController ()

@property (nonatomic, strong) BTNActionDataSource *dataSource;

@end


@implementation BTNActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource           = [[BTNActionDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTNDemoAction *action = [self.dataSource actionAtIndexPath:indexPath];
    if (action) {
        [[UIApplication sharedApplication] openURL:action.actionURL];
    }
}

@end
