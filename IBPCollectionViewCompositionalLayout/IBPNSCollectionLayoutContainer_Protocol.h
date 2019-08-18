#import <UIKit/UIKit.h>
#import "IBPNSDirectionalEdgeInsets.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IBPNSCollectionLayoutContainer<NSObject>

@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, readonly) CGSize effectiveContentSize;
@property (nonatomic, readonly) IBPNSDirectionalEdgeInsets contentInsets;
@property (nonatomic, readonly) IBPNSDirectionalEdgeInsets effectiveContentInsets;

@end

NS_ASSUME_NONNULL_END
