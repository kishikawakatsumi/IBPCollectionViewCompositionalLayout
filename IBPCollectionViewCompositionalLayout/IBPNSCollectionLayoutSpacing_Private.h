#import "IBPNSCollectionLayoutSpacing.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSpacing()

+ (instancetype)defaultSpacing;

- (instancetype)initWithSpacing:(CGFloat)spacing isFlexible:(BOOL)isFlexible;
- (BOOL)hasSpacing;

@end

NS_ASSUME_NONNULL_END
