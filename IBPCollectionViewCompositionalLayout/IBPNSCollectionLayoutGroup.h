#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutItem.h"
#import "IBPNSCollectionLayoutGroupCustomItem.h"

@class IBPNSCollectionLayoutSpacing;
@class IBPNSCollectionLayoutSupplementaryItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutGroup : IBPNSCollectionLayoutItem<NSCopying>

// Specifies a group that will have N items equally sized along the horizontal axis. use interItemSpacing to insert space between items
//
//   +------+--+------+--+------+
//   |~~~~~~|  |~~~~~~|  |~~~~~~|
//   |~~~~~~|  |~~~~~~|  |~~~~~~|
//   |~~~~~~|  |~~~~~~|  |~~~~~~|
//   +------+--+------+--+------+
//            ^        ^
//            |        |
//    +-----------------------+
//    |  Inter Item Spacing   |
//    +-----------------------+
//
+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                      subitem:(IBPNSCollectionLayoutItem *)subitem
                                        count:(NSInteger)count NS_SWIFT_NAME(horizontal(layoutSize:subitem:count:));

// Specifies a group that will repeat items until available horizontal space is exhausted.
//   note: any remaining space after laying out items can be apportioned among flexible interItemSpacing defintions
+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                     subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems NS_SWIFT_NAME(horizontal(layoutSize:subitems:));

// Specifies a group that will have N items equally sized along the vertical axis. use interItemSpacing to insert space between items
//   +------+
//   |~~~~~~|
//   |~~~~~~|
//   |~~~~~~|
//   +------+
//   |      |<--+
//   +------+   |
//   |~~~~~~|   |    +-----------------------+
//   |~~~~~~|   +----|  Inter Item Spacing   |
//   |~~~~~~|   |    +-----------------------+
//   +------+   |
//   |      |<--+
//   +------+
//   |~~~~~~|
//   |~~~~~~|
//   |~~~~~~|
//   +------+
//
+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    subitem:(IBPNSCollectionLayoutItem *)subitem
                                      count:(NSInteger)count NS_SWIFT_NAME(vertical(layoutSize:subitem:count:));

// Specifies a group that will repeat items until available vertical space is exhausted.
//   note: any remaining space after laying out items can be apportioned among flexible interItemSpacing defintions
+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                   subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems NS_SWIFT_NAME(vertical(layoutSize:subitems:));

// Specifies a custom group with client-specified frames.
//   During layout, the itemProvider will be called with the group's current geometry provided via the NSCollectionLayoutEnvironment supplied.
//   The coordinate space for returned frames should be {0,0} relative to this group's geometry.
//   Custom groups can be nested arbitrarily inside other groups.
+ (instancetype)customGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                             itemProvider:(IBPNSCollectionLayoutGroupCustomItemProvider)itemProvider NS_SWIFT_NAME(custom(layoutSize:itemProvider:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// Supplementary items are "anchored" to the group's geometry.
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutSupplementaryItem *> *supplementaryItems;

// Supplies additional spacing between items along the layout axis of the group
@property (nonatomic, copy, nullable) IBPNSCollectionLayoutSpacing *interItemSpacing;

@property (nonatomic, readonly) NSArray<IBPNSCollectionLayoutItem *> *subitems;

// for visual debugging; will print an ASCII art rendering to console
- (NSString *)visualDescription;

@end

NS_ASSUME_NONNULL_END
