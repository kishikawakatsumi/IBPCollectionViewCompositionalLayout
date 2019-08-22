#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IBPUICollectionLayoutSectionOrthogonalScrollingBehavior) {
    // default behavior. Section will layout along main layout axis (i.e. configuration.scrollDirection)
    IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorNone,

    // NOTE: For each of the remaining cases, the section content will layout orthogonal to the main layout axis (e.g. main layout axis == .vertical, section will scroll in .horizontal axis)

    // Standard scroll view behavior: UIScrollViewDecelerationRateNormal
    IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous,

    // Scrolling will come to rest on the leading edge of a group boundary
    IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary,

    // Standard scroll view paging behavior (UIScrollViewDecelerationRateFast) with page size == extent of the collection view's bounds
    IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorPaging,

    // Fractional size paging behavior determined by the sections layout group's dimension
    IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging,

    // Same of group paging with additional leading and trailing content insets to center each group's contents along the orthogonal axis
    IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered,
};
