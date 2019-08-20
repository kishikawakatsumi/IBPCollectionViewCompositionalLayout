#import "IBPUICollectionViewCompositionalLayout.h"
#import "IBPCollectionCompositionalLayoutSolver.h"
#import "IBPCollectionViewOrthogonalScrollerEmbeddedScrollView.h"
#import "IBPCollectionViewOrthogonalScrollerSectionController.h"
#import "IBPNSCollectionLayoutAnchor_Private.h"
#import "IBPNSCollectionLayoutBoundarySupplementaryItem.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutDecorationItem.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutEnvironment.h"
#import "IBPNSCollectionLayoutGroup_Private.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSection_Private.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutSpacing.h"
#import "IBPNSCollectionLayoutSupplementaryItem_Private.h"
#import "IBPUICollectionViewCompositionalLayoutConfiguration_Private.h"

@interface IBPUICollectionViewCompositionalLayout() {
    NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *cachedItemAttributes;
    NSMutableDictionary<NSString *, UICollectionViewLayoutAttributes *> *cachedSupplementaryAttributes;
    NSMutableDictionary<NSString *, UICollectionViewLayoutAttributes *> *cachedDecorationAttributes;
    NSMutableArray<IBPNSCollectionLayoutSupplementaryItem *> *globalSupplementaryItems;
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributesForPinnedSupplementaryItems;

    CGRect contentFrame;
    NSMutableDictionary<NSNumber *, IBPCollectionViewOrthogonalScrollerSectionController *> *orthogonalScrollerSectionControllers;

    IBPCollectionCompositionalLayoutSolver *solver;
}

@property (nonatomic, copy) IBPNSCollectionLayoutSection *layoutSection;
@property (nonatomic) IBPUICollectionViewCompositionalLayoutSectionProvider layoutSectionProvider;

@property (nonatomic) IBPUICollectionLayoutSectionOrthogonalScrollingBehavior parentCollectionViewOrthogonalScrollingBehavior;

@property (nonatomic) BOOL hasPinnedSupplementaryItems;

@end

@implementation IBPUICollectionViewCompositionalLayout

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section {
    if (@available(iOS 13, *)) {
        return [[NSClassFromString(@"UICollectionViewCompositionalLayout") alloc] initWithSection:section];
    } else {
        IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [IBPUICollectionViewCompositionalLayoutConfiguration defaultConfiguration];
        return [self initWithSection:section configuration:configuration];
    }
}

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section
                  configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration {
    if (@available(iOS 13, *)) {
        return [[NSClassFromString(@"UICollectionViewCompositionalLayout") alloc] initWithSection:section configuration:configuration];
    } else {
        self = [super init];
        if (self) {
            [self commonInit];
            self.layoutSection = section;
            self.configuration = configuration;
        }
        return self;
    }
}

- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider {
    if (@available(iOS 13, *)) {
        return [[NSClassFromString(@"UICollectionViewCompositionalLayout") alloc] initWithSectionProvider:sectionProvider];
    } else {
        IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [IBPUICollectionViewCompositionalLayoutConfiguration defaultConfiguration];
        return [self initWithSectionProvider:sectionProvider configuration:configuration];
    }
}

- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider
                          configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration {
    if (@available(iOS 13, *)) {
        return [[NSClassFromString(@"UICollectionViewCompositionalLayout") alloc] initWithSectionProvider:sectionProvider configuration:configuration];
    } else {
        self = [super init];
        if (self) {
            [self commonInit];
            self.layoutSectionProvider = sectionProvider;
            self.configuration = configuration;
        }
        return self;
    }
}

- (void)commonInit {
    cachedItemAttributes = [[NSMutableDictionary alloc] init];
    cachedSupplementaryAttributes = [[NSMutableDictionary alloc] init];
    cachedDecorationAttributes = [[NSMutableDictionary alloc] init];
    globalSupplementaryItems = [[NSMutableArray alloc] init];
    layoutAttributesForPinnedSupplementaryItems = [[NSMutableArray alloc] init];
    orthogonalScrollerSectionControllers = [[NSMutableDictionary alloc] init];
}

