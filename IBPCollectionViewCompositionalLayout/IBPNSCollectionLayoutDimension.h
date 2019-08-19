#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutDimension : NSObject<NSCopying>

// dimension is computed as a fraction of the width of the containing group
+ (instancetype)fractionalWidthDimension:(CGFloat)fractionalWidth NS_SWIFT_NAME(fractionalWidth(_:));

// dimension is computed as a fraction of the height of the containing group
+ (instancetype)fractionalHeightDimension:(CGFloat)fractionalHeight NS_SWIFT_NAME(fractionalHeight(_:));

// dimension with an absolute point value
+ (instancetype)absoluteDimension:(CGFloat)absoluteDimension NS_SWIFT_NAME(absolute(_:));

// dimension is estimated with a point value. Actual size will be determined when the content is rendered.
+ (instancetype)estimatedDimension:(CGFloat)estimatedDimension NS_SWIFT_NAME(estimated(_:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) BOOL isFractionalWidth;
@property (nonatomic, readonly) BOOL isFractionalHeight;
@property (nonatomic, readonly) BOOL isAbsolute;
@property (nonatomic, readonly) BOOL isEstimated;
@property (nonatomic, readonly) CGFloat dimension;

@end

NS_ASSUME_NONNULL_END
