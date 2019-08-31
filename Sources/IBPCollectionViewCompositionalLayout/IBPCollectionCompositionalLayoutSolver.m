#import "IBPCollectionCompositionalLayoutSolver.h"
#import "IBPCollectionCompositionalLayoutSolverResult.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutEdgeSpacing_Private.h"
#import "IBPNSCollectionLayoutEnvironment.h"
#import "IBPNSCollectionLayoutGroup_Private.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSection_Private.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutSpacing.h"

@interface IBPCollectionCompositionalLayoutSolver()

@property (nonatomic, readwrite, copy) IBPNSCollectionLayoutSection *layoutSection;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic) CGRect layoutFrame;
@property (nonatomic) CGRect contentFrame;
@property (nonatomic) NSMutableArray<IBPCollectionCompositionalLayoutSolverResult *> *results;

@end

@implementation IBPCollectionCompositionalLayoutSolver

+ (instancetype)solverWithLayoutSection:(IBPNSCollectionLayoutSection *)section
                        scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    return [[self alloc] initWithLayoutSection:section scrollDirection:scrollDirection];
}

- (instancetype)initWithLayoutSection:(IBPNSCollectionLayoutSection *)section
                      scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    self = [super init];
    if (self) {
        self.layoutSection = section;
        self.scrollDirection = scrollDirection;

        self.layoutFrame = CGRectZero;
        self.contentFrame = CGRectZero;
        self.results = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)solveForContainer:(IBPNSCollectionLayoutContainer *)container traitCollection:(UITraitCollection *)traitCollection {
    CGSize collectionContentSize = container.effectiveContentSize;

    IBPNSDirectionalEdgeInsets sectionContentInsets = self.layoutSection.contentInsets;
    IBPNSCollectionLayoutContainer *sectionContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:collectionContentSize
                                                                                                     contentInsets:sectionContentInsets];
    IBPNSCollectionLayoutSection *section = self.layoutSection;
    IBPNSCollectionLayoutGroup *group = section.group;

    CGSize groupContentSize = [group.layoutSize effectiveSizeForContainer:sectionContainer];
    IBPNSCollectionLayoutContainer *groupContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:groupContentSize
                                                                                                   contentInsets:group.contentInsets];
    CGRect layoutFrame = self.layoutFrame;
    layoutFrame.origin.x += sectionContentInsets.leading;
    layoutFrame.origin.y += sectionContentInsets.top;
    layoutFrame.size = groupContentSize;
    self.layoutFrame = layoutFrame;

    CGRect contentFrame = self.contentFrame;
    contentFrame.origin = layoutFrame.origin;
    self.contentFrame = contentFrame;

    [self solveGroup:group forContainer:groupContainer containerFrame:layoutFrame traitCollection:traitCollection];
}

