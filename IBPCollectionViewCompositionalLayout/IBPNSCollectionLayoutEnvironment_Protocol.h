#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IBPNSCollectionLayoutContainer;

@protocol IBPNSCollectionLayoutEnvironment<NSObject>

@property(nonatomic, readonly) id<IBPNSCollectionLayoutContainer> container;
@property(nonatomic, readonly) UITraitCollection *traitCollection;

@end

NS_ASSUME_NONNULL_END
