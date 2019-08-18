#import "IBPNSCollectionLayoutSpacing_Private.h"

@interface IBPNSCollectionLayoutSpacing()

@property (nonatomic, readwrite) CGFloat spacing;
@property (nonatomic, readwrite) BOOL isFlexibleSpacing;
@property (nonatomic, readwrite) BOOL isFixedSpacing;

@end

@implementation IBPNSCollectionLayoutSpacing

+ (instancetype)flexibleSpacing:(CGFloat)flexibleSpacing {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutSpacing") flexibleSpacing:flexibleSpacing];
    } else {
        return [[self alloc] initWithSpacing:flexibleSpacing isFlexible:YES];
    }
}

+ (instancetype)fixedSpacing:(CGFloat)fixedSpacing {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutSpacing") fixedSpacing:fixedSpacing];
    } else {
        return [[self alloc] initWithSpacing:fixedSpacing isFlexible:NO];
    }
}

+ (instancetype)defaultSpacing {
    return [[self alloc] initWithSpacing:0 isFlexible:NO];
}

- (instancetype)initWithSpacing:(CGFloat)spacing isFlexible:(BOOL)isFlexible {
    self = [super init];
    if (self) {
        self.spacing = spacing;
        self.isFlexibleSpacing = isFlexible;
        self.isFixedSpacing = !isFlexible;
    }
    return self;
}

- (BOOL)hasSpacing {
    return self.isFlexibleSpacing || self.spacing > 0;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    if (self.isFlexibleSpacing) {
        return [IBPNSCollectionLayoutSpacing flexibleSpacing:self.spacing];
    }
    if (self.isFixedSpacing) {
        return [IBPNSCollectionLayoutSpacing fixedSpacing:self.spacing];
    }
    return nil;
}

- (NSString *)description {
    NSString *kind = @"";
    if (self.isFlexibleSpacing) {
        kind = @"flexible";
    }
    if (self.isFixedSpacing) {
        kind = @"fixed";
    }
    return [NSString stringWithFormat:@"<NSCollectionLayoutSpacing - %p: %@:%g>", self, kind, self.spacing];
}

@end
