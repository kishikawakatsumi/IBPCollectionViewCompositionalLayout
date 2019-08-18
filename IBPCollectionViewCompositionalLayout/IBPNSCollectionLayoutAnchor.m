#import "IBPNSCollectionLayoutAnchor.h"

@interface IBPNSCollectionLayoutAnchor()

@property (nonatomic, readwrite) IBPNSDirectionalRectEdge edges;
@property (nonatomic, readwrite) CGPoint offset;
@property (nonatomic, readwrite) BOOL isAbsoluteOffset;
@property (nonatomic, readwrite) BOOL isFractionalOffset;

@end

@implementation IBPNSCollectionLayoutAnchor

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutAnchor") layoutAnchorWithEdges:edges];
    } else {
        return [[self alloc] initWithEdges:edges];
    }
}

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges absoluteOffset:(CGPoint)absoluteOffset {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutAnchor") layoutAnchorWithEdges:edges absoluteOffset:absoluteOffset];
    } else {
        return [[self alloc] initWithEdges:edges absoluteOffset:absoluteOffset];
    }
}

+ (instancetype)layoutAnchorWithEdges:(IBPNSDirectionalRectEdge)edges fractionalOffset:(CGPoint)fractionalOffset {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutAnchor") layoutAnchorWithEdges:edges fractionalOffset:fractionalOffset];
    } else {
        return [[self alloc] initWithEdges:edges fractionalOffset:fractionalOffset];
    }
}

- (instancetype)initWithEdges:(IBPNSDirectionalRectEdge)edges {
    self = [super init];
    if (self) {
        self.edges = edges;
        self.offset = CGPointZero;
        self.isAbsoluteOffset = NO;
        self.isFractionalOffset = NO;
    }
    return self;
}

- (instancetype)initWithEdges:(IBPNSDirectionalRectEdge)edges absoluteOffset:(CGPoint)absoluteOffset {
    self = [super init];
    if (self) {
        self.edges = edges;
        self.offset = absoluteOffset;
        self.isAbsoluteOffset = YES;
        self.isFractionalOffset = NO;
    }
    return self;
}

- (instancetype)initWithEdges:(IBPNSDirectionalRectEdge)edges fractionalOffset:(CGPoint)fractionalOffset {
    self = [super init];
    if (self) {
        self.edges = edges;
        self.offset = fractionalOffset;
        self.isAbsoluteOffset = NO;
        self.isFractionalOffset = YES;
    }
    return self;
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

@end
