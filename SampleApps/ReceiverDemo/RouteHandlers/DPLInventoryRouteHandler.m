#import "DPLInventoryRouteHandler.h"

@implementation DPLInventoryRouteHandler

- (BOOL)preferAsynchronous {
    return YES;
}

- (void)targetViewControllerWithCompletion:(void (^)(UIViewController<DPLTargetViewController> *))completionHandler {
    UIStoryboard *storyboard = [UIApplication sharedApplication].keyWindow.rootViewController.storyboard;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController<DPLTargetViewController> *vc = [storyboard instantiateViewControllerWithIdentifier:@"inventory"];
        completionHandler(vc);
    });

}

@end
