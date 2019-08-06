#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutSize.h"

@protocol IBPNSCollectionLayoutContainer;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSize()

- (CGSize)effectiveSizeForContainer:(id<IBPNSCollectionLayoutContainer>)container;
- (CGSize)effectiveSizeForContainer:(id<IBPNSCollectionLayoutContainer>)container ignoringInsets:(BOOL)ignoringInsets;

@end

NS_ASSUME_NONNULL_END
