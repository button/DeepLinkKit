#import <UIKit/UIKit.h>
#import <DeepLinkKit/DeepLinkKit.h>

@class DPLProduct;

@interface DPLProductDetailViewController : UIViewController <DPLTargetViewController>

@property (nonatomic, strong) DPLProduct *product;

@end
