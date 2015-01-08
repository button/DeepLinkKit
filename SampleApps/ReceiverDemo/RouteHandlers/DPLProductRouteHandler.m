#import "DPLProductRouteHandler.h"
#import "DPLProductDetailViewController.h"

@implementation DPLProductRouteHandler

- (UIViewController <DPLTargetViewController> *)targetViewController {
    UIStoryboard *storyboard = [UIApplication sharedApplication].keyWindow.rootViewController.storyboard;
    
    return [storyboard instantiateViewControllerWithIdentifier:@"detail"];
}

@end
