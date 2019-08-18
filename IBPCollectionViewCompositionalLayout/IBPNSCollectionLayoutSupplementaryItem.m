#import "IBPNSCollectionLayoutSupplementaryItem.h"
#import "IBPNSCollectionLayoutSupplementaryItem_Private.h"
#import "IBPNSCollectionLayoutAnchor.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSize_Private.h"

@implementation IBPNSCollectionLayoutSupplementaryItem

+ (instancetype)supplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    elementKind:(NSString *)elementKind
                                containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutSupplementaryItem") supplementaryItemWithLayoutSize:layoutSize
                                                                                              elementKind:elementKind
                                                                                          containerAnchor:containerAnchor];
    } else {
        return [[self alloc] initWithLayoutSize:layoutSize elementKind:elementKind containerAnchor:containerAnchor itemAnchor:nil];
    }
}

+ (instancetype)supplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    elementKind:(NSString *)elementKind
                                containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor
                                     itemAnchor:(IBPNSCollectionLayoutAnchor *)itemAnchor {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutSupplementaryItem") supplementaryItemWithLayoutSize:layoutSize
                                                                                              elementKind:elementKind
                                                                                          containerAnchor:containerAnchor
                                                                                               itemAnchor:itemAnchor];
    } else {
        return [[self alloc] initWithLayoutSize:layoutSize elementKind:elementKind containerAnchor:containerAnchor itemAnchor:itemAnchor];
    }
}

- (instancetype)initWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                       elementKind:(NSString *)elementKind
                   containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor
                        itemAnchor:(nullable IBPNSCollectionLayoutAnchor *)itemAnchor {
    self = [super initWithLayoutSize:layoutSize supplementaryItems:@[self]];
    if (self) {
        self.elementKind = elementKind;
        self.containerAnchor = containerAnchor;
        self.itemAnchor = itemAnchor;
    }
    return self;
}

- (CGRect)frameInContainerFrame:(CGRect)containerFrame {
    CGRect frame = containerFrame;

    IBPNSCollectionLayoutSize *supplementaryItemLayoutSize = self.layoutSize;

    IBPNSCollectionLayoutContainer *itemContainer = [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:containerFrame.size
                                                                                            contentInsets:IBPNSDirectionalEdgeInsetsZero];
    CGSize supplementaryItemEffectiveSize = [supplementaryItemLayoutSize effectiveSizeForContainer:itemContainer];
    frame.size = supplementaryItemEffectiveSize;

    IBPNSCollectionLayoutAnchor *containerAnchor = self.containerAnchor;
    CGPoint offset = containerAnchor.offset;
    IBPNSDirectionalRectEdge edges = containerAnchor.edges;

    if ((edges & IBPNSDirectionalRectEdgeTop) == IBPNSDirectionalRectEdgeTop) {
        frame.origin.y = CGRectGetMinY(containerFrame);
        frame.origin.y += containerAnchor.isAbsoluteOffset ? offset.y : supplementaryItemEffectiveSize.height * offset.y;
    }
    if ((edges & IBPNSDirectionalRectEdgeLeading) == IBPNSDirectionalRectEdgeLeading) {
        frame.origin.x = CGRectGetMinX(containerFrame);
        frame.origin.x += containerAnchor.isAbsoluteOffset ? offset.x : supplementaryItemEffectiveSize.width * offset.x;
    }
    if ((edges & IBPNSDirectionalRectEdgeBottom) == IBPNSDirectionalRectEdgeBottom) {
        frame.origin.y = CGRectGetMaxY(containerFrame) - supplementaryItemEffectiveSize.height;
        frame.origin.y += containerAnchor.isAbsoluteOffset ? offset.y : supplementaryItemEffectiveSize.height * offset.y;
    }
    if ((edges & IBPNSDirectionalRectEdgeTrailing) == IBPNSDirectionalRectEdgeTrailing) {
        frame.origin.x = CGRectGetMaxX(containerFrame) - supplementaryItemEffectiveSize.width;
        frame.origin.x += containerAnchor.isAbsoluteOffset ? offset.x : supplementaryItemEffectiveSize.width * offset.x;
    }

    return frame;
}

@end
