#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSpacing : NSObject<NSCopying>

+ (instancetype)flexibleSpacing:(CGFloat)flexibleSpacing NS_SWIFT_NAME(flexible(_:));
+ (instancetype)fixedSpacing:(CGFloat)fixedSpacing NS_SWIFT_NAME(fixed(_:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) CGFloat spacing;
@property (nonatomic, readonly) BOOL isFlexibleSpacing;
@property (nonatomic, readonly) BOOL isFixedSpacing;

@end

NS_ASSUME_NONNULL_END
