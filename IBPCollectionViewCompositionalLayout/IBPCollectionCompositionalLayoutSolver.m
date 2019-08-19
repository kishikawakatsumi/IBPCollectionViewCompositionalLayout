#import "IBPCollectionCompositionalLayoutSolver.h"
#import "IBPCollectionCompositionalLayoutSolverState.h"
#import "IBPCollectionCompositionalLayoutSolverResult.h"
#import "IBPNSCollectionLayoutAnchor.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutGroup_Private.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutSection_Private.h"
#import "IBPNSCollectionLayoutSpacing.h"
#import "IBPNSCollectionLayoutSupplementaryItem.h"
#import "IBPUICollectionViewCompositionalLayoutConfiguration.h"

@interface IBPCollectionCompositionalLayoutSolver()

@property (nonatomic, readwrite, copy) IBPNSCollectionLayoutSection *section;
@property (nonatomic, readwrite, copy) IBPUICollectionViewCompositionalLayoutConfiguration *configuration;
@property (nonatomic) IBPCollectionCompositionalLayoutSolverState *state;

@end

@implementation IBPCollectionCompositionalLayoutSolver

- (instancetype)initWithLayoutSection:(IBPNSCollectionLayoutSection *)section {
    return [self initWithLayoutSection:section configuration:[[IBPUICollectionViewCompositionalLayoutConfiguration alloc] init]];
}

- (instancetype)initWithLayoutSection:(IBPNSCollectionLayoutSection *)section
                        configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.section = section;
        self.configuration = configuration;
        self.state = [[IBPCollectionCompositionalLayoutSolverState alloc] init];
        self.state.scrollDirection = configuration.scrollDirection;
    }
    return self;
}

- (void)solveLayoutForContainer:(IBPNSCollectionLayoutContainer *)container
          traitCollection:(UITraitCollection *)traitCollection {
    CGSize collectionContentSize = container.effectiveContentSize;

    IBPNSDirectionalEdgeInsets sectionContentInsets = self.section.contentInsets;
    IBPNSCollectionLayoutContainer *sectionContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:collectionContentSize contentInsets:sectionContentInsets];

    IBPNSCollectionLayoutSection *section = self.section;
    IBPNSCollectionLayoutGroup *group = section.group;

    CGSize groupContentSize = [group.layoutSize effectiveSizeForContainer:sectionContainer];
    IBPNSCollectionLayoutContainer *groupContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:groupContentSize contentInsets:group.contentInsets];

    CGRect rootGroupFrame = self.state.rootGroupFrame;
    rootGroupFrame.origin.x += sectionContentInsets.leading;
    rootGroupFrame.origin.y += sectionContentInsets.top;
    rootGroupFrame.size = groupContentSize;
    self.state.rootGroupFrame = rootGroupFrame;

    CGRect itemFrame = CGRectZero;
    itemFrame.origin = rootGroupFrame.origin;
    self.state.currentItemFrame = itemFrame;

    [self solveLayoutForGroup:group inContainer:groupContainer containerFrame:rootGroupFrame state:self.state];
}

