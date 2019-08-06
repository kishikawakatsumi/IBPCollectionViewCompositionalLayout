#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutDecorationItem : NSObject<NSCopying>

+ (instancetype)backgroundDecorationItemWithElementKind:(NSString *)elementKind NS_SWIFT_NAME(background(elementKind:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic) NSInteger zIndex;
@property (nonatomic, readonly) NSString *elementKind;
@property (nonatomic) NSDirectionalEdgeInsets contentInsets;

@end

NS_ASSUME_NONNULL_END
