#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutSupplementaryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSupplementaryItem()

@property (nonatomic, readwrite) NSString *elementKind;
@property (nonatomic, readwrite) IBPNSCollectionLayoutAnchor *containerAnchor;
@property (nonatomic, readwrite, nullable) IBPNSCollectionLayoutAnchor *itemAnchor;

- (instancetype)initWithSize:(IBPNSCollectionLayoutSize *)size
               contentInsets:(IBPNSDirectionalEdgeInsets)contentInsets
                 elementKind:(NSString *)elementKind
             containerAnchor:(IBPNSCollectionLayoutAnchor *)containerAnchor
                  itemAnchor:(nullable IBPNSCollectionLayoutAnchor *)itemAnchor
                      zIndex:(NSInteger)zIndex;

@end

NS_ASSUME_NONNULL_END
