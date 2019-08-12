#import "IBPCollectionViewOrthogonalScrollerSectionController.h"
#import "IBPCollectionViewOrthogonalScrollerEmbeddedScrollView.h"

@implementation UICollectionViewOrthogonalScrollerSectionController

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(IBPCollectionViewOrthogonalScrollerEmbeddedScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.sectionIndex = sectionIndex;
        self.collectionView = collectionView;
        self.scrollView = scrollView;

        scrollView.dataSource = self;
        if (@available(iOS 10, *)) {
            scrollView.prefetchingEnabled = collectionView.prefetchingEnabled;
            scrollView.prefetchDataSource = collectionView.prefetchDataSource;
        }
        scrollView.delegate = collectionView.delegate;
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionIndex + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.sectionIndex == section) {
        return [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView.dataSource collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
}

- (void)removeFromSuperview {
    [self.collectionView removeFromSuperview];
}

@end
