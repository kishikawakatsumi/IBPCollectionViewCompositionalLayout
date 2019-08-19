#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IBPNSCollectionLayoutGroupCustomItem;
@protocol IBPNSCollectionLayoutEnvironment;

typedef NSArray<IBPNSCollectionLayoutGroupCustomItem *> * _Nonnull (^IBPNSCollectionLayoutGroupCustomItemProvider)(id<IBPNSCollectionLayoutEnvironment> layoutEnvironment);

@interface IBPNSCollectionLayoutGroupCustomItem : NSObject<NSCopying>

+ (instancetype)customItemWithFrame:(CGRect)frame;
+ (instancetype)customItemWithFrame:(CGRect)frame zIndex:(NSInteger)zIndex;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) CGRect frame;
@property (nonatomic, readonly) NSInteger zIndex;

@end

NS_ASSUME_NONNULL_END
