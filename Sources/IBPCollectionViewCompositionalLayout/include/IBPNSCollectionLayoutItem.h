#import <UIKit/UIKit.h>
#import "IBPNSDirectionalEdgeInsets.h"

@class IBPNSCollectionLayoutEdgeSpacing;
@class IBPNSCollectionLayoutSize;
@class IBPNSCollectionLayoutSupplementaryItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutItem : NSObject<NSCopying>

+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize;
+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

//                       +---------------------+
//   +-------------+<----|Specified layout size|
//   |             |     +---------------------+
//   |  +-------+  |     +--------------------------+
//   |  |~~~~~~~|  |     |Final size (after         |
//   |  |~~~~~~~|<-+-----|contentInsets are applied)|
//   |  +-------+  |     +--------------------------+
//   |             |
//   +-------------+
//
//  Use contentInsets on an item to adjust the final size of the item after layout is computed.
//    useful for grid style layouts to apply even spacing around each the edges of each item.
//
//  Note: contentInsets are ignored for any axis with an .estimated dimension

@property (nonatomic) IBPNSDirectionalEdgeInsets contentInsets;

//                     +--------+
//                     |  Top   |
//                     +--------+
//                          |
//                          |
//                  +-------+--------------------------+
//                  |       v                          |
//                  |    +------+                      |
//   +--------+     |    |~~~~~~|        +--------+    |
//   |Leading |-----+->  |~~~~~~| <------|Trailing|    |
//   +--------+     |    |~~~~~~|        +--------+    |
//                  |    +------+                      |
//                  |        ^                         |
//                  +--------+-------------------------+
//                           |
//                           |
//                      +--------+
//                      | Bottom |
//                      +--------+
//
//  Specifies additional space required surrounding and item when laying out.
//  Flexible spacing can be used to apportion remaining space after items are layed out to
//    evenly align items among available layout space.

@property (nonatomic, copy, nullable) IBPNSCollectionLayoutEdgeSpacing *edgeSpacing;

@property (nonatomic, readonly) IBPNSCollectionLayoutSize *layoutSize;
@property (nonatomic, readonly) NSArray<IBPNSCollectionLayoutSupplementaryItem*> *supplementaryItems;

@end

NS_ASSUME_NONNULL_END
