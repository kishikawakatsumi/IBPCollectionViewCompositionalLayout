#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutSection()

@property (nonatomic, copy) IBPNSCollectionLayoutGroup *group;
@property (nonatomic, readonly) BOOL scrollsOrthogonally;
@property (nonatomic, readonly) BOOL hasBackgroundDecorationItem;

@end

NS_ASSUME_NONNULL_END
