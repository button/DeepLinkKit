#import "BTNActionDataSource.h"
#import "NSString+BTNQuery.h"
#import "NSString+BTNJSON.h"
#import "BTNDeepLink.h"
#import "BTNDemoAction.h"

@interface BTNActionDataSource ()

@property (nonatomic, strong) NSArray *actions;

@end


@implementation BTNActionDataSource

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


- (BTNDemoAction *)actionAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < [self.actions count]) ? self.actions[indexPath.row] : nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"action-cell" forIndexPath:indexPath];
    BTNDemoAction *demoAction = [self actionAtIndexPath:indexPath];
    cell.textLabel.text       = demoAction.actionName;
    return cell;
}


#pragma mark - Action Construction

- (BTNDemoAction *)logHelloWorldAction {
    NSDictionary *payload = @{ BTNDeepLinkTargetURLKey:       @"http://dlc.button.com/log",
                               BTNDeepLinkReferrerURLKey:     @"http://sender-demo",
                               BTNDeepLinkReferrerAppNameKey: @"SenderDemo",
                               BTNDeepLinkExtrasKey:          @{ @"message": @"Hello World!" }};
    
    NSString *payloadString = [[NSString BTN_stringWithJSONObject:payload] BTN_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"dlc://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    BTNDemoAction *action = [[BTNDemoAction alloc] init];
    action.actionURL = deepLinkURL;
    action.actionName = @"Log “Hello World!” in Receiver Demo";
    return action;
}


- (BTNDemoAction *)changeToRedAction {
    BTNDemoAction *action = [self actionWithColor:[UIColor redColor]];
    action.actionName = @"Set Receiver Demo red";
    return action;
}


- (BTNDemoAction *)changeToBlueAction {
    BTNDemoAction *action = [self actionWithColor:[UIColor blueColor]];
    action.actionName = @"Set Receiver Demo blue";
    return action;
}


- (BTNDemoAction *)changeToPurpleAction {
    BTNDemoAction *action = [self actionWithColor:[UIColor purpleColor]];
    action.actionName = @"Set Receiver Demo purple";
    return action;
}


- (BTNDemoAction *)changeToGreenAction {
    BTNDemoAction *action = [self actionWithColor:[UIColor greenColor]];
    action.actionName = @"Set Receiver Demo green";
    return action;
}


- (BTNDemoAction *)actionWithColor:(UIColor *)color {
    
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    NSDictionary *payload = @{ BTNDeepLinkTargetURLKey:       @"http://dlc.button.com/background",
                               BTNDeepLinkReferrerURLKey:     @"http://sender-demo",
                               BTNDeepLinkReferrerAppNameKey: @"SenderDemo",
                               BTNDeepLinkExtrasKey:          @{ @"red": @(red), @"green": @(green), @"blue":@(blue) }};
    
    NSString *payloadString = [[NSString BTN_stringWithJSONObject:payload] BTN_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"dlc://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    BTNDemoAction *action = [[BTNDemoAction alloc] init];
    action.actionURL = deepLinkURL;
    return action;
}

@end
