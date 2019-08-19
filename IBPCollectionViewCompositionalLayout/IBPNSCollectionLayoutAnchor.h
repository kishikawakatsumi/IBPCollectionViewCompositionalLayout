#import <UIKit/UIKit.h>
#import "IBPNSDirectionalRectEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutAnchor : NSObject<NSCopying>

//                       +------------------+  +------+   +------------------+
//                       | [.top, .leading] |  |[.top]|   | [.top,.trailing] |
//                       +--+---------------+  +---+--+   +---------------+--+
//                          |                      |                      |
//                          v                      v                      v
//                       +-----+----------------+-----+----------------+-----+
//                       |~~~~~|                |~~~~~|                |~~~~~|
//                       |~~~~~|                |~~~~~|                |~~~~~|
//                       +-----+                +-----+                +-----+
//                       |                                                   |
//                       +-----+                                       +-----+
//   +--------------+    |~~~~~|                                       |~~~~~|    +-------------+
//   |  [.leading]  |--->|~~~~~|                                       |~~~~~|<---| [.trailing] |
//   +--------------+    +-----+                                       +-----+    +-------------+
//                       |                                                   |
//                       +-----+                +-----+                +-----+
//                       |~~~~~|                |~~~~~|                |~~~~~|
//                       |~~~~~|                |~~~~~|                |~~~~~|
//                       +-----+----------------+-----+----------------+-----+
//                          ^                      ^                      ^
//                          |                      |                      |
//                      +---+---------------+ +----+----+  +--------------+----+
//                      |[.bottom, .leading]| |[.bottom]|  |[.bottom,.trailing]|
//                      +-------------------+ +---------+  +-------------------+
//
// Edges are specified as shown above.

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges;

//                                +-----+       +------------------------------------+
//                                |~~~~~|       |      edges: [.top,.trailing]       |
//   +----------------------------+~~~~~|<------+ unitOffset: CGPoint(x:0.5,y:-0.5)  |
//   |                            |~~~~~|       +------------------------------------+
//   |                            +--+--+
//   |                               |
//   |                               |
//   |                               |
//   |                               |
//   +-------------------------------+
//
// To specify additional offsets, combine edges with absoluteOffset or unitOffset.

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges absoluteOffset:(CGPoint)absoluteOffset;
+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges fractionalOffset:(CGPoint)fractionalOffset;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) IBPNSDirectionalRectEdge edges;
@property (nonatomic, readonly) CGPoint offset;
@property (nonatomic, readonly) BOOL isAbsoluteOffset;
@property (nonatomic, readonly) BOOL isFractionalOffset;

@end

NS_ASSUME_NONNULL_END
