#import "IBPNSCollectionLayoutGroup.h"
#import "IBPNSCollectionLayoutGroup_Private.h"
#import "IBPNSCollectionLayoutContainer.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutEdgeSpacing_Private.h"
#import "IBPNSCollectionLayoutItem_Private.h"
#import "IBPNSCollectionLayoutSize_Private.h"
#import "IBPNSCollectionLayoutSpacing_Private.h"

@implementation IBPNSCollectionLayoutGroup

@synthesize supplementaryItems;

+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                     subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutGroup") horizontalGroupWithLayoutSize:layoutSize subitems:subitems];
    } else {
        return [[self alloc] initWithSize:layoutSize
                                 subitems:subitems
                                    count:0
                         interItemSpacing:[IBPNSCollectionLayoutSpacing defaultSpacing]
                            contentInsets:IBPNSDirectionalEdgeInsetsZero
                              edgeSpacing:[IBPNSCollectionLayoutEdgeSpacing defaultSpacing]
                          layoutDirection:IBPGroupLayoutDirectionHorizontal
                       supplementaryItems:@[]
                  customGroupItemProvider:nil
                                     name:nil
                               identifier:[NSUUID UUID]];
    }
}

+ (instancetype)horizontalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                      subitem:(IBPNSCollectionLayoutItem *)subitem
                                        count:(NSInteger)count {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutGroup") horizontalGroupWithLayoutSize:layoutSize subitem:subitem count:count];
    } else {
        return [[self alloc] initWithSize:layoutSize
                                 subitems:@[subitem]
                                    count:count
                         interItemSpacing:[IBPNSCollectionLayoutSpacing defaultSpacing]
                            contentInsets:IBPNSDirectionalEdgeInsetsZero
                              edgeSpacing:[IBPNSCollectionLayoutEdgeSpacing defaultSpacing]
                          layoutDirection:IBPGroupLayoutDirectionHorizontal
                       supplementaryItems:@[]
                  customGroupItemProvider:nil
                                     name:nil
                               identifier:[NSUUID UUID]];
    }
}

+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                   subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutGroup") verticalGroupWithLayoutSize:layoutSize subitems:subitems];
    } else {
        return [[self alloc] initWithSize:layoutSize subitems:subitems
                                    count:0
                         interItemSpacing:[IBPNSCollectionLayoutSpacing defaultSpacing]
                            contentInsets:IBPNSDirectionalEdgeInsetsZero
                              edgeSpacing:[IBPNSCollectionLayoutEdgeSpacing defaultSpacing]
                          layoutDirection:IBPGroupLayoutDirectionVertical
                       supplementaryItems:@[]
                  customGroupItemProvider:nil
                                     name:nil
                               identifier:[NSUUID UUID]];
    }
}

+ (instancetype)verticalGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                                    subitem:(IBPNSCollectionLayoutItem *)subitem
                                      count:(NSInteger)count {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutGroup") verticalGroupWithLayoutSize:layoutSize subitem:subitem count:count];
    } else {
        return [[self alloc] initWithSize:layoutSize subitems:@[subitem]
                                    count:count
                         interItemSpacing:[IBPNSCollectionLayoutSpacing defaultSpacing]
                            contentInsets:IBPNSDirectionalEdgeInsetsZero
                              edgeSpacing:[IBPNSCollectionLayoutEdgeSpacing defaultSpacing]
                          layoutDirection:IBPGroupLayoutDirectionVertical
                       supplementaryItems:@[]
                  customGroupItemProvider:nil
                                     name:nil
                               identifier:[NSUUID UUID]];
    }
}

+ (instancetype)customGroupWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize itemProvider:(IBPNSCollectionLayoutGroupCustomItemProvider)itemProvider {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutGroup") customGroupWithLayoutSize:layoutSize itemProvider:itemProvider];
    } else {
        return [[self alloc] initWithSize:layoutSize subitems:@[]
                                    count:0
                         interItemSpacing:[IBPNSCollectionLayoutSpacing defaultSpacing]
                            contentInsets:IBPNSDirectionalEdgeInsetsZero
                              edgeSpacing:[IBPNSCollectionLayoutEdgeSpacing defaultSpacing]
                          layoutDirection:IBPGroupLayoutDirectionCustom
                       supplementaryItems:@[]
                  customGroupItemProvider:itemProvider
                                     name:nil
                               identifier:[NSUUID UUID]];
    }
}

