#import <UIKit/UIKit.h>
#import "IBPUICollectionLayoutSectionOrthogonalScrollingBehavior.h"
#import "IBPNSCollectionLayoutVisibleItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IBPNSCollectionLayoutVisibleItem, NSCollectionLayoutEnvironment, IBPNSCollectionLayoutEnvironment;
@class IBPUICollectionViewCompositionalLayoutConfiguration, IBPNSCollectionLayoutSection;

typedef IBPNSCollectionLayoutSection * _Nullable (^IBPUICollectionViewCompositionalLayoutSectionProvider)(NSInteger section, id<IBPNSCollectionLayoutEnvironment>);
typedef void (^IBPNSCollectionLayoutSectionVisibleItemsInvalidationHandler)(NSArray<id<IBPNSCollectionLayoutVisibleItem>> *visibleItems, CGPoint contentOffset, id<IBPNSCollectionLayoutEnvironment> layoutEnvironment);

@interface IBPUICollectionViewCompositionalLayout : UICollectionViewLayout

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section;
- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section
                  configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration;

- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider;
- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider
                          configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, copy) IBPUICollectionViewCompositionalLayoutConfiguration *configuration;

@end

NS_ASSUME_NONNULL_END
