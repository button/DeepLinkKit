#import <UIKit/UIKit.h>
#import <DeepLinkSDK/DPLTargetViewControllerProtocol.h>

@class DPLProduct;

@interface DPLProductDetailViewController : UIViewController <DPLTargetViewController>

@property (nonatomic, strong) DPLProduct *product;

@end
