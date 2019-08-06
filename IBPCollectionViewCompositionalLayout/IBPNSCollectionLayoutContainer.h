#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutContainer_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutContainer : NSObject<IBPNSCollectionLayoutContainer>

@property (nonatomic, readonly) NSDirectionalEdgeInsets contentInsets;
@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, readonly) NSDirectionalEdgeInsets effectiveContentInsets;
@property (nonatomic, readonly) CGSize effectiveContentSize;

- (id)initWithContentSize:(CGSize)contentSize contentInsets:(NSDirectionalEdgeInsets)contentInsets;

@end

NS_ASSUME_NONNULL_END
