#import <UIKit/UIKit.h>
#import "NSDirectionalRectEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutAnchor : NSObject<NSCopying>

+ (instancetype)layoutAnchorWithEdges:(NSDirectionalRectEdge)edges;
+ (instancetype)layoutAnchorWithEdges:(NSDirectionalRectEdge)edges absoluteOffset:(CGPoint)absoluteOffset;
+ (instancetype)layoutAnchorWithEdges:(NSDirectionalRectEdge)edges fractionalOffset:(CGPoint)fractionalOffset;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) NSDirectionalRectEdge edges;
@property (nonatomic, readonly) CGPoint offset;
@property (nonatomic, readonly) BOOL isAbsoluteOffset;
@property (nonatomic, readonly) BOOL isFractionalOffset;

@end

NS_ASSUME_NONNULL_END
