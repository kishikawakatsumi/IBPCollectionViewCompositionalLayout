#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutSupplementaryItem.h"
#import "IBPNSRectAlignment.h"

@class IBPNSCollectionLayoutSize;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutBoundarySupplementaryItem : IBPNSCollectionLayoutSupplementaryItem<NSCopying>

+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(IBPNSRectAlignment)alignment;
+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(IBPNSRectAlignment)alignment
                                         absoluteOffset:(CGPoint)absoluteOffset;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic) BOOL extendsBoundary;
@property (nonatomic) BOOL pinToVisibleBounds;

@property (nonatomic, readonly) IBPNSRectAlignment alignment;
@property (nonatomic, readonly) CGPoint offset;

@end

NS_ASSUME_NONNULL_END
