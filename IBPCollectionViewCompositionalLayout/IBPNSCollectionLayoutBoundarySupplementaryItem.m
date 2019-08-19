#import "IBPNSCollectionLayoutBoundarySupplementaryItem.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSupplementaryItem_Private.h"

@interface IBPNSCollectionLayoutBoundarySupplementaryItem()

@property (nonatomic, readwrite) IBPNSRectAlignment alignment;
@property (nonatomic, readwrite) CGPoint offset;

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
    self = [super initWithLayoutSize:layoutSize supplementaryItems:@[]];
    if (self) {
        self.elementKind = elementKind;
        self.alignment = alignment;
        self.offset = absoluteOffset;
        self.extendsBoundary = YES;
        self.pinToVisibleBounds = NO;
    }
    return self;
}

@end
