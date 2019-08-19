#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutItem.h"

@class IBPNSCollectionLayoutSize, IBPNSCollectionLayoutAnchor;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSupplementaryItem : IBPNSCollectionLayoutItem<NSCopying>

//  Supplementary items are positioned (i.e. anchored) to coordinate spaces throughout the layout
//    In this example, a supplementary is anchored to the top+trailing edge of a cell.
//    Supplementary items can be anchored to items (and groups, since a group is-a item)
//    Boundary supplementary items can be anchored to sections and the global layout
//
//                                +-----+       +------------------------------------------+
//                                |~~~~~|       | edges: [.top,.trailing]                  |
//   +----------------------------+~~~~~|<------+ fractionalOffset: CGPoint(x:0.5,y:-0.5)  |
//   |                            |~~~~~|       +------------------------------------------+
//   |                            +--+--+
//   |                               |
//   |                               |
//   |                               |
//   |                               |
//   +-------------------------------+
//
//  Container anchors are used to specify positioning of an item within the host geometry (e.g. item, group, section)

+ (instancetype)supplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    elementKind:(NSString *)elementKind
                                containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor;

//                                                     +----------------------------------------------------+
//                                     +-----+         |* Container Anchor                                  |
//                                     |~~~~~|         |edges: [.top,.trailing] offset: CGPoint(x:10,y:-10) |
//                                     |~~~~~|<--------|                                                    |
//                                     |~~~~~|         |* Item Anchor:                                      |
//                                     +-----+         |edges: [.bottom, .leading]                          |
//   +-------------------------------+                 +----------------------------------------------------+
//   |                               |
//   |                               |
//   |                               |
//   |                               |
//   |                               |
//   |                               |
//   +-------------------------------+
//
//   Combine a container anchor with an item anchor for fine-grained positioning.
//     Optionally add an offset for additional refinement.

+ (instancetype)supplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    elementKind:(NSString *)elementKind
                                containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor
                                     itemAnchor:(IBPNSCollectionLayoutAnchor *)itemAnchor;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic) NSInteger zIndex;

@property (nonatomic, readonly) NSString *elementKind;
@property (nonatomic, readonly) IBPNSCollectionLayoutAnchor *containerAnchor;
@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutAnchor *itemAnchor;

@end

NS_ASSUME_NONNULL_END
