#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutContainer_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutContainer : NSObject<IBPNSCollectionLayoutContainer>

@property (nonatomic, readonly) IBPNSDirectionalEdgeInsets contentInsets;
@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, readonly) IBPNSDirectionalEdgeInsets effectiveContentInsets;
@property (nonatomic, readonly) CGSize effectiveContentSize;

- (instancetype)initWithContentSize:(CGSize)contentSize contentInsets:(IBPNSDirectionalEdgeInsets)contentInsets;

@end

NS_ASSUME_NONNULL_END
