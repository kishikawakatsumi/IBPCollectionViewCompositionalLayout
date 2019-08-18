#import <UIKit/UIKit.h>
#import "IBPNSDirectionalEdgeInsets.h"

@protocol IBPNSCollectionLayoutEnvironment;
@class IBPNSCollectionLayoutSize, IBPNSCollectionLayoutSupplementaryItem, IBPNSCollectionLayoutEdgeSpacing, IBPNSCollectionLayoutAnchor, IBPNSCollectionLayoutSpacing;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutItem : NSObject<NSCopying>

+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize;
+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic) IBPNSDirectionalEdgeInsets contentInsets;
@property (nonatomic, copy, nullable) IBPNSCollectionLayoutEdgeSpacing *edgeSpacing;

@property (nonatomic, readonly) IBPNSCollectionLayoutSize *layoutSize;
@property (nonatomic, readonly) NSArray<IBPNSCollectionLayoutSupplementaryItem*> *supplementaryItems;

@end

NS_ASSUME_NONNULL_END
