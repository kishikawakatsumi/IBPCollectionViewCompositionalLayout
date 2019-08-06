#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutBoundarySupplementaryItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPUICollectionViewCompositionalLayoutConfiguration : NSObject<NSCopying>

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) CGFloat interSectionSpacing;
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *boundarySupplementaryItems;

@end

NS_ASSUME_NONNULL_END