- (void)solveGroup:(IBPNSCollectionLayoutGroup *)group forContainer:(IBPNSCollectionLayoutContainer *)container
    containerFrame:(CGRect)containerFrame traitCollection:(UITraitCollection *)traitCollection {
    __block CGRect contentFrame = self.contentFrame;
    contentFrame.origin.x += container.contentInsets.leading;
    contentFrame.origin.y += container.contentInsets.top;

    CGFloat interItemFixedSpacing = 0;
    if (group.interItemSpacing.isFixedSpacing) {
        interItemFixedSpacing = group.interItemSpacing.spacing;
    }
    CGFloat interItemFlexibleSpacing = 0;
    BOOL hasInterItemFlexibleSpacing = group.interItemSpacing.isFlexibleSpacing;
    if (hasInterItemFlexibleSpacing) {
        interItemFlexibleSpacing = group.interItemSpacing.spacing;
    }

    if (group.isCustomGroup) {
        IBPNSCollectionLayoutEnvironment *environment = [[IBPNSCollectionLayoutEnvironment alloc] init];
        environment.container = container;
        environment.traitCollection = traitCollection;

        NSArray<IBPNSCollectionLayoutGroupCustomItem *> *items = group.customGroupItemProvider(environment);
        for (IBPNSCollectionLayoutGroupCustomItem *item in items) {
            CGRect customFrame = item.frame;
            customFrame.origin.x += contentFrame.origin.x;
            customFrame.origin.y += contentFrame.origin.y;

            [self.results addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:nil frame:customFrame]];
        }
        return;
    }
    if (group.count > 0) {
        IBPNSCollectionLayoutItem *item = group.subitems[0];
        IBPNSDirectionalEdgeInsets contentInsets = item.contentInsets;

        contentFrame.origin.x += item.edgeSpacing.leading.spacing;
        contentFrame.origin.y += item.edgeSpacing.top.spacing;

        CGSize itemSize = [item.layoutSize effectiveSizeForContainer:container];
        IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:itemSize contentInsets:contentInsets];

        if (item.isGroup) {
            IBPNSCollectionLayoutGroup *nestedGroup = (IBPNSCollectionLayoutGroup *)item;

            if (group.isHorizontalGroup) {
                if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                    return;
                }
                itemSize.width = (CGRectGetWidth(containerFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            }
            if (group.isVerticalGroup) {
                if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                    return;
                }
                itemSize.height = (CGRectGetHeight(containerFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            }

            CGRect nestedContainerFrame = containerFrame;
            nestedContainerFrame.origin = contentFrame.origin;
            nestedContainerFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                self.contentFrame = contentFrame;
                [self solveGroup:nestedGroup forContainer:itemContainer containerFrame:nestedContainerFrame traitCollection:traitCollection];

                if (group.isHorizontalGroup) {
                    contentFrame.origin.x += interItemFixedSpacing + itemSize.width;
                }
                if (group.isVerticalGroup) {
                    contentFrame.origin.y += interItemFixedSpacing + itemSize.height;
                }
            }

            return;
        }

        if (group.isHorizontalGroup) {
            if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                return;
            }

            itemSize.width = (CGRectGetWidth(containerFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            contentFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                if (i > 0) {
                    cellFrame.origin.x += item.edgeSpacing.trailing.spacing;
                    cellFrame.size.width -= item.edgeSpacing.trailing.spacing;
                }
                [self.results addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                contentFrame.origin.x += interItemFixedSpacing + CGRectGetWidth(contentFrame);
            }
        }
        if (group.isVerticalGroup) {
            if (floor(CGRectGetMaxY(contentFrame)) > floor(CGRectGetMaxY(containerFrame))) {
                return;
            }

            itemSize.height = (CGRectGetHeight(containerFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            contentFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                if (i > 0) {
                    cellFrame.origin.y += item.edgeSpacing.bottom.spacing;
                    cellFrame.size.width -= item.edgeSpacing.bottom.spacing;
                }
                [self.results addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                contentFrame.origin.y += interItemFixedSpacing + CGRectGetHeight(contentFrame);
            }
        }
    } else {
        if (hasInterItemFlexibleSpacing) {
            CGSize totalSize = CGSizeZero;
            for (IBPNSCollectionLayoutItem *item in group.subitems) {
                CGSize effectiveSize = [item.layoutSize effectiveSizeForContainer:container ignoringInsets:YES];
                totalSize.width += effectiveSize.width;
                totalSize.height += effectiveSize.height;
            }
            if (group.isHorizontalGroup) {
                CGFloat actualSpacing = (CGRectGetWidth(containerFrame) - totalSize.width) / (group.subitems.count - 1);
                interItemFlexibleSpacing = actualSpacing;
            }
            if (group.isVerticalGroup) {
                CGFloat actualSpacing = (CGRectGetHeight(containerFrame) - totalSize.height) / (group.subitems.count - 1);
                interItemFlexibleSpacing = actualSpacing;
            }
        }
        NSMutableArray *groupedItemResults = [[NSMutableArray alloc] init];
        [group enumerateItemsWithHandler:^(IBPNSCollectionLayoutItem * _Nonnull item, BOOL * _Nonnull stop) {
            IBPNSDirectionalEdgeInsets contentInsets = item.contentInsets;

            contentFrame.origin.x += item.edgeSpacing.leading.spacing;
            contentFrame.origin.y += item.edgeSpacing.top.spacing;

            CGSize itemSize = [item.layoutSize effectiveSizeForContainer:container];
            IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:itemSize contentInsets:item.contentInsets];

            if (item.isGroup) {
                IBPNSCollectionLayoutGroup *nestedGroup = (IBPNSCollectionLayoutGroup *)item;

                CGRect nestedContainerFrame = containerFrame;
                nestedContainerFrame.origin = contentFrame.origin;
                nestedContainerFrame.size = [nestedGroup.layoutSize effectiveSizeForContainer:container];

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

                self.contentFrame = contentFrame;
                [self solveGroup:nestedGroup forContainer:itemContainer containerFrame:nestedContainerFrame traitCollection:traitCollection];

                if (group.isHorizontalGroup) {
                    if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(containerFrame))) {
                        *stop = YES;
                        return;
                    }
                    contentFrame.origin.x += itemSize.width + item.edgeSpacing.trailing.spacing + interItemFlexibleSpacing;
                }
                if (group.isVerticalGroup) {
                    if (floor(CGRectGetMaxY(contentFrame)) > floor(CGRectGetMaxY(containerFrame))) {
                        *stop = YES;
                        return;
                    }
                    contentFrame.origin.y += itemSize.height + item.edgeSpacing.bottom.spacing + interItemFlexibleSpacing;
                }

                if (group == self.layoutSection.group) {
                    if (self.scrollDirection == UICollectionViewScrollDirectionVertical && group.layoutSize.heightDimension.isEstimated) {
                        CGRect layoutFrame = self.layoutFrame;
                        layoutFrame.size.height = CGRectGetMaxY(contentFrame);
                        self.layoutFrame = layoutFrame;
                    }
                    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal && group.layoutSize.widthDimension.isEstimated) {
                        CGRect layoutFrame = self.layoutFrame;
                        layoutFrame.size.width = CGRectGetMaxY(contentFrame);
                        self.layoutFrame = layoutFrame;
                    }
                }

                return;
            }

            contentFrame.size = itemSize;
            if (group.isHorizontalGroup) {
                if (floor(CGRectGetMaxX(contentFrame)) + item.edgeSpacing.trailing.spacing > floor(CGRectGetMaxX(containerFrame))) {
                    *stop = YES;
                    return;
                }

                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                IBPCollectionCompositionalLayoutSolverResult *result = [IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame];
                [self.results addObject:result];
                [groupedItemResults addObject:result];
                contentFrame.origin.x += CGRectGetWidth(contentFrame) + interItemFixedSpacing + interItemFlexibleSpacing + item.edgeSpacing.trailing.spacing;
            }
            if (group.isVerticalGroup) {
                if (floor(CGRectGetMaxY(contentFrame) + item.edgeSpacing.bottom.spacing) > floor(CGRectGetMaxY(containerFrame))) {
                    *stop = YES;
                    return;
                }

                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                IBPCollectionCompositionalLayoutSolverResult *result = [IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame];
                [self.results addObject:result];
                [groupedItemResults addObject:result];
                contentFrame.origin.y += CGRectGetHeight(contentFrame) + interItemFixedSpacing + interItemFlexibleSpacing + item.edgeSpacing.bottom.spacing;
            }
        }];

        if (groupedItemResults.count > 0) {
            CGSize totalSize = CGSizeZero;
            NSInteger horizontalFlexibleSpacingCount = 0;
            NSInteger verticalFlexibleSpacingCount = 0;
            for (IBPCollectionCompositionalLayoutSolverResult *result in groupedItemResults) {
                totalSize.width += CGRectGetWidth(result.frame);
                totalSize.height += CGRectGetHeight(result.frame);

                IBPNSCollectionLayoutItem *item = result.layoutItem;
                IBPNSCollectionLayoutEdgeSpacing *edgeSpacing = item.edgeSpacing;
                if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeLeading]) {
                    horizontalFlexibleSpacingCount++;
                }
                if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeTrailing]) {
                    horizontalFlexibleSpacingCount++;
                }
                if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeTop]) {
                    verticalFlexibleSpacingCount++;
                }
                if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeBottom]) {
                    verticalFlexibleSpacingCount++;
                }
            }
            if (group.isHorizontalGroup && horizontalFlexibleSpacingCount > 0) {
                CGFloat actualSpacing = floor((CGRectGetWidth(containerFrame) - totalSize.width) / horizontalFlexibleSpacingCount);
                CGFloat trailingDelta = 0;
                for (IBPCollectionCompositionalLayoutSolverResult *result in groupedItemResults) {
                    IBPNSCollectionLayoutItem *item = result.layoutItem;
                    IBPNSCollectionLayoutEdgeSpacing *edgeSpacing = item.edgeSpacing;

                    CGRect frame = result.frame;
                    frame.origin.x += trailingDelta;

                    if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeLeading]) {
                        CGFloat delta = floor(actualSpacing - edgeSpacing.leading.spacing);
                        frame.origin.x += delta;
                        trailingDelta += delta;
                    }
                    if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeTrailing]) {
                        trailingDelta += floor(actualSpacing - edgeSpacing.trailing.spacing);
                    }
                    result.frame = frame;
                }
            }
            if (group.isVerticalGroup && verticalFlexibleSpacingCount > 0) {
                CGFloat actualSpacing = floor((CGRectGetHeight(containerFrame) - totalSize.height) / verticalFlexibleSpacingCount);
                CGFloat bottomDelta = 0;
                for (IBPCollectionCompositionalLayoutSolverResult *result in groupedItemResults) {
                    IBPNSCollectionLayoutItem *item = result.layoutItem;
                    IBPNSCollectionLayoutEdgeSpacing *edgeSpacing = item.edgeSpacing;

                    CGRect frame = result.frame;
                    frame.origin.y += bottomDelta;

                    if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeTop]) {
                        CGFloat delta = floor(actualSpacing - edgeSpacing.top.spacing);
                        frame.origin.y += delta;
                        bottomDelta += delta;
                    }
                    if ([edgeSpacing isSpacingFlexibleForEdge:IBPNSDirectionalRectEdgeBottom]) {
                        bottomDelta += floor(actualSpacing - edgeSpacing.bottom.spacing);
                    }
                    result.frame = frame;
                }
            }
        }

        if (hasInterItemFlexibleSpacing && groupedItemResults.count > 1) {
            CGSize totalSize = CGSizeZero;
            for (IBPCollectionCompositionalLayoutSolverResult *result in groupedItemResults) {
                totalSize.width += CGRectGetWidth(result.frame);
                totalSize.height += CGRectGetHeight(result.frame);
            }
            if (group.isHorizontalGroup) {
                CGFloat actualSpacing = (CGRectGetWidth(containerFrame) - totalSize.width) / (groupedItemResults.count - 1);
                CGFloat delta = floor(actualSpacing - interItemFlexibleSpacing);
                for (NSInteger i = 1; i < groupedItemResults.count; i++) {
                    IBPCollectionCompositionalLayoutSolverResult *result = groupedItemResults[i];
                    CGRect frame = result.frame;
                    frame.origin.x += delta * i;
                    result.frame = frame;
                }
            }
            if (group.isVerticalGroup) {
                CGFloat actualSpacing = (CGRectGetHeight(containerFrame) - totalSize.height) / (groupedItemResults.count - 1);
                CGFloat delta = floor(actualSpacing - interItemFlexibleSpacing);
                for (NSInteger i = 1; i < groupedItemResults.count; i++) {
                    IBPCollectionCompositionalLayoutSolverResult *result = groupedItemResults[i];
                    CGRect frame = result.frame;
                    frame.origin.y += delta * i;
                    result.frame = frame;
                }
            }
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<IBPCollectionCompositionalLayoutSolverResult *> *results = self.results;
    NSInteger count = results.count;

    CGFloat interGroupSpacing = self.layoutSection.interGroupSpacing;
    CGPoint offset = CGPointZero;

    BOOL scrollsOrthogonally = self.layoutSection.scrollsOrthogonally;
    UICollectionViewScrollDirection scrollDirection = self.scrollDirection;
    if (scrollsOrthogonally) {
        scrollDirection = scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    }
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset.y += CGRectGetHeight(self.layoutFrame) * (indexPath.item / count) + interGroupSpacing * (indexPath.item / count);
    }
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        offset.x += CGRectGetWidth(self.layoutFrame) * (indexPath.item / count) + interGroupSpacing * (indexPath.item / count);
    }

    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    IBPCollectionCompositionalLayoutSolverResult *result = [results objectAtIndex:indexPath.item % count];

    CGRect frame = result.frame;
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    layoutAttributes.frame = frame;

    return layoutAttributes;
}

- (IBPNSCollectionLayoutItem *)layoutItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<IBPCollectionCompositionalLayoutSolverResult *> *results = self.results;
    IBPCollectionCompositionalLayoutSolverResult *result = [results objectAtIndex:indexPath.item % results.count];
    return result.layoutItem;
}

@end
