#import <UIKit/UIKit.h>

@class IBPCollectionViewOrthogonalScrollerEmbeddedScrollView;

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionViewOrthogonalScrollerSectionController: NSObject<UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic) IBPCollectionViewOrthogonalScrollerEmbeddedScrollView *scrollView;
@property (nonatomic) NSInteger sectionIndex;

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(IBPCollectionViewOrthogonalScrollerEmbeddedScrollView *)scrollView;

- (void)removeFromSuperview;

@end

NS_ASSUME_NONNULL_END
