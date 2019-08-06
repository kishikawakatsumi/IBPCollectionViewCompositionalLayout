#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutSpacing;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutEdgeSpacing : NSObject<NSCopying>

+ (instancetype)spacingForLeading:(nullable IBPNSCollectionLayoutSpacing *)leading
                              top:(nullable IBPNSCollectionLayoutSpacing *)top
                         trailing:(nullable IBPNSCollectionLayoutSpacing *)trailing
                           bottom:(nullable IBPNSCollectionLayoutSpacing *)bottom NS_SWIFT_NAME(init(leading:top:trailing:bottom:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *leading;
@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *top;
@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *trailing;
@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *bottom;

@end

NS_ASSUME_NONNULL_END
