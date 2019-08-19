#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutContainer;
@class IBPNSCollectionLayoutItem;
@class IBPNSCollectionLayoutSection;
@class IBPUICollectionViewCompositionalLayoutConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionViewLayoutBuilder : NSObject

@property (nonatomic, readonly, copy) IBPNSCollectionLayoutSection *section;
@property (nonatomic, readonly) CGRect containerFrame;

- (instancetype)initWithLayoutSection:(IBPNSCollectionLayoutSection *)section;
- (instancetype)initWithLayoutSection:(IBPNSCollectionLayoutSection *)section
                        configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration;

- (void)buildLayoutForContainer:(IBPNSCollectionLayoutContainer *)container
          traitCollection:(UITraitCollection *)traitCollection;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (IBPNSCollectionLayoutItem *)layoutItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGPoint)continuousGroupLeadingBoundaryTargetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                                                   scrollingVelocity:(CGPoint)velocity
                                                                         translation:(CGPoint)translation;
- (CGPoint)groupPagingTargetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                                scrollingVelocity:(CGPoint)velocity
                                                      translation:(CGPoint)translation;
- (CGPoint)groupPagingCenteredTargetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                                        scrollingVelocity:(CGPoint)velocity
                                                              translation:(CGPoint)translation
                                                            containerSize:(CGSize)containerSize;

@end

NS_ASSUME_NONNULL_END