- (void)setConfiguration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration {
    _configuration = configuration;
    [self invalidateLayout];
}

- (UICollectionViewScrollDirection)scrollDirection {
    return self.configuration.scrollDirection;
}

- (void)prepareLayout {
    [super prepareLayout];

    UICollectionView *collectionView = self.collectionView;
    if (!collectionView) {
        return;
    }
    CGRect collectionViewBounds = collectionView.bounds;
    if (CGRectIsEmpty(collectionViewBounds)) {
        return;
    }

    [cachedItemAttributes removeAllObjects];
    [cachedSupplementaryAttributes removeAllObjects];
    [cachedDecorationAttributes removeAllObjects];
    [globalSupplementaryItems removeAllObjects];
    [layoutAttributesForPinnedSupplementaryItems removeAllObjects];
    self.hasPinnedSupplementaryItems = NO;

    [[orthogonalScrollerSectionControllers allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [orthogonalScrollerSectionControllers removeAllObjects];

    UIEdgeInsets collectionContentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        if ([collectionView respondsToSelector:@selector(safeAreaInsets)]) {
            collectionContentInset = collectionView.safeAreaInsets;
        }
    }

    IBPNSCollectionLayoutContainer *collectionContainer;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        IBPNSDirectionalEdgeInsets insets = IBPNSDirectionalEdgeInsetsMake(0, collectionContentInset.left, 0, collectionContentInset.right);
        collectionContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:collectionViewBounds.size contentInsets:insets];
    }
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        IBPNSDirectionalEdgeInsets insets = IBPNSDirectionalEdgeInsetsMake(collectionContentInset.top, collectionContentInset.left, collectionContentInset.bottom, collectionContentInset.right);
        collectionContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:collectionViewBounds.size contentInsets:insets];
    }

    IBPNSCollectionLayoutEnvironment *environment = [[IBPNSCollectionLayoutEnvironment alloc] init];
    environment.container = collectionContainer;
    environment.traitCollection = collectionView.traitCollection;

    contentFrame = CGRectZero;
    contentFrame.origin.x = collectionContainer.effectiveContentInsets.leading;
    contentFrame.origin.y = collectionContainer.effectiveContentInsets.top;

    NSInteger numberOfSections = collectionView.numberOfSections;
    for (NSInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {
        IBPNSCollectionLayoutSection *layoutSection = self.layoutSectionProvider ? self.layoutSectionProvider(sectionIndex, environment) : self.layoutSection;

        CGPoint sectionOrigin = contentFrame.origin;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            sectionOrigin.y = CGRectGetMaxY(contentFrame);
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionOrigin.x = CGRectGetMaxX(contentFrame);
        }

        solver = [[IBPCollectionCompositionalLayoutSolver alloc] initWithLayoutSection:layoutSection configuration:self.configuration];
        [solver solveLayoutForContainer:collectionContainer traitCollection:environment.traitCollection];

        NSInteger numberOfItems = [collectionView numberOfItemsInSection:sectionIndex];
        for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            UICollectionViewLayoutAttributes *cellAttributes = [solver layoutAttributesForItemAtIndexPath:indexPath];

            CGRect cellFrame = cellAttributes.frame;
            cellFrame.origin.x += sectionOrigin.x;
            cellFrame.origin.y += sectionOrigin.y;
            cellAttributes.frame = cellFrame;
            if (!layoutSection.scrollsOrthogonally) {
                cachedItemAttributes[indexPath] = cellAttributes;
            }

            IBPNSCollectionLayoutItem *layoutItem = [solver layoutItemAtIndexPath:indexPath];
            NSMutableDictionary<NSString *, UICollectionViewLayoutAttributes *> *supplementaryAttributes = cachedSupplementaryAttributes;
            [layoutItem enumerateSupplementaryItemsWithHandler:^(IBPNSCollectionLayoutSupplementaryItem * _Nonnull supplementaryItem, BOOL * _Nonnull stop) {
                UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:supplementaryItem.elementKind withIndexPath:indexPath];

                IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:cellFrame.size
                                                                                                              contentInsets:IBPNSDirectionalEdgeInsetsZero];
                CGSize itemSize = [supplementaryItem.layoutSize effectiveSizeForContainer:itemContainer];
                CGRect itemFrame = [supplementaryItem.containerAnchor itemFrameForContainerRect:cellFrame itemSize:itemSize itemLayoutAnchor:supplementaryItem.itemAnchor];
                layoutAttributes.frame = itemFrame;
                layoutAttributes.zIndex = supplementaryItem.zIndex;

                supplementaryAttributes[[NSString stringWithFormat:@"%@-%ld-%ld", supplementaryItem.elementKind, (long)indexPath.section, (long)indexPath.item]] = layoutAttributes;
            }];

            if (layoutSection.scrollsOrthogonally) {
                CGRect frame = CGRectZero;
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionVertical:
                        frame.origin.x = 0;
                        frame.origin.y = CGRectGetMinY(cellFrame);
                        frame.size.width = collectionContainer.contentSize.width;
                        frame.size.height = CGRectGetHeight(cellFrame);
                        break;
                    case UICollectionViewScrollDirectionHorizontal:
                        frame.origin.x = CGRectGetMinX(cellFrame);
                        frame.origin.y = 0;
                        frame.size.width = CGRectGetWidth(cellFrame);
                        frame.size.height = collectionContainer.contentSize.height;
                        break;
                }

                contentFrame = CGRectUnion(contentFrame, frame);
            } else {
                contentFrame = CGRectUnion(contentFrame, CGRectInset(cellFrame, -layoutItem.contentInsets.trailing, -layoutItem.contentInsets.bottom));
            }
        }

        if (layoutSection.scrollsOrthogonally) {
            IBPCollectionViewOrthogonalScrollerSectionController *controller = orthogonalScrollerSectionControllers[@(sectionIndex)];
            if (!controller) {
                CGRect scrollViewFrame = solver.containerFrame;
                scrollViewFrame.origin = sectionOrigin;
                scrollViewFrame.size.width = collectionContainer.contentSize.width;

                IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [IBPUICollectionViewCompositionalLayoutConfiguration defaultConfiguration];
                configuration.scrollDirection = self.scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;

                IBPNSCollectionLayoutSection *orthogonalSection = layoutSection.copy;
                orthogonalSection.boundarySupplementaryItems = @[];
                orthogonalSection.orthogonalScrollingBehavior = IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorNone;
                IBPNSCollectionLayoutSize *orthogonalGroupSize = layoutSection.group.layoutSize;

                IBPNSCollectionLayoutDimension *widthDimension = orthogonalGroupSize.widthDimension;
                IBPNSCollectionLayoutDimension *heightDimension = orthogonalGroupSize.heightDimension;

                if (widthDimension.isFractionalWidth) {
                    widthDimension = self.scrollDirection == UICollectionViewScrollDirectionVertical ? widthDimension : [IBPNSCollectionLayoutDimension fractionalWidthDimension:MAX(1, widthDimension.dimension)];
                }
                if (widthDimension.isFractionalHeight) {
                    widthDimension = self.scrollDirection == UICollectionViewScrollDirectionVertical ? widthDimension : [IBPNSCollectionLayoutDimension fractionalWidthDimension:MAX(1, widthDimension.dimension)];
                }
                if (widthDimension.isAbsolute) {
                    widthDimension = [IBPNSCollectionLayoutDimension absoluteDimension:widthDimension.dimension];
                }

                if (heightDimension.isFractionalWidth) {
                    heightDimension = self.scrollDirection == UICollectionViewScrollDirectionVertical ? [IBPNSCollectionLayoutDimension fractionalHeightDimension:MAX(1, heightDimension.dimension)] : heightDimension;
                }
                if (heightDimension.isFractionalHeight) {
                    heightDimension = self.scrollDirection == UICollectionViewScrollDirectionVertical ? [IBPNSCollectionLayoutDimension fractionalHeightDimension:MAX(1, heightDimension.dimension)] : heightDimension;
                }
                if (heightDimension.isAbsolute) {
                    heightDimension = [IBPNSCollectionLayoutDimension absoluteDimension:heightDimension.dimension];
                }

                orthogonalSection.group.layoutSize = [IBPNSCollectionLayoutSize sizeWithWidthDimension:widthDimension heightDimension:heightDimension];
                IBPUICollectionViewCompositionalLayout *orthogonalScrollViewCollectionViewLayout = [[IBPUICollectionViewCompositionalLayout alloc] initWithSection:orthogonalSection configuration:configuration];
                orthogonalScrollViewCollectionViewLayout.parentCollectionViewOrthogonalScrollingBehavior = layoutSection.orthogonalScrollingBehavior;

                IBPCollectionViewOrthogonalScrollerEmbeddedScrollView *scrollView = [[IBPCollectionViewOrthogonalScrollerEmbeddedScrollView alloc] initWithFrame:scrollViewFrame collectionViewLayout:orthogonalScrollViewCollectionViewLayout];
                scrollView.backgroundColor = [UIColor clearColor];
                scrollView.directionalLockEnabled = YES;
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.showsVerticalScrollIndicator = NO;

                switch (layoutSection.orthogonalScrollingBehavior) {
                    case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorNone:
                    case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous:
                    case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary:
                        scrollView.pagingEnabled = NO;
                        break;
                    case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorPaging:
                        scrollView.pagingEnabled = YES;
                        break;
                    case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging:
                        scrollView.pagingEnabled = NO;
                        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
                        break;
                    case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered:
                        scrollView.pagingEnabled = NO;
                        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
                        CGSize groupSize = [orthogonalGroupSize effectiveSizeForContainer:collectionContainer];
                        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                            CGFloat inset = (collectionContainer.contentSize.width - groupSize.width) / 2;
                            scrollView.contentInset = UIEdgeInsetsMake(0, inset, 0, 0);
                        }
                        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                            CGFloat inset = (collectionContainer.contentSize.height - groupSize.height) / 2;
                            scrollView.contentInset = UIEdgeInsetsMake(inset, 0, 0, 0);
                        }
                        break;
                }
                controller = [[IBPCollectionViewOrthogonalScrollerSectionController alloc] initWithSectionIndex:sectionIndex collectionView:self.collectionView scrollView:scrollView];
                orthogonalScrollerSectionControllers[@(sectionIndex)] = controller;

                [collectionView addSubview:scrollView];
            }
        }

        for (IBPNSCollectionLayoutDecorationItem *decorationItem in layoutSection.decorationItems) {
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationItem.elementKind withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];

            CGRect frame = CGRectZero;
            frame.origin = sectionOrigin;
            frame.size = collectionContainer.effectiveContentSize;

            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                frame.size.height = CGRectGetMaxY(contentFrame) - sectionOrigin.y + layoutSection.contentInsets.bottom;
            }
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                frame.size.width = CGRectGetMaxX(contentFrame) - sectionOrigin.x;
            }

            frame.origin.x += decorationItem.contentInsets.leading;
            frame.origin.y += decorationItem.contentInsets.top;
            frame.size.width -= decorationItem.contentInsets.leading + decorationItem.contentInsets.trailing;
            frame.size.height -= decorationItem.contentInsets.top + decorationItem.contentInsets.bottom;

            layoutAttributes.zIndex = decorationItem.zIndex;

            layoutAttributes.frame = frame;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            cachedDecorationAttributes[indexPath] = layoutAttributes;
        }

        CGRect insetsContentFrame = contentFrame;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            insetsContentFrame.origin.y += layoutSection.contentInsets.bottom + self.configuration.interSectionSpacing;
        }

        contentFrame = CGRectUnion(contentFrame, insetsContentFrame);
        contentFrame = CGRectUnion(contentFrame, contentFrame);

        CGSize extendedBoundary = CGSizeZero;
        for (IBPNSCollectionLayoutBoundarySupplementaryItem *boundaryItem in layoutSection.boundarySupplementaryItems) {
            CGRect containerFrame = solver.containerFrame;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                containerFrame.origin.y = contentFrame.origin.y;
                containerFrame.size.height = contentFrame.size.height;
            }
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                containerFrame.origin.x = contentFrame.origin.x;
                containerFrame.origin.y = contentFrame.origin.y;
                containerFrame.size.width = contentFrame.size.width;
            }

            UICollectionViewLayoutAttributes *layoutAttributes = [self prepareLayoutForBoundaryItem:boundaryItem
                                                                                     containerFrame:containerFrame
                                                                                       sectionIndex:sectionIndex];
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                if (boundaryItem.alignment == IBPNSRectAlignmentTop ||
                    boundaryItem.alignment == IBPNSRectAlignmentTopLeading ||
                    boundaryItem.alignment == IBPNSRectAlignmentTopTrailing) {
                    CGRect itemFrame = layoutAttributes.frame;
                    itemFrame.origin.y += sectionOrigin.y;
                    layoutAttributes.frame = itemFrame;

                    if (boundaryItem.extendsBoundary && extendedBoundary.height < CGRectGetHeight(itemFrame)) {
                        CGFloat extendHeight = CGRectGetHeight(itemFrame) - extendedBoundary.height;
                        for (UICollectionViewLayoutAttributes *attributes in cachedItemAttributes.allValues) {
                            if (attributes.representedElementCategory == UICollectionElementCategoryCell ||
                                attributes.representedElementCategory == UICollectionElementCategoryDecorationView) {
                                CGRect frame = attributes.frame;
                                if (CGRectGetMinY(frame) >= CGRectGetMinY(itemFrame)) {
                                    frame.origin.y += extendHeight;
                                    attributes.frame = frame;
                                    contentFrame = CGRectUnion(contentFrame, frame);
                                }
                            }
                        }
                        for (IBPCollectionViewOrthogonalScrollerSectionController *controller in orthogonalScrollerSectionControllers.allValues) {
                            CGRect frame = controller.scrollView.frame;
                            if (CGRectGetMinY(frame) >= CGRectGetMinY(itemFrame)) {
                                frame.origin.y += extendHeight;
                                controller.scrollView.frame = frame;
                                contentFrame = CGRectUnion(contentFrame, frame);
                            }
                        }
                        extendedBoundary.height += extendHeight;
                    }
                }
            }
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                if (boundaryItem.alignment == IBPNSRectAlignmentLeading ||
                    boundaryItem.alignment == IBPNSRectAlignmentTopLeading ||
                    boundaryItem.alignment == IBPNSRectAlignmentBottomLeading) {
                    CGRect itemFrame = layoutAttributes.frame;
                    itemFrame.origin.x += sectionOrigin.x;
                    layoutAttributes.frame = itemFrame;
                }
            }
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                if (boundaryItem.alignment == IBPNSRectAlignmentBottom ||
                    boundaryItem.alignment == IBPNSRectAlignmentBottomLeading ||
                    boundaryItem.alignment == IBPNSRectAlignmentBottomTrailing) {
                    CGRect itemFrame = layoutAttributes.frame;
                    if (!boundaryItem.extendsBoundary) {
                        itemFrame.origin.y -= CGRectGetHeight(itemFrame);
                    }
                    itemFrame.origin.y += layoutSection.contentInsets.bottom;
                    layoutAttributes.frame = itemFrame;
                }
            }
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                if (boundaryItem.alignment == IBPNSRectAlignmentTrailing ||
                    boundaryItem.alignment == IBPNSRectAlignmentTopTrailing ||
                    boundaryItem.alignment == IBPNSRectAlignmentBottomTrailing) {
                    CGRect itemFrame = layoutAttributes.frame;
                    itemFrame.origin.x += layoutSection.contentInsets.trailing;
                    layoutAttributes.frame = itemFrame;
                }
            }

            contentFrame = CGRectUnion(contentFrame, layoutAttributes.frame);
            cachedSupplementaryAttributes[[NSString stringWithFormat:@"%@-%ld-%d", boundaryItem.elementKind, (long)sectionIndex, 0]] = layoutAttributes;
            [globalSupplementaryItems addObject:boundaryItem];

            if (boundaryItem.pinToVisibleBounds) {
                self.hasPinnedSupplementaryItems = YES;
                [layoutAttributesForPinnedSupplementaryItems addObject:layoutAttributes];
            }
        }
    }
}

