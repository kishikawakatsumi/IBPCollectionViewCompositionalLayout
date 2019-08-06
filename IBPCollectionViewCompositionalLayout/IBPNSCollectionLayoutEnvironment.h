#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutEnvironment : NSObject<IBPNSCollectionLayoutEnvironment>

@property(nonatomic, readwrite) id<IBPNSCollectionLayoutContainer> container;
@property(nonatomic, readwrite) UITraitCollection *traitCollection;

@end

NS_ASSUME_NONNULL_END
