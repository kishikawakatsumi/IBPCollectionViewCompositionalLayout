#import <UIKit/UIKit.h>
#import "IBPNSDirectionalEdgeInsets.h"
#import "IBPUICollectionLayoutSectionOrthogonalScrollingBehavior.h"

@class IBPNSCollectionLayoutBoundarySupplementaryItem;
@class IBPNSCollectionLayoutDecorationItem;
@class IBPNSCollectionLayoutGroup;

@protocol IBPNSCollectionLayoutEnvironment;
@protocol IBPNSCollectionLayoutVisibleItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^IBPNSCollectionLayoutSectionVisibleItemsInvalidationHandler)(NSArray<id<IBPNSCollectionLayoutVisibleItem>> *visibleItems, CGPoint contentOffset, id<IBPNSCollectionLayoutEnvironment> layoutEnvironment);

@interface IBPNSCollectionLayoutSection : NSObject<NSCopying>

+ (instancetype)sectionWithGroup:(IBPNSCollectionLayoutGroup *)group;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property(nonatomic) IBPNSDirectionalEdgeInsets contentInsets;
@property(nonatomic) CGFloat interGroupSpacing;

// default is .none
@property (nonatomic) IBPUICollectionLayoutSectionOrthogonalScrollingBehavior orthogonalScrollingBehavior;

// Supplementaries associated with the boundary edges of the section
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *boundarySupplementaryItems;

// by default, section supplementaries will follow any section-specific contentInsets
@property (nonatomic) BOOL supplementariesFollowContentInsets;

// Called for each layout pass to allow modification of item properties right before they are displayed.
@property (nonatomic, copy, nullable) IBPNSCollectionLayoutSectionVisibleItemsInvalidationHandler visibleItemsInvalidationHandler;

// decoration views anchored to the section's geometry (e.g. background decoration view)
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutDecorationItem *> *decorationItems;

@end

NS_ASSUME_NONNULL_END
