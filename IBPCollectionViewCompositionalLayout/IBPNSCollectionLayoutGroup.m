#import "IBPNSCollectionLayoutGroup.h"
#import "IBPNSCollectionLayoutGroup_Private.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutContainer.h"

@implementation IBPNSCollectionLayoutGroup

+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                     subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:layoutSize subitems:subitems];
#else
        return nil;
#endif
    } else {
        return [[self alloc] initWithLayoutSize:layoutSize subitems:subitems layoutDirection:LayoutDirectionHorizontal];
    }
}

+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                      subitem:(IBPNSCollectionLayoutItem *)subitem
                                        count:(NSInteger)count {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:layoutSize subitem:subitem count:count];
#else
        return nil;
#endif
    } else {
        return [[self alloc] initWWithLayoutSize:layoutSize subitem:subitem count:count layoutDirection:LayoutDirectionHorizontal];
    }
}

+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                   subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [NSCollectionLayoutGroup verticalGroupWithLayoutSize:layoutSize subitems:subitems];
#else
        return nil;
#endif
    } else {
        return [[self alloc] initWithLayoutSize:layoutSize subitems:subitems layoutDirection:LayoutDirectionVertical];
    }
}

+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    subitem:(IBPNSCollectionLayoutItem *)subitem
                                      count:(NSInteger)count {
    if (@available(iOS 13, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return [NSCollectionLayoutGroup verticalGroupWithLayoutSize:layoutSize subitem:subitem count:count];
#else
        return nil;
#endif
    } else {
        return [[self alloc] initWWithLayoutSize:layoutSize subitem:subitem count:count layoutDirection:LayoutDirectionVertical];
    }
}

+ (instancetype)customGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize itemProvider:(IBPNSCollectionLayoutGroupCustomItemProvider)itemProvider {
    return nil;
}

- (instancetype)initWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                          subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems
                   layoutDirection:(IBPLayoutDirection)layoutDirection {
    return [self initWithSize:layoutSize subitems:subitems count:0 interItemSpacing:nil contentInsets:NSDirectionalEdgeInsetsZero edgeSpacing:nil layoutDirection:layoutDirection supplementaryItems:@[] visualFormats:nil itemsProvider:nil visualFormatItemProvider:nil customGroupItemProvider:nil options:0 name:nil identifier:nil];
}

- (instancetype)initWWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                            subitem:(IBPNSCollectionLayoutItem *)subitem
                              count:(NSInteger)count
                    layoutDirection:(IBPLayoutDirection)layoutDirection {
    return [self initWithSize:layoutSize subitems:@[subitem] count:count interItemSpacing:nil contentInsets:NSDirectionalEdgeInsetsZero edgeSpacing:nil layoutDirection:layoutDirection supplementaryItems:@[] visualFormats:nil itemsProvider:nil visualFormatItemProvider:nil customGroupItemProvider:nil options:0 name:nil identifier:nil];
}

- (instancetype)initWithSize:(IBPNSCollectionLayoutSize *)size
                    subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems
                       count:(NSInteger)count
            interItemSpacing:(IBPNSCollectionLayoutSpacing *)interItemSpacing
               contentInsets:(NSDirectionalEdgeInsets)contentInsets
                 edgeSpacing:(IBPNSCollectionLayoutEdgeSpacing *)edgeSpacing
             layoutDirection:(IBPLayoutDirection)layoutDirection
          supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems
               visualFormats:(id)visualFormats
               itemsProvider:(IBPNSCollectionLayoutGroupCustomItemProvider)itemsProvider
    visualFormatItemProvider:(id)visualFormatItemProvider
     customGroupItemProvider:(id)customGroupItemProvider
                     options:(NSInteger)options
                        name:(id)name
                  identifier:(id)identifier {
    self = [super initWithLayoutSize:size supplementaryItems:supplementaryItems];
    if (self) {
        self.layoutSize = size;
        self.subitems = subitems;
        self.count = count;
        self.interItemSpacing = interItemSpacing;
        self.contentInsets = contentInsets;
        self.edgeSpacing = edgeSpacing;
        self.layoutDirection = layoutDirection;
        self.supplementaryItems = supplementaryItems;
        self.visualFormats = visualFormats;
        self.itemsProvider = itemsProvider;
        self.visualFormatItemProvider = visualFormatItemProvider;
        self.customGroupItemProvider = customGroupItemProvider;
        self.options = options;
        self.name = name;
        self.identifier = identifier;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    IBPNSCollectionLayoutGroup *group = [[IBPNSCollectionLayoutGroup alloc] initWithSize:self.layoutSize subitems:self.subitems count:self.count interItemSpacing:self.interItemSpacing contentInsets:self.contentInsets edgeSpacing:self.edgeSpacing layoutDirection:self.layoutDirection supplementaryItems:self.supplementaryItems visualFormats:nil itemsProvider:nil visualFormatItemProvider:nil customGroupItemProvider:nil options:0 name:nil identifier:nil];
    return group;
}

- (NSString *)visualDescription {
    return @""; // Not implemented yet
}

- (BOOL)isHorizontalGroup {
    return self.layoutDirection == LayoutDirectionHorizontal;
}

- (BOOL)isVerticalGroup {
    return self.layoutDirection == LayoutDirectionVertical;
}

- (BOOL)isGroup {
    return YES;
}

- (void)enumerateItemsWithHandler:(void (^__nonnull)(IBPNSCollectionLayoutItem * _Nonnull item, BOOL *stop))handler {
    NSEnumerator<IBPNSCollectionLayoutItem *> *enumerator = self.subitems.objectEnumerator;
    IBPNSCollectionLayoutItem *item = enumerator.nextObject;
    while (item) {
        BOOL stop = NO;
        handler(item, &stop);
        if (stop) {
            break;
        }
        item = enumerator.nextObject;
        if (!item) {
            enumerator = self.subitems.objectEnumerator;
            item = enumerator.nextObject;
        }
    }
}

- (CGSize)insetSizeForContainer:(IBPNSCollectionLayoutContainer *)container {
    IBPNSCollectionLayoutSize *layoutSize = self.layoutSize;
    CGSize effectiveSize = [layoutSize effectiveSizeForContainer:container];
    return effectiveSize;
}

- (IBPNSCollectionLayoutSize *)effectiveSizeForSize:(IBPNSCollectionLayoutSize *)size
                                           count:(NSInteger)count
                                 layoutDirection:(IBPLayoutDirection)layoutDirection {
    NSArray<IBPNSCollectionLayoutItem *> *subitems = self.subitems;
    for (IBPNSCollectionLayoutItem *item in subitems) {
        if (item.isGroup) {
            IBPNSCollectionLayoutGroup *group = (IBPNSCollectionLayoutGroup *)item;
            [group effectiveSizeForSize:group.layoutSize count:group.count layoutDirection:group.layoutDirection];
        } else {
            [item insetSizeForContainer:[[IBPNSCollectionLayoutContainer alloc] initWithContentSize:CGSizeZero contentInsets:NSDirectionalEdgeInsetsZero]];
        }
    }
    return [IBPNSCollectionLayoutSize sizeWithWidthDimension:[IBPNSCollectionLayoutDimension absoluteDimension:0] heightDimension:[IBPNSCollectionLayoutDimension absoluteDimension:0]];
}

@end
