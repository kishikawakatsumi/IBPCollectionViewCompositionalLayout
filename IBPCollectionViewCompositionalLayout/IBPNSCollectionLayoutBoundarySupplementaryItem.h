#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutSupplementaryItem.h"
#import "IBPNSRectAlignment.h"

@class IBPNSCollectionLayoutSize;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutBoundarySupplementaryItem : IBPNSCollectionLayoutSupplementaryItem<NSCopying>

// Specify the alignment of the supplementary relative the containing geometry's coordinate space to
// position the boundary supplementary item.
//
//                                            +------------------------------------------+
//   +----------------------+                 |Boundary Supplementary Item               |
//   |                      |<----------------|* alignment: [.top, .leading]             |
//   +----------------------+                 |* absoluteOffset: CGPoint(x:0.0, y:-10.0) |
//                                            +------------------------------------------+
//   +----------------------------------+
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |      +--------------------------------+
//   |                                  |<-----|        Section Geometry        |
//   |                                  |      +--------------------------------+
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   |                                  |
//   +----------------------------------+

+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(IBPNSRectAlignment)alignment;
+ (instancetype)boundarySupplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                            elementKind:(NSString *)elementKind
                                              alignment:(IBPNSRectAlignment)alignment
                                         absoluteOffset:(CGPoint)absoluteOffset;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// Default is YES. This will automatically extend the content area of the host geometry (e.g. section)
//   For .estimated sized supplementary items, this allows automatic adjustment of the layout. (e.g. dynamic text)
@property (nonatomic) BOOL extendsBoundary;

// Default is NO. Specify YES to keep the supplementary visible while any portion of the host geometry (e.g. section) is visible.
//   Occlusion disambiguation between other supplementaries will be managed automatically (e.g. section header + footer both pinned)
@property (nonatomic) BOOL pinToVisibleBounds;

@property (nonatomic, readonly) IBPNSRectAlignment alignment;
@property (nonatomic, readonly) CGPoint offset;

@end

NS_ASSUME_NONNULL_END
