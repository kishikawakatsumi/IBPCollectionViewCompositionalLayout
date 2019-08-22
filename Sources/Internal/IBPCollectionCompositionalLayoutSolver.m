#import "IBPCollectionCompositionalLayoutSolver.h"
#import "IBPCollectionCompositionalLayoutSolverResult.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutDimension.h"
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
    IBPNSCollectionLayoutContainer *sectionContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:collectionContentSize contentInsets:sectionContentInsets];

    IBPNSCollectionLayoutSection *section = self.layoutSection;
    IBPNSCollectionLayoutGroup *group = section.group;

    CGSize groupContentSize = [group.layoutSize effectiveSizeForContainer:sectionContainer];
    IBPNSCollectionLayoutContainer *groupContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:groupContentSize contentInsets:group.contentInsets];

    CGRect layoutFrame = self.layoutFrame;
    layoutFrame.origin.x += sectionContentInsets.leading;
    layoutFrame.origin.y += sectionContentInsets.top;
    layoutFrame.size = groupContentSize;
    self.layoutFrame = layoutFrame;

    CGRect contentFrame = self.contentFrame;
    contentFrame.origin = layoutFrame.origin;
    self.contentFrame = contentFrame;

    [self solveGroup:group forContainer:groupContainer];
}

- (void)solveGroup:(IBPNSCollectionLayoutGroup *)group forContainer:(IBPNSCollectionLayoutContainer *)groupContainer {
    CGRect layoutFrame = self.layoutFrame;
    __block CGRect contentFrame = self.contentFrame;

    CGFloat interItemFixedSpacing = 0;
    if (group.interItemSpacing.isFixedSpacing) {
        interItemFixedSpacing = group.interItemSpacing.spacing;
    }
    CGFloat interItemFlexibleSpacing = 0;
    if (group.interItemSpacing.isFlexibleSpacing) {
        interItemFlexibleSpacing = group.interItemSpacing.spacing;
    }

    if (group.count > 0) {
        IBPNSCollectionLayoutItem *item = group.subitems[0];
        IBPNSDirectionalEdgeInsets contentInsets = item.contentInsets;

        CGSize itemSize = [item.layoutSize effectiveSizeForContainer:groupContainer];
        IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:itemSize contentInsets:contentInsets];

        if (item.isGroup) {
            IBPNSCollectionLayoutGroup *nestedGroup = (IBPNSCollectionLayoutGroup *)item;

            if (group.isHorizontalGroup) {
                if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(layoutFrame))) {
                    return;
                }
                itemSize.width = (CGRectGetWidth(layoutFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            }
            if (group.isVerticalGroup) {
                if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(layoutFrame))) {
                    return;
                }
                itemSize.height = (CGRectGetHeight(layoutFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            }

            CGRect nestedContainerFrame = layoutFrame;
            nestedContainerFrame.origin = contentFrame.origin;
            nestedContainerFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                self.contentFrame = contentFrame;
                [self solveGroup:nestedGroup forContainer:itemContainer];

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
            if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(layoutFrame))) {
                return;
            }

            itemSize.width = (CGRectGetWidth(layoutFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            contentFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                [self.results addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                contentFrame.origin.x += interItemFixedSpacing + CGRectGetWidth(contentFrame);
            }
        }
        if (group.isVerticalGroup) {
            if (floor(CGRectGetMaxY(contentFrame)) > floor(CGRectGetMaxY(layoutFrame))) {
                return;
            }

            itemSize.height = (CGRectGetHeight(layoutFrame) - interItemFixedSpacing * (group.count - 1)) / group.count;
            contentFrame.size = itemSize;

            for (NSInteger i = 0; i < group.count; i++) {
                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                [self.results addObject:[IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame]];
                contentFrame.origin.y += interItemFixedSpacing + CGRectGetHeight(contentFrame);
            }
        }
    } else {
        NSMutableArray *groupedItemResults = [[NSMutableArray alloc] init];
        [group enumerateItemsWithHandler:^(IBPNSCollectionLayoutItem * _Nonnull item, BOOL * _Nonnull stop) {
            IBPNSDirectionalEdgeInsets contentInsets = item.contentInsets;

            CGSize itemSize = [item.layoutSize effectiveSizeForContainer:groupContainer];
            IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:itemSize contentInsets:item.contentInsets];

            if (item.isGroup) {
                IBPNSCollectionLayoutGroup *nestedGroup = (IBPNSCollectionLayoutGroup *)item;

                CGRect nestedContainerFrame = layoutFrame;
                nestedContainerFrame.origin = contentFrame.origin;
                nestedContainerFrame.size = [nestedGroup.layoutSize effectiveSizeForContainer:groupContainer];

                if (group.isHorizontalGroup) {
                    if (floor(CGRectGetMaxX(nestedContainerFrame)) > floor(CGRectGetMaxX(layoutFrame))) {
                        *stop = YES;
                        return;
                    }
                }
                if (group.isVerticalGroup) {
                    if (floor(CGRectGetMaxY(nestedContainerFrame)) > floor(CGRectGetMaxY(layoutFrame))) {
                        *stop = YES;
                        return;
                    }
                }
                self.contentFrame = contentFrame;

                [self solveGroup:nestedGroup forContainer:itemContainer];

                if (group.isHorizontalGroup) {
                    if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(layoutFrame))) {
                        *stop = YES;
                        return;
                    }
                    contentFrame.origin.x += itemSize.width;
                }
                if (group.isVerticalGroup) {
                    if (floor(CGRectGetMaxY(contentFrame)) > floor(CGRectGetMaxY(layoutFrame))) {
                        *stop = YES;
                        return;
                    }
                    contentFrame.origin.y += itemSize.height;
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
                if (floor(CGRectGetMaxX(contentFrame)) > floor(CGRectGetMaxX(layoutFrame))) {
                    *stop = YES;
                    return;
                }

                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                IBPCollectionCompositionalLayoutSolverResult *result = [IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame];
                [self.results addObject:result];
                [groupedItemResults addObject:result];
                contentFrame.origin.x += CGRectGetWidth(contentFrame) + interItemFixedSpacing + interItemFlexibleSpacing;
            }
            if (group.isVerticalGroup) {
                if (floor(CGRectGetMaxY(contentFrame)) > floor(CGRectGetMaxY(layoutFrame))) {
                    *stop = YES;
                    return;
                }

                CGRect cellFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing));
                IBPCollectionCompositionalLayoutSolverResult *result = [IBPCollectionCompositionalLayoutSolverResult resultWithLayoutItem:item frame:cellFrame];
                [self.results addObject:result];
                [groupedItemResults addObject:result];
                contentFrame.origin.y += CGRectGetHeight(contentFrame) + interItemFixedSpacing + interItemFlexibleSpacing;
            }
        }];
        if (interItemFlexibleSpacing > 0 &&  groupedItemResults.count > 1) {
            CGSize totalSize = CGSizeZero;
            for (IBPCollectionCompositionalLayoutSolverResult *result in groupedItemResults) {
                totalSize.width += CGRectGetWidth(result.frame);
                totalSize.height += CGRectGetHeight(result.frame);
            }
            if (group.isHorizontalGroup) {
                CGFloat actualSpacing = (CGRectGetWidth(layoutFrame) - totalSize.width) / (groupedItemResults.count - 1);
                CGFloat delta = floor(actualSpacing - interItemFlexibleSpacing);
                for (NSInteger i = 1; i < groupedItemResults.count; i++) {
                    IBPCollectionCompositionalLayoutSolverResult *result = groupedItemResults[i];
                    CGRect frame = result.frame;
                    frame.origin.x += delta * i;
                    result.frame = frame;
                }
            }
            if (group.isVerticalGroup) {
                CGFloat actualSpacing = (CGRectGetHeight(layoutFrame) - totalSize.height) / (groupedItemResults.count - 1);
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
