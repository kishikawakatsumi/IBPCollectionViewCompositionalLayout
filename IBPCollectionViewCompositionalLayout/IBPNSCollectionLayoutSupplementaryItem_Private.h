#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutSupplementaryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSupplementaryItem()

@property (nonatomic, readwrite) NSString *elementKind;
@property (nonatomic, readwrite) IBPNSCollectionLayoutAnchor *containerAnchor;
@property (nonatomic, readwrite, nullable) IBPNSCollectionLayoutAnchor *itemAnchor;

@end

NS_ASSUME_NONNULL_END
