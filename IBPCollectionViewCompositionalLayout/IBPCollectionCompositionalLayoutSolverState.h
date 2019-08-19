#import <UIKit/UIKit.h>

@class IBPCollectionCompositionalLayoutSolverResult;
@class IBPNSCollectionLayoutGroup;
@class IBPNSCollectionLayoutItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPCollectionCompositionalLayoutSolverState : NSObject

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) CGRect rootGroupFrame;
@property (nonatomic) CGRect currentItemFrame;
@property (nonatomic) NSMutableArray<IBPCollectionCompositionalLayoutSolverResult *> *itemResults;

@end

NS_ASSUME_NONNULL_END
