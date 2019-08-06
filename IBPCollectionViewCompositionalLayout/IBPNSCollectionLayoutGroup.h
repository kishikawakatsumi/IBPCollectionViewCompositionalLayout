#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutItem.h"
#import "IBPNSCollectionLayoutGroupCustomItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutGroup : IBPNSCollectionLayoutItem<NSCopying>

+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                      subitem:(IBPNSCollectionLayoutItem *)subitem
                                        count:(NSInteger)count NS_SWIFT_NAME(horizontal(layoutSize:subitem:count:));
+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                     subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems NS_SWIFT_NAME(horizontal(layoutSize:subitems:));

+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    subitem:(IBPNSCollectionLayoutItem *)subitem
                                      count:(NSInteger)count NS_SWIFT_NAME(vertical(layoutSize:subitem:count:));
+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                   subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems NS_SWIFT_NAME(vertical(layoutSize:subitems:));

+ (instancetype)customGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                             itemProvider:(NSCollectionLayoutGroupCustomItemProvider)itemProvider NS_SWIFT_NAME(custom(layoutSize:itemProvider:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, copy, nullable) IBPNSCollectionLayoutSpacing *interItemSpacing;
@property (nonatomic, readonly) NSArray<IBPNSCollectionLayoutItem *> *subitems;

- (NSString *)visualDescription;

@end

NS_ASSUME_NONNULL_END
