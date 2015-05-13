#import <UIKit/UIKit.h>
#import <DeepLinkKit/DPLTargetViewControllerProtocol.h>

@class DPLProduct;

@interface DPLProductDetailViewController : UIViewController <DPLTargetViewController>

@property (nonatomic, strong) DPLProduct *product;

@end
