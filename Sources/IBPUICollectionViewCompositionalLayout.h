#import <UIKit/UIKit.h>
#import "IBPUICollectionLayoutSectionOrthogonalScrollingBehavior.h"
#import "IBPNSCollectionLayoutVisibleItem.h"

NS_ASSUME_NONNULL_BEGIN

@class IBPNSCollectionLayoutSection;
@class IBPUICollectionViewCompositionalLayoutConfiguration;

@protocol IBPNSCollectionLayoutEnvironment;
@protocol IBPNSCollectionLayoutVisibleItem;

typedef IBPNSCollectionLayoutSection * _Nullable (^IBPUICollectionViewCompositionalLayoutSectionProvider)(NSInteger section, id<IBPNSCollectionLayoutEnvironment>);

@interface IBPUICollectionViewCompositionalLayout : UICollectionViewLayout

- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section;
- (instancetype)initWithSection:(IBPNSCollectionLayoutSection *)section
                  configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration;

- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider;
- (instancetype)initWithSectionProvider:(IBPUICollectionViewCompositionalLayoutSectionProvider)sectionProvider
                          configuration:(IBPUICollectionViewCompositionalLayoutConfiguration *)configuration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// Setting this property will invalidate the layout immediately to affect any changes
//    Note: any changes made to properites directly will have no effect.
@property (nonatomic, copy) IBPUICollectionViewCompositionalLayoutConfiguration *configuration;

@end

NS_ASSUME_NONNULL_END
