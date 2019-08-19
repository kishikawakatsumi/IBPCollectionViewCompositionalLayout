#import "IBPNSCollectionLayoutAnchor_Private.h"

CGPoint AnchorPointFromEdges(IBPNSDirectionalRectEdge edges);
IBPNSDirectionalRectEdge EdgesFromAnchorPoint(CGPoint anchorPoint);

@interface IBPNSCollectionLayoutAnchor()

@property (nonatomic, readwrite) IBPNSDirectionalRectEdge edges;
@property (nonatomic, readwrite) CGPoint offset;
@property (nonatomic, readwrite) BOOL isAbsoluteOffset;
@property (nonatomic, readwrite) BOOL isFractionalOffset;

@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) BOOL offsetIsUnitOffset;

@end

@implementation IBPNSCollectionLayoutAnchor

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges {
    return [self layoutAnchorWithEdges:edges absoluteOffset:CGPointZero];
}

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges absoluteOffset:(CGPoint)absoluteOffset {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutAnchor") layoutAnchorWithEdges:edges absoluteOffset:absoluteOffset];
    } else {
        return [[self alloc] initWithEdges:edges offset:absoluteOffset anchorPoint:AnchorPointFromEdges(edges) offsetIsUnitOffset:NO];
    }
}

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges fractionalOffset:(CGPoint)fractionalOffset {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutAnchor") layoutAnchorWithEdges:edges fractionalOffset:fractionalOffset];
    } else {
        return [[self alloc] initWithEdges:edges offset:fractionalOffset anchorPoint:AnchorPointFromEdges(edges) offsetIsUnitOffset:YES];
    }
}

+ (instancetype)layoutAnchorWithAnchorPoint:(CGPoint)anchorPoint {
    return [self layoutAnchorWithAnchorPoint:anchorPoint offset:CGPointZero];
}

+ (instancetype)layoutAnchorWithAnchorPoint:(CGPoint)anchorPoint offset:(CGPoint)offset {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutAnchor") layoutAnchorWithAnchorPoint:anchorPoint offset:offset];
    } else {
        return [[self alloc] initWithEdges:EdgesFromAnchorPoint(anchorPoint) offset:offset anchorPoint:anchorPoint offsetIsUnitOffset:NO];
    }
}

+ (instancetype)layoutAnchorWithAnchorPoint:(CGPoint)anchorPoint unitOffset:(CGPoint)unitOffset {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutAnchor") layoutAnchorWithAnchorPoint:anchorPoint unitOffset:unitOffset];
    } else {
        return [[self alloc] initWithEdges:EdgesFromAnchorPoint(anchorPoint) offset:unitOffset anchorPoint:anchorPoint offsetIsUnitOffset:YES];
    }
}

- (instancetype)initWithEdges:(IBPNSDirectionalRectEdge)edges offset:(CGPoint)offset anchorPoint:(CGPoint)anchorPoint offsetIsUnitOffset:(BOOL)offsetIsUnitOffset {
    self = [super init];
    if (self) {
        self.edges = edges;
        self.offset = offset;
        self.anchorPoint = anchorPoint;
        self.offsetIsUnitOffset = offsetIsUnitOffset;
    }
    return self;
}

- (BOOL)isAbsoluteOffset {
    return !self.offsetIsUnitOffset;
}

- (BOOL)isFractionalOffset {
    return self.offsetIsUnitOffset;
}

- (CGRect)itemFrameForContainerRect:(CGRect)containerRect
                           itemSize:(CGSize)itemSize
                   itemLayoutAnchor:(IBPNSCollectionLayoutAnchor *)itemLayoutAnchor {
    CGRect itemFrame = containerRect;
    itemFrame.size = itemSize;

    CGPoint offset = self.offset;
    CGPoint anchorPoint = self.anchorPoint;
    BOOL isUnitOffset = self.offsetIsUnitOffset;

    CGFloat containerWidth = CGRectGetWidth(containerRect);
    CGFloat containerHeight = CGRectGetHeight(containerRect);

    CGFloat anchorX = anchorPoint.x;
    CGFloat anchorY = anchorPoint.y;

    CGFloat offsetX = isUnitOffset ? itemSize.width * offset.x : offset.x;
    CGFloat offsetY = isUnitOffset ? itemSize.height * offset.y : offset.y;

    itemFrame.origin.x = CGRectGetMinX(containerRect) + (containerWidth * anchorX - itemSize.width * anchorX) + offsetX;
    itemFrame.origin.y = CGRectGetMinY(containerRect) + (containerHeight * anchorY - itemSize.height * anchorY) + offsetY;

    return itemFrame;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    if (self.isAbsoluteOffset) {
        return [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:self.edges absoluteOffset:self.offset];
    }
    if (self.isFractionalOffset) {
        return [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:self.edges fractionalOffset:self.offset];
    }
    return [IBPNSCollectionLayoutAnchor layoutAnchorWithEdges:self.edges];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<NSCollectionLayoutAnchor %p: edges=%lu; offset=%@; anchorPoint=%@>", self, self.edges, NSStringFromCGPoint(self.offset), NSStringFromCGPoint(self.offset)];
}

@end

CGPoint AnchorPointFromEdges(IBPNSDirectionalRectEdge edges) {
    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    if (edges == IBPNSDirectionalRectEdgeTop) {
        anchorPoint.y = 0;
    }
    if (edges == IBPNSDirectionalRectEdgeLeading) {
        anchorPoint.x = 0;
    }
    if (edges == IBPNSDirectionalRectEdgeTrailing) {
        anchorPoint.x = 1;
    }
    if (edges == IBPNSDirectionalRectEdgeBottom) {
        anchorPoint.y = 1;
    }
    if (edges == (IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeLeading)) {
        anchorPoint.x = 0;
        anchorPoint.y = 0;
    }
    if (edges == (IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeTrailing)) {
        anchorPoint.x = 1;
        anchorPoint.y = 0;
    }
    if (edges == (IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeLeading)) {
        anchorPoint.x = 0;
        anchorPoint.y = 1;
    }
    if (edges == (IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeTrailing)) {
        anchorPoint.x = 1;
        anchorPoint.y = 1;
    }
    if (edges == (IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeLeading | IBPNSDirectionalRectEdgeTrailing)) {
        anchorPoint.y = 0;
    }
    if (edges == (IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeLeading | IBPNSDirectionalRectEdgeTrailing)) {
        anchorPoint.y = 1;
    }
    if (edges == (IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeLeading)) {
        anchorPoint.x = 0;
    }
    if (edges == (IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeTrailing)) {
        anchorPoint.x = 1;
    }
    return anchorPoint;
}

IBPNSDirectionalRectEdge EdgesFromAnchorPoint(CGPoint anchorPoint) {
    IBPNSDirectionalRectEdge edges = IBPNSDirectionalRectEdgeNone;
    if (anchorPoint.x < 0.5) {
        edges |= IBPNSDirectionalRectEdgeLeading;
    }
    if (anchorPoint.x > 0.5) {
        edges |= IBPNSDirectionalRectEdgeTrailing;
    }
    if (anchorPoint.y < 0.5) {
        edges |= IBPNSDirectionalRectEdgeTop;
    }
    if (anchorPoint.y > 0.5) {
        edges |= IBPNSDirectionalRectEdgeBottom;
    }
    return edges;
}
