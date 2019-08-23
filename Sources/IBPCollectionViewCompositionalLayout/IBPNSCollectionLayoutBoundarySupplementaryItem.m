#import "IBPNSCollectionLayoutBoundarySupplementaryItem.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSupplementaryItem_Private.h"
#import "IBPNSRectAlignment.h"

@interface IBPNSCollectionLayoutBoundarySupplementaryItem()

@property (nonatomic, readwrite) IBPNSRectAlignment alignment;
@property (nonatomic, readwrite) CGPoint offset;

- (instancetype)initWithSize:(IBPNSCollectionLayoutSize *)size
               contentInsets:(IBPNSDirectionalEdgeInsets)contentInsets
                 elementKind:(NSString *)elementKind
             containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor
                  itemAnchor:(IBPNSCollectionLayoutAnchor *)itemAnchor
                      zIndex:(NSInteger)zIndex
                   alignment:(IBPNSRectAlignment)alignment
                      offset:(CGPoint)offset
             extendsBoundary:(BOOL)extendsBoundary
          pinToVisibleBounds:(BOOL)pinToVisibleBounds;

@end

@implementation IBPNSCollectionLayoutBoundarySupplementaryItem

+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(IBPNSRectAlignment)alignment {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutBoundarySupplementaryItem") boundarySupplementaryItemWithLayoutSize:layoutSize
                                                                                                              elementKind:elementKind
                                                                                                                alignment:alignment
                                                                                                           absoluteOffset:CGPointZero];
    } else {
        return [self boundarySupplementaryItemWithLayoutSize:layoutSize
                                                 elementKind:elementKind
                                                   alignment:alignment
                                              absoluteOffset:CGPointZero];
    }
}

+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(IBPNSRectAlignment)alignment
                                         absoluteOffset:(CGPoint)absoluteOffset {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutBoundarySupplementaryItem") boundarySupplementaryItemWithLayoutSize:layoutSize
                                                                                                              elementKind:elementKind
                                                                                                                alignment:alignment
                                                                                                           absoluteOffset:absoluteOffset];
    } else {
        return [[self alloc] initWithLayoutSize:layoutSize
                                    elementKind:elementKind
                                      alignment:alignment
                                 absoluteOffset:absoluteOffset];
    }
}

- (instancetype)initWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                       elementKind:(NSString *)elementKind
                         alignment:(IBPNSRectAlignment)alignment
                    absoluteOffset:(CGPoint)absoluteOffset {
    return [self initWithSize:layoutSize
                contentInsets:IBPNSDirectionalEdgeInsetsZero
                  elementKind:elementKind
              containerAnchor:nil
                   itemAnchor:nil
                       zIndex:1
                    alignment:alignment
                       offset:absoluteOffset
              extendsBoundary:YES
           pinToVisibleBounds:NO];
}

- (instancetype)initWithSize:(IBPNSCollectionLayoutSize *)size
               contentInsets:(IBPNSDirectionalEdgeInsets)contentInsets
                 elementKind:(NSString *)elementKind
             containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor
                  itemAnchor:(IBPNSCollectionLayoutAnchor *)itemAnchor
                      zIndex:(NSInteger)zIndex
                   alignment:(IBPNSRectAlignment)alignment
                      offset:(CGPoint)offset
             extendsBoundary:(BOOL)extendsBoundary
          pinToVisibleBounds:(BOOL)pinToVisibleBounds {
    self = [super initWithSize:size
                 contentInsets:contentInsets
                   elementKind:elementKind
               containerAnchor:containerAnchor
                    itemAnchor:itemAnchor
                        zIndex:zIndex];
    if (self) {
        self.alignment = alignment;
        self.offset = offset;
        self.extendsBoundary = extendsBoundary;
        self.pinToVisibleBounds = pinToVisibleBounds;
    }
    return self;
}

@end
