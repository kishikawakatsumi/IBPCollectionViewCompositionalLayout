#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutBoundarySupplementaryItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPUICollectionViewCompositionalLayoutConfiguration : NSObject<NSCopying>

@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
@property (nonatomic) CGFloat interSectionSpacing;                     // default is 0
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *boundarySupplementaryItems;

@end

NS_ASSUME_NONNULL_END
