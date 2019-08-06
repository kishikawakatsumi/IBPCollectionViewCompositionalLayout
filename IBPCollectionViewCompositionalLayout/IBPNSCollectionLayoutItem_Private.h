#import <UIKit/UIKit.h>

@protocol IBPNSCollectionLayoutContainer;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutItem()

@property (nonatomic, readwrite, copy, nonnull) IBPNSCollectionLayoutSize *layoutSize;
@property (nonatomic, readwrite, copy, nonnull) NSArray<IBPNSCollectionLayoutSupplementaryItem *> *supplementaryItems;
@property (nonatomic, readonly, getter=isGroup) BOOL group;

- (instancetype)initWithLayoutSize:(IBPNSCollectionLayoutSize *)layoutSize supplementaryItems:(NSArray<IBPNSCollectionLayoutSupplementaryItem *> *)supplementaryItems;

- (id<IBPNSCollectionLayoutContainer>)containerForParentContainer:(id<IBPNSCollectionLayoutContainer>)container;
- (CGSize)insetSizeForContainer:(id<IBPNSCollectionLayoutContainer>)container;

- (void)enumerateItemsWithHandler:(void (^__nonnull)(IBPNSCollectionLayoutItem * _Nonnull item, BOOL *stop))handler;
- (void)enumerateSupplementaryItemsWithHandler:(void (^__nonnull)(IBPNSCollectionLayoutSupplementaryItem * _Nonnull supplementaryItem, BOOL *stop))handler;

@end

NS_ASSUME_NONNULL_END
