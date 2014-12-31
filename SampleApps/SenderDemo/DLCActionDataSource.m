#import "DLCActionDataSource.h"
#import "NSString+DLCQuery.h"
#import "NSString+DLCJSON.h"
#import "DLCDeepLink.h"
#import "DLCDemoAction.h"

@interface DLCActionDataSource ()

@property (nonatomic, strong) NSArray *actions;

@end


@implementation DLCActionDataSource

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


- (DLCDemoAction *)actionAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < [self.actions count]) ? self.actions[indexPath.row] : nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"action-cell" forIndexPath:indexPath];
    DLCDemoAction *demoAction = [self actionAtIndexPath:indexPath];
    cell.textLabel.text       = demoAction.actionName;
    return cell;
}


#pragma mark - Action Construction

- (DLCDemoAction *)logHelloWorldAction {
    NSDictionary *payload = @{ DLCAppLinkTargetURLKey:       @"http://dlc.button.com/say/Congratulations/Button%20Team" };
    
    NSString *payloadString = [[NSString DLC_stringWithJSONObject:payload] DLC_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"dldemo://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    DLCDemoAction *action = [[DLCDemoAction alloc] init];
    action.actionURL = deepLinkURL;
    action.actionName = @"Today's Demo";
    return action;
}


- (DLCDemoAction *)changeToRedAction {
    DLCDemoAction *action = [self actionWithColor:[UIColor redColor]];
    action.actionName = @"Set Receiver Demo red";
    return action;
}


- (DLCDemoAction *)changeToBlueAction {
    DLCDemoAction *action = [self actionWithColor:[UIColor blueColor]];
    action.actionName = @"Set Receiver Demo blue";
    return action;
}


- (DLCDemoAction *)changeToPurpleAction {
    DLCDemoAction *action = [self actionWithColor:[UIColor purpleColor]];
    action.actionName = @"Set Receiver Demo purple";
    return action;
}


- (DLCDemoAction *)changeToGreenAction {
    DLCDemoAction *action = [self actionWithColor:[UIColor greenColor]];
    action.actionName = @"Set Receiver Demo green";
    return action;
}


- (DLCDemoAction *)actionWithColor:(UIColor *)color {
    
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    NSDictionary *payload = @{ DLCAppLinkTargetURLKey:       @"http://dlc.button.com/background",
                               DLCAppLinkExtrasKey:          @{ @"red": @(red), @"green": @(green), @"blue":@(blue) }};
    
    NSString *payloadString = [[NSString DLC_stringWithJSONObject:payload] DLC_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"dlc://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    DLCDemoAction *action = [[DLCDemoAction alloc] init];
    action.actionURL = deepLinkURL;
    return action;
}

@end
