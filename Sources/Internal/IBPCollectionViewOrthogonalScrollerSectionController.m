#import "IBPCollectionViewOrthogonalScrollerSectionController.h"

@implementation IBPCollectionViewOrthogonalScrollerSectionController

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(UICollectionView *)scrollView {
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
    NSDictionary *cellClassDict = @{};
    @try {
        cellClassDict = [[self.collectionView valueForKey:@"cellClassDict"] copy];
    } @catch (NSException *exception) {}
    for (NSString *reuseIdentifier in cellClassDict) {
        Class cellClass = cellClassDict[reuseIdentifier];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }
    NSDictionary *cellNibDict = @{};
    @try {
        cellNibDict = [[self.collectionView valueForKey:@"cellNibDict"] copy];
    } @catch (NSException *exception) {}
    for (NSString *reuseIdentifier in cellNibDict) {
        UINib *cellNib = cellNibDict[reuseIdentifier];
        [collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    }

    return [self.collectionView.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *classDict = @{};
    @try {
        classDict = [[self.collectionView valueForKey:@"supplementaryViewClassDict"] copy];
    } @catch (NSException *exception) {}
    for (NSString *reuseIdentifier in classDict) {
        Class viewClass = classDict[reuseIdentifier];
        [collectionView registerClass:viewClass forSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier];
    }
    NSDictionary *nibDict = @{};
    @try {
        nibDict = [[self.collectionView valueForKey:@"supplementaryViewNibDict"] copy];
    } @catch (NSException *exception) {}
    for (NSString *reuseIdentifier in nibDict) {
        UINib *nib = nibDict[reuseIdentifier];
        [collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier];
    }

    return [self.collectionView.dataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (void)removeFromSuperview {
    [self.scrollView removeFromSuperview];
}

@end
