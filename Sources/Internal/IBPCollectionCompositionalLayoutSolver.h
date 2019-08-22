#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutContainer;
@class IBPNSCollectionLayoutItem;
@class IBPNSCollectionLayoutSection;
@class IBPUICollectionViewCompositionalLayoutConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionCompositionalLayoutSolver : NSObject

@property (nonatomic, readonly, copy) IBPNSCollectionLayoutSection *layoutSection;
@property (nonatomic, readonly) CGRect layoutFrame;

+ (instancetype)solverWithLayoutSection:(IBPNSCollectionLayoutSection *)section
                        scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

- (void)solveForContainer:(IBPNSCollectionLayoutContainer *)container
          traitCollection:(UITraitCollection *)traitCollection;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (IBPNSCollectionLayoutItem *)layoutItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
