#import <UIKit/UIKit.h>
#import "IBPNSDirectionalEdgeInsets.h"
#import "IBPUICollectionViewCompositionalLayout.h"

@class IBPNSCollectionLayoutGroup, IBPNSCollectionLayoutBoundarySupplementaryItem, IBPNSCollectionLayoutDecorationItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSection : NSObject<NSCopying>

+ (instancetype)sectionWithGroup:(IBPNSCollectionLayoutGroup *)group;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property(nonatomic) IBPNSDirectionalEdgeInsets contentInsets;
@property(nonatomic) CGFloat interGroupSpacing;

@property (nonatomic) IBPUICollectionLayoutSectionOrthogonalScrollingBehavior orthogonalScrollingBehavior;
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *boundarySupplementaryItems;

@property (nonatomic) BOOL supplementariesFollowContentInsets;
@property (nonatomic, copy, nullable) IBPNSCollectionLayoutSectionVisibleItemsInvalidationHandler visibleItemsInvalidationHandler;

@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutDecorationItem *> *decorationItems;

@end

NS_ASSUME_NONNULL_END
