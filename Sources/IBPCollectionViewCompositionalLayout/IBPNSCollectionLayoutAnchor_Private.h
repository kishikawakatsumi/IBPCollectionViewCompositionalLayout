#import "IBPNSCollectionLayoutAnchor.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutAnchor()

+ (instancetype)layoutAnchorWithAnchorPoint:(CGPoint)anchorPoint;
+ (instancetype)layoutAnchorWithAnchorPoint:(CGPoint)anchorPoint offset:(CGPoint)offset;
+ (instancetype)layoutAnchorWithAnchorPoint:(CGPoint)anchorPoint unitOffset:(CGPoint)unitOffset;

- (CGRect)itemFrameForContainerRect:(CGRect)containerRect
                           itemSize:(CGSize)itemSize
                   itemLayoutAnchor:(nullable IBPNSCollectionLayoutAnchor *)itemLayoutAnchor;

@end

NS_ASSUME_NONNULL_END
