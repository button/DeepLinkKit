#import <Foundation/Foundation.h>

@class DLCDemoAction;

@interface DLCActionDataSource : NSObject <UITableViewDataSource>

- (DLCDemoAction *)actionAtIndexPath:(NSIndexPath *)indexPath;

@end
