#import "IBPUICollectionViewCompositionalLayoutConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPUICollectionViewCompositionalLayoutConfiguration()

+ (instancetype)defaultConfiguration;
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection
                    interSectionSpacing:(CGFloat)interSectionSpacing
             boundarySupplementaryItems:(NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *)boundarySupplementaryItems;

@end

NS_ASSUME_NONNULL_END
