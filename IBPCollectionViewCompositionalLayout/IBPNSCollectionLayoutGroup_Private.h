#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutGroup.h"

typedef NS_ENUM(NSInteger, IBPLayoutDirection) {
    IBPLayoutDirectionHorizontal = 0,
    IBPLayoutDirectionVertical = 1,
    IBPLayoutDirectionCustom = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutGroup()

@property (nonatomic, readwrite, copy) NSArray<IBPNSCollectionLayoutItem *> *subitems;
@property (nonatomic, readwrite) IBPLayoutDirection layoutDirection;
@property (nonatomic, readwrite) NSInteger count;
@property (nonatomic, readwrite, copy) IBPNSCollectionLayoutGroupCustomItemProvider customGroupItemProvider;

- (IBPNSCollectionLayoutSize *)effectiveSizeForSize:(IBPNSCollectionLayoutSize *)size
                                           count:(NSInteger)count
                                 layoutDirection:(IBPLayoutDirection)layoutDirection;
- (BOOL)isHorizontalGroup;
- (BOOL)isVerticalGroup;

@end

NS_ASSUME_NONNULL_END
