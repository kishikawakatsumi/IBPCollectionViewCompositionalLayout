#import "IBPNSCollectionLayoutItem.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutDecorationItem.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutContainer.h"

@implementation IBPNSCollectionLayoutItem

+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize {
    return [self itemWithLayoutSize:layoutSize supplementaryItems:@[]];
}

+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems {
    return [[self alloc] initWithLayoutSize:layoutSize supplementaryItems:supplementaryItems];
}

- (instancetype)initWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems {
    self = [super init];
    if (self) {
        self.layoutSize = layoutSize;
        self.supplementaryItems = supplementaryItems;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    IBPNSCollectionLayoutItem *item = [IBPNSCollectionLayoutItem itemWithLayoutSize:self.layoutSize supplementaryItems:self.supplementaryItems];
    return item;
}

- (BOOL)isGroup {
    return NO;
}

- (id<IBPNSCollectionLayoutContainer>)containerForParentContainer:(id<IBPNSCollectionLayoutContainer>)container {
    CGSize contentSize = [self.layoutSize effectiveSizeForContainer:container];
    return [[IBPNSCollectionLayoutContainer alloc] initWithContentSize:contentSize contentInsets:self.contentInsets];
}

- (CGSize)insetSizeForContainer:(id<IBPNSCollectionLayoutContainer>)container {
    return [self.layoutSize effectiveSizeForContainer:container ignoringInsets:NO];
}

- (void)enumerateItemsWithHandler:(void (^__nonnull)(IBPNSCollectionLayoutItem * _Nonnull item, BOOL *stop))handler {
    BOOL stop = NO;
    handler(self, &stop);
}

- (void)enumerateSupplementaryItemsWithHandler:(void (^__nonnull)(IBPNSCollectionLayoutSupplementaryItem * _Nonnull supplementaryItem, BOOL *stop))handler {
    for (IBPNSCollectionLayoutSupplementaryItem *supplementaryItem in self.supplementaryItems) {
        BOOL stop = NO;
        handler(supplementaryItem, &stop);
        if (stop) {
            break;
        }
    }
}

@end
