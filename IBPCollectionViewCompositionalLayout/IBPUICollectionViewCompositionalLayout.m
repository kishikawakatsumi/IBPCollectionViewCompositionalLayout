#import "IBPUICollectionViewCompositionalLayout.h"
#import "IBPCollectionViewLayoutBuilder.h"
#import "IBPCollectionViewOrthogonalScrollerEmbeddedScrollView.h"
#import "IBPCollectionViewOrthogonalScrollerSectionController.h"
#import "IBPNSCollectionLayoutAnchor.h"
#import "IBPNSCollectionLayoutBoundarySupplementaryItem.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutDecorationItem.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutEnvironment.h"
#import "IBPNSCollectionLayoutGroup_Private.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSection_Private.h"
#import "IBPNSCollectionLayoutSize.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutSpacing.h"
#import "IBPNSCollectionLayoutSupplementaryItem_Private.h"
#import "IBPUICollectionViewCompositionalLayoutConfiguration.h"

@interface IBPUICollectionViewCompositionalLayout() {
    CGRect contentBounds;
    NSMutableDictionary<NSNumber *, UICollectionViewOrthogonalScrollerSectionController *> *orthogonalScrollerSectionControllers;

    IBPCollectionViewLayoutBuilder *layoutBuilder;
}

@property (nonatomic, copy) IBPNSCollectionLayoutSection *layoutSection;
@property (nonatomic) IBPUICollectionViewCompositionalLayoutSectionProvider sectionProvider;

@property (nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *cachedAttributes;

@property (nonatomic) IBPUICollectionLayoutSectionOrthogonalScrollingBehavior parentCollectionViewOrthogonalScrollingBehavior;

@end

@implementation IBPUICollectionViewCompositionalLayout

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section {
    if (@available(iOS 13, *)) {
        return [[NSClassFromString(@"UICollectionViewCompositionalLayout") alloc] initWithSection:section];
    } else {
        IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [[IBPUICollectionViewCompositionalLayoutConfiguration alloc] init];
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
        IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [[IBPUICollectionViewCompositionalLayoutConfiguration alloc] init];
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
        IBPNSCollectionLayoutSection *section = self.sectionProvider ? self.sectionProvider(sectionIndex, environment) : self.layoutSection;

        CGRect sectionFrame = CGRectZero;
        sectionFrame.origin.x = layoutFrame.origin.x;

        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical) {
            sectionFrame.origin.y = CGRectGetMaxY(layoutFrame);
        }
        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionFrame.origin.x = CGRectGetMaxX(layoutFrame);
        }

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

                boundarySupplementaryViewFrame.origin.x += section.contentInsets.leading;
                boundarySupplementaryViewFrame.origin.y += section.contentInsets.top;
                boundarySupplementaryViewFrame.size.width -= section.contentInsets.leading + section.contentInsets.trailing;
                boundarySupplementaryViewFrame.size.height -= section.contentInsets.top + section.contentInsets.bottom;

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

        layoutBuilder = [[IBPCollectionViewLayoutBuilder alloc] initWithLayoutSection:section configuration:self.configuration];
        [layoutBuilder buildLayoutForContainer:collectionContainer traitCollection:environment.traitCollection];

        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            UICollectionViewLayoutAttributes *cellAttributes = [layoutBuilder layoutAttributesForItemAtIndexPath:indexPath];

            CGRect cellFrame = cellAttributes.frame;
            cellFrame.origin.x += sectionFrame.origin.x;
            cellFrame.origin.y += sectionFrame.origin.y;

            cellAttributes.frame = cellFrame;
            if (!section.scrollsOrthogonally) {
                [self.cachedAttributes addObject:cellAttributes];
            }

            IBPNSCollectionLayoutItem *layoutItem = [layoutBuilder layoutItemAtIndexPath:indexPath];
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
                CGRect scrollViewFrame = layoutBuilder.containerFrame;
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
                orthogonalScrollViewCollectionViewLayout.parentCollectionViewOrthogonalScrollingBehavior = section.orthogonalScrollingBehavior;

                IBPCollectionViewOrthogonalScrollerEmbeddedScrollView *scrollView = [[IBPCollectionViewOrthogonalScrollerEmbeddedScrollView alloc] initWithFrame:scrollViewFrame collectionViewLayout:orthogonalScrollViewCollectionViewLayout];
                scrollView.backgroundColor = [UIColor clearColor];
                scrollView.directionalLockEnabled = YES;
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.showsVerticalScrollIndicator = NO;

                switch (section.orthogonalScrollingBehavior) {
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
                        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical) {
                            CGFloat inset = (collectionContainer.contentSize.width - groupSize.width) / 2;
                            scrollView.contentInset = UIEdgeInsetsMake(0, inset, 0, 0);
                        }
                        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                            CGFloat inset = (collectionContainer.contentSize.height - groupSize.height) / 2;
                            scrollView.contentInset = UIEdgeInsetsMake(inset, 0, 0, 0);
                        }
                        break;
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

                boundarySupplementaryViewFrame.origin.x += section.contentInsets.leading;
                boundarySupplementaryViewFrame.origin.y += section.contentInsets.top;
                boundarySupplementaryViewFrame.size.width -= section.contentInsets.leading + section.contentInsets.trailing;
                boundarySupplementaryViewFrame.size.height -= section.contentInsets.top + section.contentInsets.bottom;

                sectionFrame.origin.y += boundarySupplementaryItemEffectiveSize.height;

                boundarySupplementaryViewAttributes.frame = boundarySupplementaryViewFrame;
                [self.cachedAttributes addObject:boundarySupplementaryViewAttributes];

                contentBounds = CGRectUnion(contentBounds, boundarySupplementaryViewFrame);
                layoutFrame = CGRectUnion(layoutFrame, boundarySupplementaryViewFrame);
            }
        }


        NSArray<IBPNSCollectionLayoutDecorationItem *> *decorationItems = section.decorationItems;
        for (IBPNSCollectionLayoutDecorationItem *decorationItem in decorationItems) {
            UICollectionViewLayoutAttributes *decorationViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationItem.elementKind withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];

            CGRect decorationViewFrame = sectionFrame;

            if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical) {
                decorationViewFrame.size.width += CGRectGetWidth(layoutFrame) + section.contentInsets.leading;
                decorationViewFrame.size.height = CGRectGetMaxY(layoutFrame) - CGRectGetMinY(sectionFrame) + section.contentInsets.top;
            }
            if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                decorationViewFrame.size.width = CGRectGetMaxX(layoutFrame) - CGRectGetMinX(sectionFrame);
                decorationViewFrame.size.height += CGRectGetHeight(layoutFrame);
            }

            decorationViewFrame.origin.x += decorationItem.contentInsets.leading;
            decorationViewFrame.origin.y += decorationItem.contentInsets.top;
            decorationViewFrame.size.width -= decorationItem.contentInsets.leading + decorationItem.contentInsets.trailing;
            decorationViewFrame.size.height -= decorationItem.contentInsets.top + decorationItem.contentInsets.bottom;

            decorationViewAttributes.frame = decorationViewFrame;
            [self.cachedAttributes addObject:decorationViewAttributes];
        }

        CGRect insetsLayoutFrame = layoutFrame;
        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical) {
            insetsLayoutFrame.origin.y += section.contentInsets.bottom;
        }
        if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            insetsLayoutFrame.origin.x += section.contentInsets.trailing;
        }
        contentBounds = CGRectUnion(contentBounds, layoutFrame);
        contentBounds = CGRectUnion(contentBounds, insetsLayoutFrame);
    }
}

