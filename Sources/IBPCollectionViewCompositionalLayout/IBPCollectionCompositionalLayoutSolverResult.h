#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionCompositionalLayoutSolverResult : NSObject

@property (nonatomic, nullable) IBPNSCollectionLayoutItem *layoutItem;
@property (nonatomic) CGRect frame;

+ (instancetype)resultWithLayoutItem:(nullable IBPNSCollectionLayoutItem *)layoutItem frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
