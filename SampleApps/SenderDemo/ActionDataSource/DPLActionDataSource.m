#import "DPLActionDataSource.h"
#import "NSString+DPLQuery.h"
#import "NSString+DPLJSON.h"
#import "DPLDeepLink.h"
#import "DPLDemoAction.h"

@interface DPLActionDataSource ()

@property (nonatomic, strong) NSArray *actions;

@end


@implementation DPLActionDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _actions = @[[self loadOktoberfestAction],
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

- (DPLDemoAction *)loadOktoberfestAction {
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL  = [NSURL URLWithString:@"dpl://dpl.com/product/93598"];
    action.actionName = @"Buy Shiner Oktoberfest";
    return action;
}


- (DPLDemoAction *)logHelloWorldAction {
    NSDictionary *payload = @{ DPLAppLinkTargetURLKey: @"http://dpl.button.com/say/Congratulations/Button%20Team" };
    
    NSString *payloadString = [[NSString DPL_stringWithJSONObject:payload] DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"dpl://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL = deepLinkURL;
    action.actionName = @"Today's Demo";
    return action;
}

@end
