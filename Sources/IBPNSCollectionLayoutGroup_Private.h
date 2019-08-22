#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutGroup.h"

typedef NS_ENUM(NSInteger, IBPGroupLayoutDirection) {
    IBPGroupLayoutDirectionHorizontal = 0,
    IBPGroupLayoutDirectionVertical = 1,
    IBPGroupLayoutDirectionCustom = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutGroup()

@property (nonatomic, readwrite, copy) NSArray<IBPNSCollectionLayoutItem *> *subitems;
@property (nonatomic, readwrite) IBPGroupLayoutDirection layoutDirection;
@property (nonatomic, readwrite) NSInteger count;
@property (nonatomic, readwrite, copy) IBPNSCollectionLayoutGroupCustomItemProvider customGroupItemProvider;

- (IBPNSCollectionLayoutSize *)effectiveSizeForSize:(IBPNSCollectionLayoutSize *)size
                                           count:(NSInteger)count
                                 layoutDirection:(IBPGroupLayoutDirection)layoutDirection;
- (BOOL)isHorizontalGroup;
- (BOOL)isVerticalGroup;
- (BOOL)isCustomGroup;

@end

NS_ASSUME_NONNULL_END
