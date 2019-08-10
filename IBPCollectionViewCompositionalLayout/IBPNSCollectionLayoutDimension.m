#import "IBPNSCollectionLayoutDimension.h"

@interface IBPNSCollectionLayoutDimension()

@property (nonatomic, readwrite) BOOL isFractionalWidth;
@property (nonatomic, readwrite) BOOL isFractionalHeight;
@property (nonatomic, readwrite) BOOL isAbsolute;
@property (nonatomic, readwrite) BOOL isEstimated;
@property (nonatomic, readwrite) CGFloat dimension;

@end

@implementation IBPNSCollectionLayoutDimension

+ (instancetype)fractionalWidthDimension:(CGFloat)fractionalWidth {
    if (@available(iOS 13, *)) {
        return [NSCollectionLayoutDimension fractionalWidthDimension:fractionalWidth];
    } else {
        return [[self alloc] initWithFractionalWidth:fractionalWidth];
    }
}

+ (instancetype)fractionalHeightDimension:(CGFloat)fractionalHeight {
    if (@available(iOS 13, *)) {
        return [NSCollectionLayoutDimension fractionalHeightDimension:fractionalHeight];
    } else {
        return [[self alloc] initWithFractionalHeight:fractionalHeight];
    }
}

+ (instancetype)absoluteDimension:(CGFloat)absoluteDimension {
    if (@available(iOS 13, *)) {
        return [NSCollectionLayoutDimension absoluteDimension:absoluteDimension];
    } else {
        return [[self alloc] initWithAbsoluteDimension:absoluteDimension];
    }
}

+ (instancetype)estimatedDimension:(CGFloat)estimatedDimension {
    if (@available(iOS 13, *)) {
        return [NSCollectionLayoutDimension estimatedDimension:estimatedDimension];
    } else {
        return [[self alloc] initWithEstimatedDimension:estimatedDimension];
    }
}

- (instancetype)initWithFractionalWidth:(CGFloat)fractionalWidth {
    self = [super init];
    if (self) {
        self.dimension = fractionalWidth;
        self.isFractionalWidth = YES;
    }
    return self;
}

- (instancetype)initWithFractionalHeight:(CGFloat)fractionalHeight {
    self = [super init];
    if (self) {
        self.dimension = fractionalHeight;
        self.isFractionalHeight = YES;
    }
    return self;
}

- (instancetype)initWithAbsoluteDimension:(CGFloat)absoluteDimension {
    self = [super init];
    if (self) {
        self.dimension = absoluteDimension;
        self.isAbsolute = YES;
    }
    return self;
}

- (instancetype)initWithEstimatedDimension:(CGFloat)estimatedDimension {
    self = [super init];
    if (self) {
        self.dimension = estimatedDimension;
        self.isEstimated = YES;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    if (self.isFractionalWidth) {
        return [IBPNSCollectionLayoutDimension fractionalWidthDimension:self.dimension];
    }
    if (self.isFractionalHeight) {
        return [IBPNSCollectionLayoutDimension fractionalHeightDimension:self.dimension];
    }
    if (self.isAbsolute) {
        return [IBPNSCollectionLayoutDimension absoluteDimension:self.dimension];
    }
    if (self.isEstimated) {
        return [IBPNSCollectionLayoutDimension estimatedDimension:self.dimension];
    }
    return nil;
}

@end
