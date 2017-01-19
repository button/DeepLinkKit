#import "DPLActionDataSource.h"
#import "DPLMutableDeepLink.h"
#import "DPLDemoAction.h"

@interface DPLActionDataSource ()

@property (nonatomic, strong) NSArray *actions;

@end


@implementation DPLActionDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _actions = @[[self loadBeersAction],
                     [self loadOktoberfestAction],
                     [self loadProductInventory],
                     [self logHelloWorldAction]];
    }
    return self;
}


- (DPLDemoAction *)actionAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < [self.actions count]) ? self.actions[indexPath.row] : nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"action-cell" forIndexPath:indexPath];
    DPLDemoAction *demoAction = [self actionAtIndexPath:indexPath];
    cell.textLabel.text       = demoAction.actionName;
    return cell;
}


#pragma mark - Action Construction

- (DPLDemoAction *)loadBeersAction {
    DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://beers"];
    
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL = link.URL;
    action.actionName = @"Shop: Beers";
    return action;
}


- (DPLDemoAction *)loadOktoberfestAction {
    DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
    link.path = @"/product/93598";
    
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL  = link.URL;
    action.actionName = @"Buy: Shiner Oktoberfest";
    return action;
}

- (DPLDemoAction *)loadProductInventory {
    DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com"];
    link.path = @"/inventory";
    
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL  = link.URL;
    action.actionName = @"Show: Product Inventory";
    return action;
}

- (DPLDemoAction *)logHelloWorldAction {
    DPLMutableDeepLink *link = [[DPLMutableDeepLink alloc] initWithString:@"dpl://dpl.com/say/Hello/World"];
    
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL = link.URL;
    action.actionName = @"Say: “Hello World”";
    return action;
}

@end
