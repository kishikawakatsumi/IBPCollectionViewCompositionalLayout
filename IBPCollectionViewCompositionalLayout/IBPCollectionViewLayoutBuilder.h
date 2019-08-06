#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutSection, IBPNSCollectionLayoutItem, IBPNSCollectionLayoutContainer, IBPUICollectionViewCompositionalLayoutConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionViewLayoutBuilder : NSObject

@property (nonatomic, readonly, copy) IBPNSCollectionLayoutSection *section;
@property (nonatomic, readonly) CGRect containerFrame;

- (instancetype)initWithLayoutSection:(IBPNSCollectionLayoutSection *)section;
- (instancetype)initWithLayoutSection:(IBPNSCollectionLayoutSection *)section
                        configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configutation;

- (void)buildLayoutForContainer:(IBPNSCollectionLayoutContainer *)container
          traitCollection:(UITraitCollection *)traitCollection;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (IBPNSCollectionLayoutItem *)layoutItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
