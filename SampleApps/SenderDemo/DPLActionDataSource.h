#import <Foundation/Foundation.h>

@class DPLDemoAction;

@interface DPLActionDataSource : NSObject <UITableViewDataSource>

- (DPLDemoAction *)actionAtIndexPath:(NSIndexPath *)indexPath;

@end
