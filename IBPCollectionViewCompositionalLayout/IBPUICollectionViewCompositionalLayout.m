#import "IBPUICollectionViewCompositionalLayout.h"
#import "IBPUICollectionViewCompositionalLayoutConfiguration.h"
#import "IBPNSCollectionLayoutAnchor.h"
#import "IBPNSCollectionLayoutBoundarySupplementaryItem.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutSection_Private.h"
#import "IBPNSCollectionLayoutGroup_Private.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSize.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutSpacing.h"
#import "IBPNSCollectionLayoutSupplementaryItem_Private.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutEnvironment.h"
#import "IBPCollectionViewLayoutBuilder.h"
#import "IBPCollectionViewOrthogonalScrollerEmbeddedScrollView.h"
#import "IBPCollectionViewOrthogonalScrollerSectionController.h"

@interface IBPUICollectionViewCompositionalLayout() {
    CGRect contentBounds;
    NSMutableDictionary<NSNumber *, UICollectionViewOrthogonalScrollerSectionController *> *orthogonalScrollerSectionControllers;
}

@property (nonatomic, copy) IBPNSCollectionLayoutSection *section;
@property (nonatomic) IBPUICollectionViewCompositionalLayoutSectionProvider sectionProvider;

@property (nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *cachedAttributes;

@end

@implementation IBPUICollectionViewCompositionalLayout

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [[UICollectionViewCompositionalLayout alloc] initWithSection:section];
#else
        return nil;
#endif
    } else {
        IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [[IBPUICollectionViewCompositionalLayoutConfiguration alloc] init];
        return [self initWithSection:section configuration:configuration];
    }
}

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [[UICollectionViewCompositionalLayout alloc] initWithSection:section configuration:configuration];
#else
        return nil;
#endif
    } else {
        self = [super init];
        if (self) {
            self.section = section;
            self.configuration = configuration;
        }
        return self;
    }
}

- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:(UICollectionViewCompositionalLayoutSectionProvider)sectionProvider];
#else
        return nil;
#endif
    } else {
        IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [[IBPUICollectionViewCompositionalLayoutConfiguration alloc] init];
        return [self initWithSectionProvider:sectionProvider configuration:configuration];
    }
}

- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:(UICollectionViewCompositionalLayoutSectionProvider)sectionProvider configuration:configuration];
#else
        return nil;
#endif
    } else {
        self = [super init];
        if (self) {
            self.sectionProvider = sectionProvider;
            self.configuration = configuration;
        }
        return self;
    }
}

