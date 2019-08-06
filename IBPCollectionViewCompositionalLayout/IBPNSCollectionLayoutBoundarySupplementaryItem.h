#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutSupplementaryItem.h"
#import "NSRectAlignment.h"

@class IBPNSCollectionLayoutSize;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutBoundarySupplementaryItem : IBPNSCollectionLayoutSupplementaryItem<NSCopying>

+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(NSRectAlignment)alignment;
+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(NSRectAlignment)alignment
                                         absoluteOffset:(CGPoint)absoluteOffset;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic) BOOL extendsBoundary;
@property (nonatomic) BOOL pinToVisibleBounds;

@property (nonatomic, readonly) NSRectAlignment alignment;
@property (nonatomic, readonly) CGPoint offset;

@end

NS_ASSUME_NONNULL_END
