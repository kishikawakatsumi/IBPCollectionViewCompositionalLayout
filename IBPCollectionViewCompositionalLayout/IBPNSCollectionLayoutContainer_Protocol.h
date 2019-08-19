#import <UIKit/UIKit.h>
#import "IBPNSDirectionalEdgeInsets.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IBPNSCollectionLayoutContainer<NSObject>

@property (nonatomic, readonly) CGSize contentSize;                                // resolved size of container (before any insets are applied)
@property (nonatomic, readonly) CGSize effectiveContentSize;                       // after insets are applied
@property (nonatomic, readonly) IBPNSDirectionalEdgeInsets contentInsets;          // values < 1.0 are interpreted as fractional values (e.g. leading:0.15 == 15% width)
@property (nonatomic, readonly) IBPNSDirectionalEdgeInsets effectiveContentInsets; // resolved value after resolving any unit values

@end

NS_ASSUME_NONNULL_END
