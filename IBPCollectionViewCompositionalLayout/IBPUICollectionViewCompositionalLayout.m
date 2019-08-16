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
#import "IBPUICollectionViewCompositionalLayoutConfiguration_Private.h"

@interface IBPUICollectionViewCompositionalLayout() {
    NSMutableArray<UICollectionViewLayoutAttributes *> *cachedItemAttributes;

    CGRect contentFrame;
    NSMutableDictionary<NSNumber *, UICollectionViewOrthogonalScrollerSectionController *> *orthogonalScrollerSectionControllers;

    IBPCollectionViewLayoutBuilder *layoutBuilder;
}

@property (nonatomic, copy) IBPNSCollectionLayoutSection *layoutSection;
@property (nonatomic) IBPUICollectionViewCompositionalLayoutSectionProvider layoutSectionProvider;

@property (nonatomic) IBPUICollectionLayoutSectionOrthogonalScrollingBehavior parentCollectionViewOrthogonalScrollingBehavior;

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
    cachedItemAttributes = [[NSMutableArray alloc] init];
    orthogonalScrollerSectionControllers = [[NSMutableDictionary alloc] init];
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

    [[orthogonalScrollerSectionControllers allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [orthogonalScrollerSectionControllers removeAllObjects];

    UIEdgeInsets collectionContentInset = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        collectionContentInset = collectionView.safeAreaInsets;
    }
    IBPNSCollectionLayoutContainer *collectionContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:collectionViewBounds.size
                                                                                                        contentInsets:NSDirectionalEdgeInsetsMake(0, collectionContentInset.left, 0, collectionContentInset.right)];

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

        NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> *boundarySupplementaryItems = layoutSection.boundarySupplementaryItems;
        for (IBPNSCollectionLayoutBoundarySupplementaryItem *boundarySupplementaryItem in boundarySupplementaryItems) {
            UICollectionViewLayoutAttributes *boundarySupplementaryViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:boundarySupplementaryItem.elementKind
                                                                                                                                                   withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
            CGRect boundarySupplementaryViewFrame = contentFrame;

            IBPNSCollectionLayoutSize *boundarySupplementaryItemLayoutSize = boundarySupplementaryItem.layoutSize;

            CGSize boundarySupplementaryItemEffectiveSize = [boundarySupplementaryItemLayoutSize effectiveSizeForContainer:collectionContainer ignoringInsets:NO];
            boundarySupplementaryViewFrame.size = boundarySupplementaryItemEffectiveSize;

            NSRectAlignment alignment = boundarySupplementaryItem.alignment;
            if (alignment == NSRectAlignmentTop) {
                boundarySupplementaryViewFrame.origin.y = CGRectGetMinY(contentFrame);
                boundarySupplementaryViewFrame.origin.x += sectionOrigin.x;
                boundarySupplementaryViewFrame.origin.y += sectionOrigin.y;

                boundarySupplementaryViewFrame.origin.x += layoutSection.contentInsets.leading;
                boundarySupplementaryViewFrame.origin.y += layoutSection.contentInsets.top;
                boundarySupplementaryViewFrame.size.width -= layoutSection.contentInsets.leading + layoutSection.contentInsets.trailing;
                boundarySupplementaryViewFrame.size.height -= layoutSection.contentInsets.top + layoutSection.contentInsets.bottom;

                sectionOrigin.y += boundarySupplementaryItemEffectiveSize.height;

                boundarySupplementaryViewAttributes.frame = boundarySupplementaryViewFrame;
                [cachedItemAttributes addObject:boundarySupplementaryViewAttributes];

                contentFrame = CGRectUnion(contentFrame, boundarySupplementaryViewFrame);
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

        layoutBuilder = [[IBPCollectionViewLayoutBuilder alloc] initWithLayoutSection:layoutSection configuration:self.configuration];
        [layoutBuilder buildLayoutForContainer:collectionContainer traitCollection:environment.traitCollection];

        NSInteger numberOfItems = [collectionView numberOfItemsInSection:sectionIndex];
        for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            UICollectionViewLayoutAttributes *cellAttributes = [layoutBuilder layoutAttributesForItemAtIndexPath:indexPath];

            CGRect cellFrame = cellAttributes.frame;
            cellFrame.origin.x += sectionOrigin.x;
            cellFrame.origin.y += sectionOrigin.y;

            cellAttributes.frame = cellFrame;
            if (!layoutSection.scrollsOrthogonally) {
                [cachedItemAttributes addObject:cellAttributes];
            }

            IBPNSCollectionLayoutItem *layoutItem = [layoutBuilder layoutItemAtIndexPath:indexPath];
            NSMutableArray<UICollectionViewLayoutAttributes *> *itemAttributes = cachedItemAttributes;
            [layoutItem enumerateSupplementaryItemsWithHandler:^(IBPNSCollectionLayoutSupplementaryItem * _Nonnull supplementaryItem, BOOL * _Nonnull stop) {
                UICollectionViewLayoutAttributes *supplementaryViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:supplementaryItem.elementKind withIndexPath:indexPath];
                supplementaryViewAttributes.frame = [supplementaryItem frameInContainerFrame:cellFrame];
                [itemAttributes addObject:supplementaryViewAttributes];
            }];

            if (layoutSection.scrollsOrthogonally) {
                CGRect frame = CGRectZero;
                switch (self.scrollDirection) {
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

                contentFrame = CGRectUnion(contentFrame, frame);
            } else {
                contentFrame = CGRectUnion(contentFrame, CGRectInset(cellFrame, -layoutItem.contentInsets.trailing, -layoutItem.contentInsets.bottom));
            }
        }

        if (layoutSection.scrollsOrthogonally) {
            UICollectionViewOrthogonalScrollerSectionController *controller = orthogonalScrollerSectionControllers[@(sectionIndex)];
            if (!controller) {
                CGRect scrollViewFrame = layoutBuilder.containerFrame;
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
                controller = [[UICollectionViewOrthogonalScrollerSectionController alloc] initWithSectionIndex:sectionIndex collectionView:self.collectionView scrollView:scrollView];
                orthogonalScrollerSectionControllers[@(sectionIndex)] = controller;

                [collectionView addSubview:scrollView];
            }
        }

        for (IBPNSCollectionLayoutBoundarySupplementaryItem *boundarySupplementaryItem in boundarySupplementaryItems) {
            UICollectionViewLayoutAttributes *boundarySupplementaryViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:boundarySupplementaryItem.elementKind
                                                                                                                                                   withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
            CGRect boundarySupplementaryViewFrame = contentFrame;

            IBPNSCollectionLayoutSize *boundarySupplementaryItemLayoutSize = boundarySupplementaryItem.layoutSize;

            CGSize boundarySupplementaryItemEffectiveSize = [boundarySupplementaryItemLayoutSize effectiveSizeForContainer:collectionContainer ignoringInsets:NO];
            boundarySupplementaryViewFrame.size = boundarySupplementaryItemEffectiveSize;

            NSRectAlignment alignment = boundarySupplementaryItem.alignment;
            if (alignment == NSRectAlignmentBottom) {
                boundarySupplementaryViewFrame.origin.y = CGRectGetMaxY(contentFrame);
                boundarySupplementaryViewFrame.origin.x += sectionOrigin.x;

                boundarySupplementaryViewFrame.origin.x += layoutSection.contentInsets.leading;
                boundarySupplementaryViewFrame.origin.y += layoutSection.contentInsets.top;
                boundarySupplementaryViewFrame.size.width -= layoutSection.contentInsets.leading + layoutSection.contentInsets.trailing;
                boundarySupplementaryViewFrame.size.height -= layoutSection.contentInsets.top + layoutSection.contentInsets.bottom;

                sectionOrigin.y += boundarySupplementaryItemEffectiveSize.height;

                boundarySupplementaryViewAttributes.frame = boundarySupplementaryViewFrame;
                [cachedItemAttributes addObject:boundarySupplementaryViewAttributes];

                contentFrame = CGRectUnion(contentFrame, boundarySupplementaryViewFrame);
            }
        }


        NSArray<IBPNSCollectionLayoutDecorationItem *> *decorationItems = layoutSection.decorationItems;
        for (IBPNSCollectionLayoutDecorationItem *decorationItem in decorationItems) {
            UICollectionViewLayoutAttributes *decorationViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationItem.elementKind withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];

            CGRect decorationViewFrame = CGRectZero;
            decorationViewFrame.origin = sectionOrigin;

            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                decorationViewFrame.size.width += CGRectGetWidth(contentFrame) + layoutSection.contentInsets.leading;
                decorationViewFrame.size.height = CGRectGetMaxY(contentFrame) - sectionOrigin.y + layoutSection.contentInsets.top;
            }
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                decorationViewFrame.size.width = CGRectGetMaxX(contentFrame) - sectionOrigin.x;
                decorationViewFrame.size.height += CGRectGetHeight(contentFrame);
            }

            decorationViewFrame.origin.x += decorationItem.contentInsets.leading;
            decorationViewFrame.origin.y += decorationItem.contentInsets.top;
            decorationViewFrame.size.width -= decorationItem.contentInsets.leading + decorationItem.contentInsets.trailing;
            decorationViewFrame.size.height -= decorationItem.contentInsets.top + decorationItem.contentInsets.bottom;

            decorationViewAttributes.zIndex = decorationItem.zIndex;

            decorationViewAttributes.frame = decorationViewFrame;
            [cachedItemAttributes addObject:decorationViewAttributes];
        }

        CGRect insetsContentFrame = contentFrame;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            insetsContentFrame.origin.y += layoutSection.contentInsets.bottom;
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            insetsContentFrame.origin.x += layoutSection.contentInsets.trailing;
        }
        contentFrame = CGRectUnion(contentFrame, insetsContentFrame);
        contentFrame = CGRectUnion(contentFrame, contentFrame);
    }
}

- (CGSize)collectionViewContentSize {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
//        insets = self.collectionView.safeAreaInsets;
    }
    return UIEdgeInsetsInsetRect(contentFrame, insets).size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < cachedItemAttributes.count; i++) {
        UICollectionViewLayoutAttributes *attributes = cachedItemAttributes[i];

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
                        for (NSInteger j = i + 1; j < cachedItemAttributes.count; j++) {
                            UICollectionViewLayoutAttributes *attributes = cachedItemAttributes[j];
                            CGRect frame = attributes.frame;

                            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                                frame.origin.y += fitSize.height - f.size.height;
                            }
                            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                                frame.origin.x += fitSize.width - f.size.width;
                            }
                            attributes.frame = frame;
                        }
                    }
                    f.size = fitSize;
                    attributes.frame = f;

                    contentFrame = CGRectUnion(contentFrame, f);

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

- (UICollectionViewScrollDirection)scrollDirection {
    return self.configuration.scrollDirection;
}

@end
