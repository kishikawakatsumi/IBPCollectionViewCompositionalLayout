#import <UIKit/UIKit.h>
#import "IBPUICollectionViewCompositionalLayout.h"

@class IBPNSCollectionLayoutGroup, IBPNSCollectionLayoutBoundarySupplementaryItem, IBPNSCollectionLayoutDecorationItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSection : NSObject<NSCopying>

+ (instancetype)sectionWithGroup:(IBPNSCollectionLayoutGroup *)group;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property(nonatomic) NSDirectionalEdgeInsets contentInsets;
@property(nonatomic) CGFloat interGroupSpacing;

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
@property (nonatomic) UICollectionLayoutSectionOrthogonalScrollingBehavior orthogonalScrollingBehavior;
#else
@property (nonatomic) IBPUICollectionLayoutSectionOrthogonalScrollingBehavior orthogonalScrollingBehavior;
#endif
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *boundarySupplementaryItems;

@property (nonatomic) BOOL supplementariesFollowContentInsets;
@property (nonatomic, copy, nullable) NSCollectionLayoutSectionVisibleItemsInvalidationHandler visibleItemsInvalidationHandler;

@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutDecorationItem *> *decorationItems;

@end

NS_ASSUME_NONNULL_END
