#import "IBPNSCollectionLayoutEdgeSpacing_Private.h"
#import "IBPNSCollectionLayoutSpacing_Private.h"

@interface IBPNSCollectionLayoutEdgeSpacing()

@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *leading;
@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *top;
@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *trailing;
@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *bottom;

- (nullable IBPNSCollectionLayoutSpacing *)_spacingForEdge:(IBPNSDirectionalRectEdge)edge;

@end

@implementation IBPNSCollectionLayoutEdgeSpacing

+ (instancetype)spacingForLeading:(IBPNSCollectionLayoutSpacing *)leading
                              top:(IBPNSCollectionLayoutSpacing *)top
                         trailing:(IBPNSCollectionLayoutSpacing *)trailing
                           bottom:(IBPNSCollectionLayoutSpacing *)bottom {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutEdgeSpacing") spacingForLeading:leading
                                                                                  top:top
                                                                             trailing:trailing
                                                                               bottom:bottom];
    } else {
        return [[self alloc] initForLeading:leading top:top trailing:trailing bottom:bottom];
    }
}

+ (instancetype)flexibleSpacing:(CGFloat)spacing {
    IBPNSCollectionLayoutSpacing *flexibleSpacing = [IBPNSCollectionLayoutSpacing flexibleSpacing:spacing];
    return [self spacingForLeading:flexibleSpacing top:flexibleSpacing trailing:flexibleSpacing bottom:flexibleSpacing];
}

+ (instancetype)fixedSpacing:(CGFloat)spacing {
    IBPNSCollectionLayoutSpacing *fixedSpacing = [IBPNSCollectionLayoutSpacing fixedSpacing:spacing];
    return [self spacingForLeading:fixedSpacing top:fixedSpacing trailing:fixedSpacing bottom:fixedSpacing];
}

- (instancetype)initForLeading:(IBPNSCollectionLayoutSpacing *)leading
                           top:(IBPNSCollectionLayoutSpacing *)top
                      trailing:(IBPNSCollectionLayoutSpacing *)trailing
                        bottom:(IBPNSCollectionLayoutSpacing *)bottom {
    self = [super init];
    if (self) {
        self.leading = leading;
        self.top = top;
        self.trailing = trailing;
        self.bottom = bottom;
    }
    return self;
}

+ (instancetype)defaultSpacing {
    IBPNSCollectionLayoutSpacing *spacing = [IBPNSCollectionLayoutSpacing defaultSpacing];
    return [IBPNSCollectionLayoutEdgeSpacing spacingForLeading:spacing top:spacing trailing:spacing bottom:spacing];
}

- (BOOL)hasSpacing {
    return self.leading.hasSpacing || self.top.hasSpacing || self.trailing.hasSpacing || self.bottom.hasSpacing;
}

- (BOOL)isSpacingFlexibleForEdge:(IBPNSDirectionalRectEdge)edge {
    IBPNSCollectionLayoutSpacing *laoutSpacing = [self _spacingForEdge:edge];
    return laoutSpacing.isFlexibleSpacing;
}

- (BOOL)isSpacingFixedForEdge:(IBPNSDirectionalRectEdge)edge {
    IBPNSCollectionLayoutSpacing *laoutSpacing = [self _spacingForEdge:edge];
    return laoutSpacing.isFixedSpacing;
}

- (CGFloat)spacingForEdge:(IBPNSDirectionalRectEdge)edge {
    IBPNSCollectionLayoutSpacing *laoutSpacing = [self _spacingForEdge:edge];
    return laoutSpacing.spacing;
}

- (IBPNSCollectionLayoutSpacing *)_spacingForEdge:(IBPNSDirectionalRectEdge)edge {
    if (edge == IBPNSDirectionalRectEdgeLeading) {
        return self.leading;
    }
    if (edge == IBPNSDirectionalRectEdgeTop) {
        return self.top;
    }
    if (edge == IBPNSDirectionalRectEdgeTrailing) {
        return self.trailing;
    }
    if (edge == IBPNSDirectionalRectEdgeBottom) {
        return self.bottom;
    }
    return nil;
}

- (IBPNSDirectionalEdgeInsets)edgeOutsets {
    return IBPNSDirectionalEdgeInsetsMake(self.top.spacing, self.leading.spacing, self.bottom.spacing, self.trailing.spacing);
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [IBPNSCollectionLayoutEdgeSpacing spacingForLeading:self.leading top:self.top trailing:self.trailing bottom:self.bottom];
}

- (NSString *)description {
    IBPNSDirectionalEdgeInsets outsets = self.edgeOutsets;
    return [NSString stringWithFormat:@"<leading=%@; top=%@; trailing=%@; bottom=%@; outsets=@{%g,%g,%g,%g}>", self.leading, self.top, self.trailing, self.bottom, outsets.top, outsets.trailing, outsets.bottom, outsets.leading];
}

@end
