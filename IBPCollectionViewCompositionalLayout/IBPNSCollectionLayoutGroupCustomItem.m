#import "IBPNSCollectionLayoutGroupCustomItem.h"

@implementation IBPNSCollectionLayoutGroupCustomItem

+ (instancetype)customItemWithFrame:(CGRect)frame {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutGroupCustomItem") customItemWithFrame:frame];
    } else {
        return nil; // Not implemented yet
    }
}

+ (instancetype)customItemWithFrame:(CGRect)frame zIndex:(NSInteger)zIndex {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutGroupCustomItem") customItemWithFrame:frame zIndex:zIndex];
    } else {
        return nil; // Not implemented yet
    }
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [IBPNSCollectionLayoutGroupCustomItem customItemWithFrame:self.frame zIndex:self.zIndex];
}

@end
