#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutItem.h"

@class IBPNSCollectionLayoutSize, IBPNSCollectionLayoutAnchor;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSupplementaryItem : IBPNSCollectionLayoutItem<NSCopying>

+ (instancetype)supplementaryItemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    elementKind:(NSString *)elementKind
                                containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor;
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
