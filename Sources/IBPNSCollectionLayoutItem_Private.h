#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutItem.h"

@class IBPNSCollectionLayoutDecorationItem;
@protocol IBPNSCollectionLayoutContainer;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutItem()

@property (nonatomic, readwrite, copy) IBPNSCollectionLayoutSize *layoutSize;
@property (nonatomic, readwrite, copy) NSArray<IBPNSCollectionLayoutSupplementaryItem *> *supplementaryItems;
@property (nonatomic, readonly, getter=isGroup) BOOL group;

@property (nonatomic, copy) IBPNSCollectionLayoutSize *size;
@property (nonatomic, copy) NSArray<IBPNSCollectionLayoutDecorationItem *> *decorationItems;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUUID *identifier;
@property (nonatomic) BOOL hasComputedContainsEstimatedItem;

+ (instancetype)itemWithSize:(IBPNSCollectionLayoutSize *)size
             decorationItems:(NSArray<IBPNSCollectionLayoutDecorationItem *> *)decorationItems;
- (instancetype)initWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize
                supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems;
- (instancetype)initWithSize:(IBPNSCollectionLayoutSize *)size
               contentInsets:(IBPNSDirectionalEdgeInsets)contentInsets
                 edgeSpacing:(IBPNSCollectionLayoutEdgeSpacing *)edgeSpacing
          supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems
             decorationItems:(NSArray<IBPNSCollectionLayoutDecorationItem *> *)decorationItems
                        name:(nullable NSString *)name
                  identifier:(NSUUID *)identifier;

- (id<IBPNSCollectionLayoutContainer>)containerForParentContainer:(id<IBPNSCollectionLayoutContainer>)container;
- (CGSize)insetSizeForContainer:(id<IBPNSCollectionLayoutContainer>)container;

- (void)enumerateItemsWithHandler:(void (^__nonnull)(IBPNSCollectionLayoutItem * _Nonnull item, BOOL *stop))handler;
- (void)enumerateSupplementaryItemsWithHandler:(void (^__nonnull)(IBPNSCollectionLayoutSupplementaryItem * _Nonnull supplementaryItem, BOOL *stop))handler;

- (NSString *)descriptionAtIndent:(NSUInteger)indent;

@end

NS_ASSUME_NONNULL_END
