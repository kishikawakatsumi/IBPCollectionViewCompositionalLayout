#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutDimension;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSize : NSObject<NSCopying>

+ (instancetype)sizeWithWidthDimension:(IBPNSCollectionLayoutDimension *)width
                       heightDimension:(IBPNSCollectionLayoutDimension *)height;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) IBPNSCollectionLayoutDimension *widthDimension;
@property (nonatomic, readonly) IBPNSCollectionLayoutDimension *heightDimension;

@end

NS_ASSUME_NONNULL_END
