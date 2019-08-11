#import "IBPNSCollectionLayoutDecorationItem.h"

@interface IBPNSCollectionLayoutDecorationItem()

@property (nonatomic, readwrite) NSString *elementKind;

@end

@implementation IBPNSCollectionLayoutDecorationItem

+ (instancetype)backgroundDecorationItemWithElementKind:(NSString *)elementKind {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutDecorationItem") backgroundDecorationItemWithElementKind:elementKind];
    } else {
        return [[self alloc] initWithElementKind:elementKind];
    }
}

- (instancetype)initWithElementKind:(NSString *)elementKind {
    self = [super init];
    if (self) {
        self.elementKind = elementKind;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    IBPNSCollectionLayoutDecorationItem *item = [IBPNSCollectionLayoutDecorationItem backgroundDecorationItemWithElementKind:self.elementKind];
    item.zIndex = self.zIndex;
    item.contentInsets = self.contentInsets;
    return item;
}

@end
