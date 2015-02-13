//
//  UINavigationController+DPL.m
//  DeepLinkSDK
//
//  Created by Patrick Childers on 2/13/15.
//  Copyright (c) 2015 Button, Inc. All rights reserved.
//

#import "UINavigationController+DPL.h"

@implementation UINavigationController (DPL)

- (void)placeTargetViewController:(UIViewController *)targetViewController {
    
    if ([self.viewControllers containsObject:targetViewController]) {
        [self popToViewController:targetViewController animated:NO];
    }
    else {
        
        for (UIViewController *controller in self.viewControllers) {
            if ([controller isMemberOfClass:[targetViewController class]]) {
                
                [self popToViewController:controller animated:NO];
                [self popViewControllerAnimated:NO];
                
                if ([controller isEqual:self.topViewController]) {
                    [self setViewControllers:@[targetViewController] animated:NO];
                }
                
                break;
            }
        }
        
        if (![self.topViewController isEqual:targetViewController]) {
            [self pushViewController:targetViewController animated:NO];
        }
    }
}

@end
