#import "IBPNSCollectionLayoutSpacing.h"

@interface IBPNSCollectionLayoutSpacing()

@property (nonatomic, readwrite) CGFloat spacing;
@property (nonatomic, readwrite) BOOL isFlexibleSpacing;
@property (nonatomic, readwrite) BOOL isFixedSpacing;

@end

@implementation IBPNSCollectionLayoutSpacing

+ (instancetype)flexibleSpacing:(CGFloat)flexibleSpacing {
    if (@available(iOS 13, *)) {
        return [NSCollectionLayoutSpacing flexibleSpacing:flexibleSpacing];
    } else {
        return [[self alloc] initWithFlexibleSpacing:flexibleSpacing];
    }
}

+ (instancetype)fixedSpacing:(CGFloat)fixedSpacing {
    if (@available(iOS 13, *)) {
        return [NSCollectionLayoutSpacing fixedSpacing:fixedSpacing];
    } else {
        return [[self alloc] initWithFixedSpacing:fixedSpacing];
    }
}

- (instancetype)initWithFlexibleSpacing:(CGFloat)flexibleSpacing {
    self = [super init];
    if (self) {
        self.spacing = flexibleSpacing;
        self.isFlexibleSpacing = YES;
    }
    return self;
}

- (instancetype)initWithFixedSpacing:(CGFloat)fixedSpacing {
    self = [super init];
    if (self) {
        self.spacing = fixedSpacing;
        self.isFixedSpacing = YES;
    }
    return self;
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

@end
