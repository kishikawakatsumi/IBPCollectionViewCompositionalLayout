#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionViewLayoutBuilderResult : NSObject

@property (nonatomic) IBPNSCollectionLayoutItem *layoutItem;
@property (nonatomic) CGRect frame;

+ (instancetype)resultWithLayoutItem:(IBPNSCollectionLayoutItem *)layoutItem frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
