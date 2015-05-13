#import <KIF/KIF.h>
#import <XCTest/XCTest.h>

@interface DPLRouteHandlerIntegrationTest : XCTestCase

@end

@implementation DPLRouteHandlerIntegrationTest

- (void)testClassBasedRouteHandlerFlow {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"dpl://dpl.com/product/93598?"]];
    [tester waitForViewWithAccessibilityLabel:@"Shiner Oktoberfest"];
    [tester waitForViewWithAccessibilityLabel:@"8.99"];
}

@end
