#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
typedef NS_ENUM(NSInteger, UICollectionLayoutSectionOrthogonalScrollingBehavior) {
    UICollectionLayoutSectionOrthogonalScrollingBehaviorNone,
    UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous,
    UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary,
    UICollectionLayoutSectionOrthogonalScrollingBehaviorPaging,
    UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging,
    UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered,
};
#endif