- (void)prepareLayout {
    [super prepareLayout];

    if (!self.collectionView) {
        return;
    }
    if (CGRectIsEmpty(self.collectionView.bounds)) {
        return;
    }

    if (!self.cachedAttributes) {
        self.cachedAttributes = [[NSMutableArray alloc] init];
    }
    [self.cachedAttributes removeAllObjects];

    if (!orthogonalScrollerSectionControllers) {
        orthogonalScrollerSectionControllers = [[NSMutableDictionary alloc] init];
    }
    [[orthogonalScrollerSectionControllers allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [orthogonalScrollerSectionControllers removeAllObjects];

    UIEdgeInsets collectionContentInset = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        collectionContentInset = self.collectionView.safeAreaInsets;
    }

    CGRect collectionViewBounds = self.collectionView.bounds;
    contentBounds = CGRectMake(0, 0, collectionViewBounds.size.width, collectionViewBounds.size.height);

    IBPNSCollectionLayoutContainer *collectionContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:collectionViewBounds.size
                                                                                                  contentInsets:NSDirectionalEdgeInsetsMake(0, collectionContentInset.left, 0, collectionContentInset.right)];
    IBPNSCollectionLayoutEnvironment *environment = [[IBPNSCollectionLayoutEnvironment alloc] init];
    environment.container = collectionContainer;
    environment.traitCollection = self.collectionView.traitCollection;

    NSInteger numberOfSections = [self.collectionView numberOfSections];

    CGRect layoutFrame = CGRectZero;
    layoutFrame.origin.x += collectionContainer.effectiveContentInsets.leading;
    layoutFrame.origin.y += collectionContainer.effectiveContentInsets.top;

    for (NSInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {
        CGRect sectionFrame = CGRectZero;
        sectionFrame.origin.x = layoutFrame.origin.x;

        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical) {
            sectionFrame.origin.y = CGRectGetMaxY(layoutFrame);
        }
        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionFrame.origin.x = CGRectGetMaxX(layoutFrame);
        }

        IBPNSCollectionLayoutSection *section = self.sectionProvider ? self.sectionProvider(sectionIndex, environment) : self.section;

        NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *boundarySupplementaryItems = section.boundarySupplementaryItems;
        for (IBPNSCollectionLayoutBoundarySupplementaryItem *boundarySupplementaryItem in boundarySupplementaryItems) {
            UICollectionViewLayoutAttributes *boundarySupplementaryViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:boundarySupplementaryItem.elementKind
                                                                                                                                                   withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
            CGRect boundarySupplementaryViewFrame = layoutFrame;

            IBPNSCollectionLayoutSize *boundarySupplementaryItemLayoutSize = boundarySupplementaryItem.layoutSize;

            CGSize boundarySupplementaryItemEffectiveSize = [boundarySupplementaryItemLayoutSize effectiveSizeForContainer:collectionContainer ignoringInsets:NO];
            boundarySupplementaryViewFrame.size = boundarySupplementaryItemEffectiveSize;

            NSRectAlignment alignment = boundarySupplementaryItem.alignment;
            if (alignment == NSRectAlignmentTop) {
                boundarySupplementaryViewFrame.origin.y = CGRectGetMinY(layoutFrame);
                boundarySupplementaryViewFrame.origin.x += sectionFrame.origin.x;
                boundarySupplementaryViewFrame.origin.y += sectionFrame.origin.y;

                sectionFrame.origin.y += boundarySupplementaryItemEffectiveSize.height;

                boundarySupplementaryViewAttributes.frame = boundarySupplementaryViewFrame;
                [self.cachedAttributes addObject:boundarySupplementaryViewAttributes];

                contentBounds = CGRectUnion(contentBounds, boundarySupplementaryViewFrame);
                layoutFrame = CGRectUnion(layoutFrame, boundarySupplementaryViewFrame);
            }
            if (alignment == NSRectAlignmentTopLeading) {
                // Not implemented yet
            }
            if (alignment == NSRectAlignmentLeading) {
                // Not implemented yet
            }
            if (alignment == NSRectAlignmentBottomLeading) {
                // Not implemented yet
            }
            if (alignment == NSRectAlignmentBottom) {
                // Not implemented yet
            }
            if (alignment == NSRectAlignmentBottomTrailing) {
                // Not implemented yet
            }
            if (alignment == NSRectAlignmentTrailing) {
                // Not implemented yet
            }
            if (alignment == NSRectAlignmentTopTrailing) {
                // Not implemented yet
            }
        }

        IBPCollectionViewLayoutBuilder *builder = [[IBPCollectionViewLayoutBuilder alloc] initWithLayoutSection:section configuration:self.configuration];
        [builder buildLayoutForContainer:collectionContainer traitCollection:environment.traitCollection];

        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            UICollectionViewLayoutAttributes *cellAttributes = [builder layoutAttributesForItemAtIndexPath:indexPath];

            CGRect cellFrame = cellAttributes.frame;
            cellFrame.origin.x += sectionFrame.origin.x;
            cellFrame.origin.y += sectionFrame.origin.y;

            cellAttributes.frame = cellFrame;
            if (!section.scrollsOrthogonally) {
                [self.cachedAttributes addObject:cellAttributes];
            }

            IBPNSCollectionLayoutItem *layoutItem = [builder layoutItemAtIndexPath:indexPath];
            [layoutItem enumerateSupplementaryItemsWithHandler:^(IBPNSCollectionLayoutSupplementaryItem * _Nonnull supplementaryItem, BOOL * _Nonnull stop) {
                UICollectionViewLayoutAttributes *supplementaryViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:supplementaryItem.elementKind withIndexPath:indexPath];
                supplementaryViewAttributes.frame = [supplementaryItem frameInContainerFrame:cellFrame];
                [self.cachedAttributes addObject:supplementaryViewAttributes];
            }];

            if (section.scrollsOrthogonally) {
                CGRect frame = CGRectZero;
                switch (self.configuration.scrollDirection) {
                    case UICollectionViewScrollDirectionVertical:
                        frame.origin.x = 0;
                        frame.origin.y = cellFrame.origin.y;
                        frame.size.width = collectionContainer.contentSize.width;
                        frame.size.height = cellFrame.size.height;
                        break;
                    case UICollectionViewScrollDirectionHorizontal:
                        frame.origin.x = cellFrame.origin.x;
                        frame.origin.y = 0;
                        frame.size.width = cellFrame.size.width;
                        frame.size.height = collectionContainer.contentSize.height;
                        break;
                }

                contentBounds = CGRectUnion(contentBounds, frame);
                layoutFrame = CGRectUnion(layoutFrame, frame);
            } else {
                contentBounds = CGRectUnion(contentBounds, CGRectInset(cellFrame, -layoutItem.contentInsets.trailing, -layoutItem.contentInsets.bottom));
                layoutFrame = CGRectUnion(layoutFrame, CGRectInset(cellFrame, -layoutItem.contentInsets.trailing, -layoutItem.contentInsets.bottom));
            }
        }

        if (section.scrollsOrthogonally) {
            UICollectionViewOrthogonalScrollerSectionController *controller = orthogonalScrollerSectionControllers[@(sectionIndex)];
            if (!controller) {
                CGRect scrollViewFrame = builder.containerFrame;
                scrollViewFrame.origin = sectionFrame.origin;
                scrollViewFrame.size.width = collectionContainer.contentSize.width;

                IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [[IBPUICollectionViewCompositionalLayoutConfiguration alloc] init];
                configuration.scrollDirection = self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;

                IBPNSCollectionLayoutSection *orthogonalSection = section.copy;
                orthogonalSection.boundarySupplementaryItems = @[];
                orthogonalSection.orthogonalScrollingBehavior = IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorNone;
                IBPNSCollectionLayoutSize *orthogonalGroupSize = section.group.layoutSize;

                IBPNSCollectionLayoutDimension *widthDimension = orthogonalGroupSize.widthDimension;
                IBPNSCollectionLayoutDimension *heightDimension = orthogonalGroupSize.heightDimension;

                if (widthDimension.isFractionalWidth) {
                    widthDimension = self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical ? widthDimension : [IBPNSCollectionLayoutDimension fractionalWidthDimension:MAX(1, widthDimension.dimension)];
                }
                if (widthDimension.isFractionalHeight) {
                    widthDimension = self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical ? widthDimension : [IBPNSCollectionLayoutDimension fractionalWidthDimension:MAX(1, widthDimension.dimension)];
                }
                if (widthDimension.isAbsolute) {
                    widthDimension = [IBPNSCollectionLayoutDimension absoluteDimension:widthDimension.dimension];
                }

                if (heightDimension.isFractionalWidth) {
                    heightDimension = self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical ? [IBPNSCollectionLayoutDimension fractionalHeightDimension:MAX(1, heightDimension.dimension)] : heightDimension;
                }
                if (heightDimension.isFractionalHeight) {
                    heightDimension = self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical ? [IBPNSCollectionLayoutDimension fractionalHeightDimension:MAX(1, heightDimension.dimension)] : heightDimension;
                }
                if (heightDimension.isAbsolute) {
                    heightDimension = [IBPNSCollectionLayoutDimension absoluteDimension:heightDimension.dimension];
                }

                orthogonalSection.group.layoutSize = [IBPNSCollectionLayoutSize sizeWithWidthDimension:widthDimension heightDimension:heightDimension];
                IBPUICollectionViewCompositionalLayout *orthogonalScrollViewCollectionViewLayout = [[IBPUICollectionViewCompositionalLayout alloc] initWithSection:orthogonalSection configuration:configuration];

                IBPCollectionViewOrthogonalScrollerEmbeddedScrollView *scrollView = [[IBPCollectionViewOrthogonalScrollerEmbeddedScrollView alloc] initWithFrame:scrollViewFrame collectionViewLayout:orthogonalScrollViewCollectionViewLayout];
                scrollView.backgroundColor = [UIColor clearColor];
                scrollView.directionalLockEnabled = YES;
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.showsVerticalScrollIndicator = NO;
                // FIXME
                if (section.orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous ||
                    section.orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary) {
                    scrollView.pagingEnabled = NO;
                }
                if (section.orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorPaging ||
                    section.orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging ||
                    section.orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered) {
                    scrollView.pagingEnabled = YES;
                }
                controller = [[UICollectionViewOrthogonalScrollerSectionController alloc] initWithSectionIndex:sectionIndex collectionView:self.collectionView scrollView:scrollView];

                [self.collectionView addSubview:scrollView];
            }
            orthogonalScrollerSectionControllers[@(sectionIndex)] = controller;
        }

        for (IBPNSCollectionLayoutBoundarySupplementaryItem *boundarySupplementaryItem in boundarySupplementaryItems) {
            UICollectionViewLayoutAttributes *boundarySupplementaryViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:boundarySupplementaryItem.elementKind
                                                                                                                                                   withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
            CGRect boundarySupplementaryViewFrame = layoutFrame;

            IBPNSCollectionLayoutSize *boundarySupplementaryItemLayoutSize = boundarySupplementaryItem.layoutSize;

            CGSize boundarySupplementaryItemEffectiveSize = [boundarySupplementaryItemLayoutSize effectiveSizeForContainer:collectionContainer ignoringInsets:NO];
            boundarySupplementaryViewFrame.size = boundarySupplementaryItemEffectiveSize;

            NSRectAlignment alignment = boundarySupplementaryItem.alignment;
            if (alignment == NSRectAlignmentBottom) {
                boundarySupplementaryViewFrame.origin.y = CGRectGetMaxY(layoutFrame);
                boundarySupplementaryViewFrame.origin.x += sectionFrame.origin.x;

                sectionFrame.origin.y += boundarySupplementaryItemEffectiveSize.height;

                boundarySupplementaryViewAttributes.frame = boundarySupplementaryViewFrame;
                [self.cachedAttributes addObject:boundarySupplementaryViewAttributes];

                contentBounds = CGRectUnion(contentBounds, boundarySupplementaryViewFrame);
                layoutFrame = CGRectUnion(layoutFrame, boundarySupplementaryViewFrame);
            }
        }

        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical) {
            layoutFrame.origin.y += section.contentInsets.bottom;
        }
        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            layoutFrame.origin.x += section.contentInsets.trailing;
        }
        contentBounds = CGRectUnion(contentBounds, layoutFrame);
    }
}

- (CGSize)collectionViewContentSize {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        insets = self.collectionView.safeAreaInsets;
    }
    return UIEdgeInsetsInsetRect(contentBounds, insets).size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.cachedAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (!self.collectionView) {
        return NO;
    }

    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

@end
