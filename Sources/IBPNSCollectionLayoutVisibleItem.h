#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IBPNSCollectionLayoutVisibleItem<NSObject, UIDynamicItem>

@property (nonatomic) CGFloat alpha;
@property (nonatomic) NSInteger zIndex;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic) CATransform3D transform3D;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSIndexPath *indexPath;
@property (nonatomic, readonly) CGRect frame;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) UICollectionElementCategory representedElementCategory;
@property (nonatomic, readonly, nullable) NSString *representedElementKind;

@end

NS_ASSUME_NONNULL_END
