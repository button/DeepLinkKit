#import <Foundation/Foundation.h>

@class BTNDemoAction;

@interface BTNActionDataSource : NSObject <UITableViewDataSource>

- (BTNDemoAction *)actionAtIndexPath:(NSIndexPath *)indexPath;

@end
