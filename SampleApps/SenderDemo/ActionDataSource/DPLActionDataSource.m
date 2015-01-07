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
        _actions = @[[self logHelloWorldAction],
                     [self changeToRedAction],
                     [self changeToBlueAction],
                     [self changeToGreenAction],
                     [self changeToPurpleAction]];
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

- (DPLDemoAction *)logHelloWorldAction {
    NSDictionary *payload = @{ DPLAppLinkTargetURLKey: @"http://DPL.button.com/say/Congratulations/Button%20Team" };
    
    NSString *payloadString = [[NSString DPL_stringWithJSONObject:payload] DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"DPL://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL = deepLinkURL;
    action.actionName = @"Today's Demo";
    return action;
}


- (DPLDemoAction *)changeToRedAction {
    DPLDemoAction *action = [self actionWithColor:[UIColor redColor]];
    action.actionName = @"Set Receiver Demo red";
    return action;
}


- (DPLDemoAction *)changeToBlueAction {
    DPLDemoAction *action = [self actionWithColor:[UIColor blueColor]];
    action.actionName = @"Set Receiver Demo blue";
    return action;
}


- (DPLDemoAction *)changeToPurpleAction {
    DPLDemoAction *action = [self actionWithColor:[UIColor purpleColor]];
    action.actionName = @"Set Receiver Demo purple";
    return action;
}


- (DPLDemoAction *)changeToGreenAction {
    DPLDemoAction *action = [self actionWithColor:[UIColor greenColor]];
    action.actionName = @"Set Receiver Demo green";
    return action;
}


- (DPLDemoAction *)actionWithColor:(UIColor *)color {
    
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    NSDictionary *payload = @{ DPLAppLinkTargetURLKey:       @"http://DPL.button.com/background",
                               DPLAppLinkExtrasKey:          @{ @"red": @(red), @"green": @(green), @"blue":@(blue) }};
    
    NSString *payloadString = [[NSString DPL_stringWithJSONObject:payload] DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"DPL://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    DPLDemoAction *action = [[DPLDemoAction alloc] init];
    action.actionURL = deepLinkURL;
    return action;
}

@end
