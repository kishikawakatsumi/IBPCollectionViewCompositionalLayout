#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutDimension : NSObject<NSCopying>

+ (instancetype)fractionalWidthDimension:(CGFloat)fractionalWidth NS_SWIFT_NAME(fractionalWidth(_:));
+ (instancetype)fractionalHeightDimension:(CGFloat)fractionalHeight NS_SWIFT_NAME(fractionalHeight(_:));

+ (instancetype)absoluteDimension:(CGFloat)absoluteDimension NS_SWIFT_NAME(absolute(_:));
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
