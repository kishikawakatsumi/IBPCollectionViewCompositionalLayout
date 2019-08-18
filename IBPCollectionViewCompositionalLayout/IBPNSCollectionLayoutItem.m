#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutDecorationItem.h"
#import "IBPNSCollectionLayoutEdgeSpacing_Private.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutSpacing.h"

@implementation IBPNSCollectionLayoutItem

+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutItem") itemWithLayoutSize:layoutSize];
    } else {
        return [self itemWithLayoutSize:layoutSize supplementaryItems:@[]];
    }
}

+ (instancetype)itemWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutItem") itemWithLayoutSize:layoutSize supplementaryItems:supplementaryItems];
    } else {
        return [[self alloc] initWithLayoutSize:layoutSize supplementaryItems:supplementaryItems];
    }
}

- (instancetype)initWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems {
    return [self initWithSize:layoutSize
                contentInsets:IBPNSDirectionalEdgeInsetsZero
                  edgeSpacing:[IBPNSCollectionLayoutEdgeSpacing defaultSpacing]
           supplementaryItems:supplementaryItems
              decorationItems:@[]
                         name:nil
                   identifier:[NSUUID UUID]];
}

+ (instancetype)itemWithSize:(IBPNSCollectionLayoutSize *)size
             decorationItems:(NSArray<IBPNSCollectionLayoutDecorationItem *> *)decorationItems {
    return [[self alloc] initWithSize:size
                        contentInsets:IBPNSDirectionalEdgeInsetsZero
                          edgeSpacing:[IBPNSCollectionLayoutEdgeSpacing defaultSpacing]
                   supplementaryItems:@[]
                      decorationItems:decorationItems
                                 name:nil
                           identifier:[NSUUID UUID]];
}

- (instancetype)initWithSize:(IBPNSCollectionLayoutSize *)size
               contentInsets:(IBPNSDirectionalEdgeInsets)contentInsets
                 edgeSpacing:(IBPNSCollectionLayoutEdgeSpacing *)edgeSpacing
          supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems
             decorationItems:(NSArray<IBPNSCollectionLayoutDecorationItem *> *)decorationItems
                        name:(NSString *)name
                  identifier:(NSUUID *)identifier {
    self = [super init];
    if (self) {
        self.layoutSize = size;
        self.size = size;
        self.contentInsets = contentInsets;
        self.edgeSpacing = edgeSpacing;
        self.supplementaryItems = supplementaryItems;
        self.decorationItems = decorationItems;
        self.name = name;
        self.identifier = identifier;
    }
    return self;
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

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    IBPNSCollectionLayoutItem *item = [IBPNSCollectionLayoutItem itemWithLayoutSize:self.layoutSize supplementaryItems:self.supplementaryItems];
    return item;
}

- (NSString *)description {
    return [self descriptionAtIndent:0];
}

- (NSString *)descriptionAtIndent:(NSUInteger)indent {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<name=%@; size=%@;\n", self.name, self.layoutSize];
    NSString *tabs = [@"" stringByPaddingToLength:indent + 1 withString:@"\t" startingAtIndex:0];
    [description appendFormat:@"%@ edgeSpacing=%@;\n", tabs, self.edgeSpacing];
    [description appendFormat:@"%@ identfier=%@;\n", tabs, self.identifier];
    IBPNSDirectionalEdgeInsets contentInsets = self.contentInsets;
    [description appendFormat:@"%@ contentInsets={%g,%g,%g,%g}>", tabs, contentInsets.leading, contentInsets.top, contentInsets.trailing, contentInsets.bottom];
    return description;
}

@end
