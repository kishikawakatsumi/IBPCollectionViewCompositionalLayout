#import <UIKit/UIKit.h>
#import "IBPNSDirectionalRectEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutAnchor : NSObject<NSCopying>

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges;
+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges absoluteOffset:(CGPoint)absoluteOffset;
+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges fractionalOffset:(CGPoint)fractionalOffset;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) IBPNSDirectionalRectEdge edges;
@property (nonatomic, readonly) CGPoint offset;
@property (nonatomic, readonly) BOOL isAbsoluteOffset;
@property (nonatomic, readonly) BOOL isFractionalOffset;

@end

NS_ASSUME_NONNULL_END
