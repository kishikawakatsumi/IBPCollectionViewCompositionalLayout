#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IBPNSCollectionLayoutContainer<NSObject>

@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, readonly) CGSize effectiveContentSize;
@property (nonatomic, readonly) NSDirectionalEdgeInsets contentInsets;
@property (nonatomic, readonly) NSDirectionalEdgeInsets effectiveContentInsets;

@end

NS_ASSUME_NONNULL_END