- (instancetype)initWithSize:(IBPNSCollectionLayoutSize *)size
                    subitems:(NSArray<IBPNSCollectionLayoutItem *> *)subitems
                       count:(NSInteger)count
            interItemSpacing:(IBPNSCollectionLayoutSpacing *)interItemSpacing
               contentInsets:(IBPNSDirectionalEdgeInsets)contentInsets
                 edgeSpacing:(IBPNSCollectionLayoutEdgeSpacing *)edgeSpacing
             layoutDirection:(IBPGroupLayoutDirection)layoutDirection
          supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems
     customGroupItemProvider:(IBPNSCollectionLayoutGroupCustomItemProvider)customGroupItemProvider
                        name:(NSString *)name
                  identifier:(NSUUID *)identifier {
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
        self.customGroupItemProvider = customGroupItemProvider;
        self.name = name;
        self.identifier = identifier;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    IBPNSCollectionLayoutGroup *group = [[IBPNSCollectionLayoutGroup alloc] initWithSize:self.layoutSize
                                                                                subitems:self.subitems
                                                                                   count:self.count
                                                                        interItemSpacing:self.interItemSpacing
                                                                           contentInsets:self.contentInsets
                                                                             edgeSpacing:self.edgeSpacing
                                                                         layoutDirection:self.layoutDirection
                                                                      supplementaryItems:self.supplementaryItems
                                                                 customGroupItemProvider:self.customGroupItemProvider
                                                                                    name:self.name
                                                                              identifier:self.identifier];
    return group;
}

- (NSString *)visualDescription {
    return @""; // Not implemented
}

- (BOOL)isHorizontalGroup {
    return self.layoutDirection == IBPGroupLayoutDirectionHorizontal;
}

- (BOOL)isVerticalGroup {
    return self.layoutDirection == IBPGroupLayoutDirectionVertical;
}

- (BOOL)isCustomGroup {
    return self.layoutDirection == IBPGroupLayoutDirectionCustom;
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
                                    layoutDirection:(IBPGroupLayoutDirection)layoutDirection {
    NSArray<IBPNSCollectionLayoutItem *> *subitems = self.subitems;
    for (IBPNSCollectionLayoutItem *item in subitems) {
        if (item.isGroup) {
            IBPNSCollectionLayoutGroup *group = (IBPNSCollectionLayoutGroup *)item;
            [group effectiveSizeForSize:group.layoutSize count:group.count layoutDirection:group.layoutDirection];
        } else {
            [item insetSizeForContainer:[[IBPNSCollectionLayoutContainer alloc] initWithContentSize:CGSizeZero contentInsets:IBPNSDirectionalEdgeInsetsZero]];
        }
    }
    return [IBPNSCollectionLayoutSize sizeWithWidthDimension:[IBPNSCollectionLayoutDimension absoluteDimension:0] heightDimension:[IBPNSCollectionLayoutDimension absoluteDimension:0]];
}

- (NSString *)description {
    return [self descriptionAtIndent:0];
}

- (NSString *)descriptionAtIndent:(NSUInteger)indent {
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@\n", [super descriptionAtIndent:indent]];
    NSString *tabs = [@"" stringByPaddingToLength:indent + 1 withString:@"\t" startingAtIndex:0];
    [description appendFormat:@"%@ group: subitems=\n", tabs];
    for (IBPNSCollectionLayoutItem *subitem in self.subitems) {
        NSString *tabs = [@"" stringByPaddingToLength:indent + 2 withString:@"\t" startingAtIndex:0];
        [description appendFormat:@"%@ %@\n", tabs, [subitem descriptionAtIndent:indent + 1]];
    }
    [description appendFormat:@"%@ interItemSpacing=%@\n", tabs, self.interItemSpacing];
    [description appendFormat:@"%@ layoutDirection=%@>", tabs, self.isHorizontalGroup ? @".horizontal" : @".vertical"];
    return description.copy;
}

@end