- (void)solveLayoutForGroup:(IBPNSCollectionLayoutGroup *)group inContainer:(IBPNSCollectionLayoutContainer *)groupContainer containerFrame:(CGRect)containerFrame state:(IBPCollectionCompositionalLayoutSolverState *)state {
    __block CGRect currentItemFrame = state.currentItemFrame;

    CGFloat interItemSpacing = 0;
    if (group.interItemSpacing.isFixedSpacing) {
        interItemSpacing = group.interItemSpacing.spacing;
    }

    if (group.count > 0) {
        IBPNSCollectionLayoutItem *item = group.subitems[0];
        IBPNSDirectionalEdgeInsets contentInsets = item.contentInsets;

        CGSize itemSize = [item.layoutSize effectiveSizeForContainer:groupContainer];
        IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:itemSize contentInsets:contentInsets];

        if (item.isGroup) {
            IBPNSCollectionLayoutGroup *nestedGroup = (IBPNSCollectionLayoutGroup *)item;

            if (group.isHorizontalGroup) {
                if (floor(CGRectGetMaxX(currentItemFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                    return;
                }
                itemSize.width = (CGRectGetWidth(containerFrame) - interItemSpacing * (group.count - 1)) / group.count;
            }
            if (group.isVerticalGroup) {
                if (floor(CGRectGetMaxX(currentItemFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                    return;
                }
                itemSize.height = (CGRectGetHeight(containerFrame) - interItemSpacing * (group.count - 1)) / group.count;
            }

            CGRect nestedContainerFrame = containerFrame;
            nestedContainerFrame.origin = currentItemFrame.origin;
            nestedContainerFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                state.currentItemFrame = currentItemFrame;
                [self solveLayoutForGroup:nestedGroup inContainer:itemContainer containerFrame:nestedContainerFrame state:state];

                if (group.isHorizontalGroup) {
                    currentItemFrame.origin.x += interItemSpacing + itemSize.width;
                }
                if (group.isVerticalGroup) {
                    currentItemFrame.origin.y += interItemSpacing + itemSize.height;
                }
            }

            return;
        }

        if (group.isHorizontalGroup) {
            if (floor(CGRectGetMaxX(currentItemFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                return;
            }

            itemSize.width = (CGRectGetWidth(containerFrame) - interItemSpacing * (group.count - 1)) / group.count;
            currentItemFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                CGRect cellFrame = UIEdgeInsetsInsetRect(currentItemFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.trailing, contentInsets.bottom));
                [self.state.itemResults addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                currentItemFrame.origin.x += interItemSpacing + CGRectGetWidth(currentItemFrame);
            }
        }
        if (group.isVerticalGroup) {
            if (floor(CGRectGetMaxY(currentItemFrame)) > floor(CGRectGetMaxY(containerFrame))) {
                return;
            }

            itemSize.height = (CGRectGetHeight(containerFrame) - interItemSpacing * (group.count - 1)) / group.count;
            currentItemFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                CGRect cellFrame = UIEdgeInsetsInsetRect(currentItemFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.trailing, contentInsets.bottom));
                [self.state.itemResults addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                currentItemFrame.origin.y += interItemSpacing + CGRectGetHeight(currentItemFrame);
            }
        }
    } else {
        [group enumerateItemsWithHandler:^(IBPNSCollectionLayoutItem * _Nonnull item, BOOL * _Nonnull stop) {
            IBPNSDirectionalEdgeInsets contentInsets = item.contentInsets;

            CGSize itemSize = [item.layoutSize effectiveSizeForContainer:groupContainer];
            IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:itemSize contentInsets:item.contentInsets];

            if (item.isGroup) {
                IBPNSCollectionLayoutGroup *nestedGroup = (IBPNSCollectionLayoutGroup *)item;

                CGRect nestedContainerFrame = containerFrame;
                nestedContainerFrame.origin = currentItemFrame.origin;
                nestedContainerFrame.size = [nestedGroup.layoutSize effectiveSizeForContainer:groupContainer];

                if (group.isHorizontalGroup) {
                    if (floor(CGRectGetMaxX(nestedContainerFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                        *stop = YES;
                        return;
                    }
                }
                if (group.isVerticalGroup) {
                    if (floor(CGRectGetMaxY(nestedContainerFrame)) > floor(CGRectGetMaxY(containerFrame))) {
                        *stop = YES;
                        return;
                    }
                }
                state.currentItemFrame = currentItemFrame;

                [self solveLayoutForGroup:nestedGroup inContainer:itemContainer containerFrame:nestedContainerFrame state:state];

                if (group.isHorizontalGroup) {
                    if (floor(CGRectGetMaxX(currentItemFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                        *stop = YES;
                        return;
                    }
                    currentItemFrame.origin.x += itemSize.width;
                }
                if (group.isVerticalGroup) {
                    if (floor(CGRectGetMaxY(currentItemFrame)) > floor(CGRectGetMaxY(containerFrame))) {
                        *stop = YES;
                        return;
                    }
                    currentItemFrame.origin.y += itemSize.height;
                }

                if (group == self.section.group) {
                    if (self.configuration.scrollDirection == UICollectionViewScrollDirectionVertical && self.section.group.layoutSize.heightDimension.isEstimated) {
                        CGRect rootGroupFrame = self.state.rootGroupFrame;
                        rootGroupFrame.size.height = CGRectGetMaxY(currentItemFrame);
                        self.state.rootGroupFrame = rootGroupFrame;
                    }
                    if (self.configuration.scrollDirection == UICollectionViewScrollDirectionHorizontal && self.section.group.layoutSize.widthDimension.isEstimated) {
                        CGRect rootGroupFrame = self.state.rootGroupFrame;
                        rootGroupFrame.size.width = CGRectGetMaxY(currentItemFrame);
                        self.state.rootGroupFrame = rootGroupFrame;
                    }
                }

                return;
            }

            currentItemFrame.size = itemSize;
            if (group.isHorizontalGroup) {
                if (floor(CGRectGetMaxX(currentItemFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                    *stop = YES;
                    return;
                }

                CGRect cellFrame = UIEdgeInsetsInsetRect(currentItemFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.trailing, contentInsets.bottom));
                [self.state.itemResults addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                currentItemFrame.origin.x += CGRectGetWidth(currentItemFrame);
            }
            if (group.isVerticalGroup) {
                if (floor(CGRectGetMaxY(currentItemFrame)) > floor(CGRectGetMaxY(containerFrame))) {
                    *stop = YES;
                    return;
                }

                CGRect cellFrame = UIEdgeInsetsInsetRect(currentItemFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.trailing, contentInsets.bottom));
                [self.state.itemResults addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                currentItemFrame.origin.y += CGRectGetHeight(currentItemFrame);
            }
        }];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<IBPCollectionCompositionalLayoutSolverResult *> *itemResults = self.state.itemResults;
    NSInteger itemCount = itemResults.count;

    CGFloat interGroupSpacing = self.section.interGroupSpacing;
    CGPoint offset = CGPointZero;

    BOOL scrollsOrthogonally = self.section.scrollsOrthogonally;
    UICollectionViewScrollDirection scrollDirection = self.state.scrollDirection;
    if (scrollsOrthogonally) {
        scrollDirection = scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    }
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset.y += CGRectGetHeight(self.state.rootGroupFrame) * (indexPath.item / itemCount) + interGroupSpacing * (indexPath.row / itemCount);
    }
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        offset.x += CGRectGetWidth(self.state.rootGroupFrame) * (indexPath.item / itemCount) + interGroupSpacing * (indexPath.row / itemCount);
    }

    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    IBPCollectionCompositionalLayoutSolverResult *result = [itemResults objectAtIndex:indexPath.row % itemCount];

    CGRect itemFrame = result.frame;
    itemFrame.origin.x += offset.x;
    itemFrame.origin.y += offset.y;

    layoutAttributes.frame = itemFrame;

    return layoutAttributes;
}

- (IBPNSCollectionLayoutItem *)layoutItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<IBPCollectionCompositionalLayoutSolverResult *> *itemResults = self.state.itemResults;
    NSInteger itemCount = itemResults.count;

    IBPCollectionCompositionalLayoutSolverResult *result = [itemResults objectAtIndex:indexPath.row % itemCount];
    return result.layoutItem;
}

- (CGRect)containerFrame {
    return self.state.rootGroupFrame;
}

- (CGPoint)continuousGroupLeadingBoundaryTargetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                                                   scrollingVelocity:(CGPoint)velocity
                                                                         translation:(CGPoint)translation {
    CGPoint targetContentOffset = CGPointZero;

    CGRect rootGroupFrame = self.state.rootGroupFrame;
    CGFloat interGroupSpacing = self.section.interGroupSpacing;

    CGFloat groupWidth = CGRectGetWidth(rootGroupFrame);
    CGFloat groupHeight = CGRectGetHeight(rootGroupFrame);

    BOOL scrollsOrthogonally = self.section.scrollsOrthogonally;
    UICollectionViewScrollDirection scrollDirection = self.state.scrollDirection;
    if (scrollsOrthogonally) {
        scrollDirection = scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    }
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        targetContentOffset.y += groupHeight * floor(proposedContentOffset.y / groupHeight) + interGroupSpacing * floor(proposedContentOffset.y / groupHeight) + groupHeight * (translation.y < 0 ? 1 : 0);
    }
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        targetContentOffset.x += groupWidth * floor(proposedContentOffset.x / groupWidth) + interGroupSpacing * floor(proposedContentOffset.x / groupWidth) + groupWidth * (translation.x < 0 ? 1 : 0);
    }

    return targetContentOffset;
}

- (CGPoint)groupPagingTargetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                                scrollingVelocity:(CGPoint)velocity
                                                      translation:(CGPoint)translation {
    CGPoint targetContentOffset = CGPointZero;

    CGRect rootGroupFrame = self.state.rootGroupFrame;
    CGFloat interGroupSpacing = self.section.interGroupSpacing;

    CGFloat groupWidth = CGRectGetWidth(rootGroupFrame);
    CGFloat groupHeight = CGRectGetHeight(rootGroupFrame);

    if (fabs(velocity.x) > 0.2) {
        translation.x = groupWidth / 2 * (translation.x < 0 ? -1 : 1);
    }

    targetContentOffset.x += groupWidth * round((proposedContentOffset.x + translation.x) / groupWidth);
    targetContentOffset.y += groupHeight * round((proposedContentOffset.y + translation.y) / groupHeight);

    BOOL scrollsOrthogonally = self.section.scrollsOrthogonally;
    UICollectionViewScrollDirection scrollDirection = self.state.scrollDirection;
    if (scrollsOrthogonally) {
        scrollDirection = scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    }
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        targetContentOffset.y += groupHeight * round(-translation.y / (groupHeight / 2)) + interGroupSpacing * round(-translation.y / (groupHeight / 2));
    }
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        targetContentOffset.x += groupWidth * round(-translation.x / (groupWidth / 2)) + interGroupSpacing * round(-translation.x / (groupWidth / 2));
    }

    return targetContentOffset;
}


- (CGPoint)groupPagingCenteredTargetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                                        scrollingVelocity:(CGPoint)velocity
                                                              translation:(CGPoint)translation
                                                            containerSize:(CGSize)containerSize {
    CGPoint targetContentOffset = CGPointZero;

    CGRect rootGroupFrame = self.state.rootGroupFrame;
    CGFloat interGroupSpacing = self.section.interGroupSpacing;

    CGFloat groupWidth = CGRectGetWidth(rootGroupFrame);
    CGFloat groupHeight = CGRectGetHeight(rootGroupFrame);

    if (fabs(velocity.x) > 0.2) {
        translation.x = groupWidth / 2 * (translation.x < 0 ? -1 : 1);
    }

    targetContentOffset.x += groupWidth * round((proposedContentOffset.x + translation.x) / groupWidth);
    targetContentOffset.y += groupHeight * round((proposedContentOffset.y + translation.y) / groupHeight);

    BOOL scrollsOrthogonally = self.section.scrollsOrthogonally;
    UICollectionViewScrollDirection scrollDirection = self.state.scrollDirection;
    if (scrollsOrthogonally) {
        scrollDirection = scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    }
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        targetContentOffset.y += groupHeight * round(-translation.y / (groupHeight / 2)) + interGroupSpacing * round(-translation.y / (groupHeight / 2)) - (containerSize.height - groupHeight) / 2;
    }
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        targetContentOffset.x += groupWidth * round(-translation.x / (groupWidth / 2)) + interGroupSpacing * round(-translation.x / (groupWidth / 2)) - (containerSize.width - groupWidth) / 2;
    }

    return targetContentOffset;
}

@end
