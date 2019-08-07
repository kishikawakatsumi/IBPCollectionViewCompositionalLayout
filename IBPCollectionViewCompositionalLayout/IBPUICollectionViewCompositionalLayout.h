#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutVisibleItem.h"
#import "UICollectionLayoutSectionOrthogonalScrollingBehavior.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IBPNSCollectionLayoutVisibleItem, NSCollectionLayoutEnvironment;
@class IBPUICollectionViewCompositionalLayoutConfiguration, IBPNSCollectionLayoutSection;

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
typedef IBPNSCollectionLayoutSection * _Nullable (^IBPUICollectionViewCompositionalLayoutSectionProvider)(NSInteger section, id<NSCollectionLayoutEnvironment>);
typedef void (^NSCollectionLayoutSectionVisibleItemsInvalidationHandler)(NSArray<id<IBPNSCollectionLayoutVisibleItem>> *visibleItems, CGPoint contentOffset, id<NSCollectionLayoutEnvironment> layoutEnvironment);
#else
typedef UICollectionViewCompositionalLayoutSectionProvider IBPUICollectionViewCompositionalLayoutSectionProvider;
#endif

@interface IBPUICollectionViewCompositionalLayout : UICollectionViewLayout

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section;
- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration;

- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider;
- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider
                          configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, copy) IBPUICollectionViewCompositionalLayoutConfiguration *configuration;

@end

NS_ASSUME_NONNULL_END

#import "IBPNSCollectionLayoutAnchor.h"
#import "IBPNSCollectionLayoutBoundarySupplementaryItem.h"
#import "IBPNSCollectionLayoutContainer_Protocol.h"
#import "IBPNSCollectionLayoutDecorationItem.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutEdgeSpacing.h"
#import "IBPNSCollectionLayoutEnvironment_Protocol.h"
#import "IBPNSCollectionLayoutGroup.h"
#import "IBPNSCollectionLayoutGroupCustomItem.h"
#import "IBPNSCollectionLayoutItem.h"
#import "IBPNSCollectionLayoutSection.h"
#import "IBPNSCollectionLayoutSize.h"
#import "IBPNSCollectionLayoutSpacing.h"
#import "IBPNSCollectionLayoutSupplementaryItem.h"
#import "IBPNSCollectionLayoutVisibleItem.h"
#import "IBPUICollectionViewCompositionalLayout.h"
#import "IBPUICollectionViewCompositionalLayoutConfiguration.h"
#import "NSDirectionalEdgeInsets.h"
#import "NSDirectionalRectEdge.h"
#import "NSRectAlignment.h"
#import "UICollectionLayoutSectionOrthogonalScrollingBehavior.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
@compatibility_alias NSCollectionLayoutAnchor IBPNSCollectionLayoutAnchor;
@compatibility_alias NSCollectionLayoutBoundarySupplementaryItem IBPNSCollectionLayoutBoundarySupplementaryItem;
@compatibility_alias NSCollectionLayoutDecorationItem IBPNSCollectionLayoutDecorationItem;
@compatibility_alias NSCollectionLayoutDimension IBPNSCollectionLayoutDimension;
@compatibility_alias NSCollectionLayoutEdgeSpacing IBPNSCollectionLayoutEdgeSpacing;
@compatibility_alias NSCollectionLayoutGroup IBPNSCollectionLayoutGroup;
@compatibility_alias NSCollectionLayoutGroupCustomItem IBPNSCollectionLayoutGroupCustomItem;
@compatibility_alias NSCollectionLayoutItem IBPNSCollectionLayoutItem;
@compatibility_alias NSCollectionLayoutSection IBPNSCollectionLayoutSection;
@compatibility_alias NSCollectionLayoutSize IBPNSCollectionLayoutSize;
@compatibility_alias NSCollectionLayoutSpacing IBPNSCollectionLayoutSpacing;
@compatibility_alias NSCollectionLayoutSupplementaryItem IBPNSCollectionLayoutSupplementaryItem;
@compatibility_alias UICollectionViewCompositionalLayout IBPUICollectionViewCompositionalLayout;
@compatibility_alias UICollectionViewCompositionalLayoutConfiguration IBPUICollectionViewCompositionalLayoutConfiguration;
@protocol NSCollectionLayoutContainer <IBPNSCollectionLayoutContainer> @end
@protocol NSCollectionLayoutEnvironment <IBPNSCollectionLayoutEnvironment> @end
#endif