- (CGSize)collectionViewContentSize {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
//        insets = self.collectionView.safeAreaInsets;
    }
    return UIEdgeInsetsInsetRect(contentBounds, insets).size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [[NSMutableArray alloc] init];
    NSArray<UICollectionViewLayoutAttributes *> *cachedAttributes = self.cachedAttributes;

    for (NSInteger i = 0; i < cachedAttributes.count; i++) {
        UICollectionViewLayoutAttributes *attributes = cachedAttributes[i];

        NSIndexPath *indexPath = attributes.indexPath;
        IBPNSCollectionLayoutItem *layoutItem = [layoutBuilder layoutItemAtIndexPath:indexPath];
        IBPNSCollectionLayoutSize *layoutSize = layoutItem.layoutSize;
        if (layoutSize.widthDimension.isEstimated || layoutSize.heightDimension.isEstimated) {
            if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                UICollectionViewCell *cell = [self.collectionView.dataSource collectionView:self.collectionView cellForItemAtIndexPath:attributes.indexPath];
                if (cell) {
                    CGSize containerSize = self.collectionViewContentSize;
                    if (!layoutSize.widthDimension.isEstimated) {
                        containerSize.width = attributes.frame.size.width;
                    }
                    if (!layoutSize.heightDimension.isEstimated) {
                        containerSize.height = attributes.frame.size.height;
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
                    if (f.size.height != fitSize.height) {
                        for (NSInteger j = i + 1; j < cachedAttributes.count; j++) {
                            UICollectionViewLayoutAttributes *attributes = cachedAttributes[j];
                            CGRect frame = attributes.frame;

                            if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical) {
                                frame.origin.y += fitSize.height - f.size.height;
                            }
                            if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                                frame.origin.x += fitSize.width - f.size.width;
                            }
                            attributes.frame = frame;
                        }
                    }
                    f.size = fitSize;
                    attributes.frame = f;

                    contentBounds = CGRectUnion(contentBounds, f);

                    [layoutAttributes addObject:attributes];
                } else {
                    [layoutAttributes addObject:attributes];
                }
            } else {
                [layoutAttributes addObject:attributes];
            }
        } else {
            [layoutAttributes addObject:attributes];
        }
    }

    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (!self.collectionView) {
        return NO;
    }

    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    switch (self.parentCollectionViewOrthogonalScrollingBehavior) {
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary: {
            CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
            return [layoutBuilder continuousGroupLeadingBoundaryTargetContentOffsetForProposedContentOffset:proposedContentOffset scrollingVelocity:velocity translation:translation];
        }
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging: {
            CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
            return [layoutBuilder groupPagingTargetContentOffsetForProposedContentOffset:self.collectionView.contentOffset scrollingVelocity:velocity translation:translation];
        }
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered:{
            CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
            return [layoutBuilder groupPagingCenteredTargetContentOffsetForProposedContentOffset:self.collectionView.contentOffset scrollingVelocity:velocity translation:translation containerSize:self.collectionView.bounds.size];
        }
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorNone:
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous:
        case IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorPaging:
            return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
}

@end
