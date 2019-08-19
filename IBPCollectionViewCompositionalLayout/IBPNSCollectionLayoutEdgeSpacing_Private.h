#import "IBPNSCollectionLayoutEdgeSpacing.h"
#import "IBPNSDirectionalEdgeInsets.h"
#import "IBPNSDirectionalRectEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutEdgeSpacing()

+ (instancetype)defaultSpacing;
+ (instancetype)flexibleSpacing:(CGFloat)spacing;
+ (instancetype)fixedSpacing:(CGFloat)spacing;

- (BOOL)hasSpacing;
- (IBPNSDirectionalEdgeInsets)edgeOutsets;
- (BOOL)isSpacingFlexibleForEdge:(IBPNSDirectionalRectEdge)edge;
- (BOOL)isSpacingFixedForEdge:(IBPNSDirectionalRectEdge)edge;
- (CGFloat)spacingForEdge:(IBPNSDirectionalRectEdge)edge;

@end

NS_ASSUME_NONNULL_END
