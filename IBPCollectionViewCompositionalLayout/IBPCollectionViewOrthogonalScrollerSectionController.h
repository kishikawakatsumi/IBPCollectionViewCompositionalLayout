#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionViewOrthogonalScrollerSectionController: NSObject<UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic) UICollectionView *scrollView;
@property (nonatomic) NSInteger sectionIndex;

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(UICollectionView *)scrollView;

- (void)removeFromSuperview;

@end

NS_ASSUME_NONNULL_END