- (UICollectionViewLayoutAttributes *)prepareLayoutForBoundaryItem:(IBPNSCollectionLayoutBoundarySupplementaryItem *)boundaryItem
                                                    containerFrame:(CGRect)containerFrame
                                                      sectionIndex:(NSInteger)sectionIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:boundaryItem.elementKind
                                                                                                                        withIndexPath:indexPath];
    IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:containerFrame.size
                                                                                                  contentInsets:IBPNSDirectionalEdgeInsetsZero];
    CGSize itemSize = [boundaryItem.layoutSize effectiveSizeForContainer:itemContainer];

    IBPNSCollectionLayoutAnchor *containerAnchor;
    switch (boundaryItem.alignment) {
        case IBPNSRectAlignmentNone:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeNone];
            break;
        case IBPNSRectAlignmentTop:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeTop];
            break;
        case IBPNSRectAlignmentTopLeading:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeLeading];
            break;
        case IBPNSRectAlignmentLeading:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeLeading];
            break;
        case IBPNSRectAlignmentBottomLeading:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeLeading];
            break;
        case IBPNSRectAlignmentBottom:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeBottom];
            break;
        case IBPNSRectAlignmentBottomTrailing:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeTrailing];
            break;
        case IBPNSRectAlignmentTrailing:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeTrailing];
            break;
        case IBPNSRectAlignmentTopTrailing:
            containerAnchor = [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeTrailing];
            break;
    }

    CGRect itemFrame = [containerAnchor itemFrameForContainerRect:containerFrame itemSize:itemSize itemLayoutAnchor:nil];

    if ((containerAnchor.edges & IBPNSDirectionalRectEdgeTrailing) == IBPNSDirectionalRectEdgeTrailing) {
        itemFrame.origin.x += itemSize.width;
    }
    if ((containerAnchor.edges & IBPNSDirectionalRectEdgeBottom) == IBPNSDirectionalRectEdgeBottom) {
        itemFrame.origin.y += itemSize.height;
    }

    layoutAttributes.frame = itemFrame;
    layoutAttributes.zIndex = boundaryItem.zIndex;

    return layoutAttributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < cachedItemAttributes.count; i++) {
        UICollectionViewLayoutAttributes *attributes = cachedItemAttributes.allValues[i];
        if (!CGRectIntersectsRect(attributes.frame, rect)) {
            continue;
        }

        NSIndexPath *indexPath = attributes.indexPath;
        IBPNSCollectionLayoutItem *layoutItem = [solver layoutItemAtIndexPath:indexPath];
        IBPNSCollectionLayoutSize *layoutSize = layoutItem.layoutSize;
        if (layoutSize.widthDimension.isEstimated || layoutSize.heightDimension.isEstimated) {
            UICollectionViewCell *cell = [self.collectionView.dataSource collectionView:self.collectionView cellForItemAtIndexPath:attributes.indexPath];
            if (cell) {
                CGSize containerSize = self.collectionViewContentSize;
                if (!layoutSize.widthDimension.isEstimated) {
                    containerSize.width = CGRectGetWidth(attributes.frame);
                }
                if (!layoutSize.heightDimension.isEstimated) {
                    containerSize.height = CGRectGetHeight(attributes.frame);
                }

                CGFloat containerWidth = containerSize.width;
                CGFloat containerHeight = containerSize.height;

                CGRect frame = cell.frame;
                frame.size = containerSize;
                cell.frame = frame;
                [cell setNeedsLayout];
                [cell layoutIfNeeded];

                CGSize fitSize = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                if (!layoutSize.widthDimension.isEstimated) {
                    fitSize.width = containerWidth;
                }
                if (!layoutSize.heightDimension.isEstimated) {
                    fitSize.height = containerHeight;
                }

                CGRect f = attributes.frame;
                if (CGRectGetWidth(f) != fitSize.width || CGRectGetHeight(f) != fitSize.height) {
                    for (NSInteger j = i + 1; j < cachedItemAttributes.count; j++) {
                        UICollectionViewLayoutAttributes *attributes = cachedItemAttributes.allValues[j];
                        CGRect frame = attributes.frame;

                        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                            frame.origin.y += fitSize.height - CGRectGetHeight(f);
                        }
                        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                            frame.origin.x += fitSize.width - CGRectGetWidth(f);
                        }
                        attributes.frame = frame;
                    }
                }
                f.size = fitSize;
                attributes.frame = f;

                contentFrame = CGRectUnion(contentFrame, f);

                [layoutAttributes addObject:attributes];
                continue;
            }
        }

        [layoutAttributes addObject:attributes];
    }

    for (UICollectionViewLayoutAttributes *attributes in cachedSupplementaryAttributes.allValues) {
        if (!CGRectIntersectsRect(attributes.frame, rect)) {
            continue;
        }
        [layoutAttributes addObject:attributes];
    }
    for (UICollectionViewLayoutAttributes *attributes in cachedDecorationAttributes.allValues) {
        if (!CGRectIntersectsRect(attributes.frame, rect)) {
            continue;
        }
        [layoutAttributes addObject:attributes];
    }

    for (NSInteger i = 0; i < layoutAttributesForPinnedSupplementaryItems.count; i++) {
        CGPoint contentOffset = self.collectionView.contentOffset;
        UICollectionViewLayoutAttributes *attributes = layoutAttributesForPinnedSupplementaryItems[i];
        if (!CGRectIntersectsRect(attributes.frame, rect)) {
            continue;
        }

        if (@available(iOS 11.0, *)) {
            if ([self.collectionView respondsToSelector:@selector(safeAreaInsets)]) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    contentOffset.y += self.collectionView.safeAreaInsets.top;
                }
                if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                    contentOffset.x += self.collectionView.safeAreaInsets.left;
                }
            }
        }

        CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);

        if (i + 1 < layoutAttributesForPinnedSupplementaryItems.count) {
            UICollectionViewLayoutAttributes *nextHeaderAttributes = layoutAttributesForPinnedSupplementaryItems[i + 1];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }

        CGRect frame = attributes.frame;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            frame.origin.y = MIN(MAX(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            frame.origin.x = MIN(MAX(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
        }

        attributes.frame = frame;
    }

    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return cachedItemAttributes[indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return cachedSupplementaryAttributes[[NSString stringWithFormat:@"%@-%ld-%ld", elementKind, (long)indexPath.section, (long)indexPath.item]];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return cachedDecorationAttributes[[NSString stringWithFormat:@"%@-%ld-%ld", elementKind, (long)indexPath.section, (long)indexPath.item]];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    switch (self.parentCollectionViewOrthogonalScrollingBehavior) {
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary: {
            CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
            return [solver continuousGroupLeadingBoundaryTargetContentOffsetForProposedContentOffset:proposedContentOffset scrollingVelocity:velocity translation:translation];
        }
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging: {
            CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
            return [solver groupPagingTargetContentOffsetForProposedContentOffset:self.collectionView.contentOffset scrollingVelocity:velocity translation:translation];
        }
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered:{
            CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
            return [solver groupPagingCenteredTargetContentOffsetForProposedContentOffset:self.collectionView.contentOffset scrollingVelocity:velocity translation:translation containerSize:self.collectionView.bounds.size];
        }
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorNone:
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous:
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorPaging:
            return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (!self.collectionView) {
        return NO;
    }
    if (self.hasPinnedSupplementaryItems) {
        return YES;
    }

    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

- (CGSize)collectionViewContentSize {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    return UIEdgeInsetsInsetRect(contentFrame, insets).size;
}

@end
