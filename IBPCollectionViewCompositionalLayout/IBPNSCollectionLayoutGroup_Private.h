#import <UIKit/UIKit.h>
#import "IBPNSCollectionLayoutGroup.h"
#import "IBPNSCollectionLayoutSection.h"

typedef NS_ENUM(NSInteger, LayoutDirection) {
    LayoutDirectionHorizontal = 0,
    LayoutDirectionVertical = 1,
    LayoutDirectionCustom = 2,
};


NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutGroup()

@property (nonatomic, readwrite, copy) NSArray<IBPNSCollectionLayoutItem *> *subitems;
@property (nonatomic, readwrite) LayoutDirection layoutDirection;
@property (nonatomic, readwrite) NSInteger count;
@property (nonatomic, readwrite, copy) id visualFormats;
@property (nonatomic, readwrite, copy) id itemsProvider;
@property (nonatomic, readwrite, copy) id visualFormatItemProvider;
@property (nonatomic, readwrite, copy) id customGroupItemProvider;
@property (nonatomic, readwrite) NSInteger options;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *identifier;

- (IBPNSCollectionLayoutSize *)effectiveSizeForSize:(IBPNSCollectionLayoutSize *)size
                                           count:(NSInteger)count
                                 layoutDirection:(LayoutDirection)layoutDirection;
- (BOOL)isHorizontalGroup;
- (BOOL)isVerticalGroup;

@end

NS_ASSUME_NONNULL_END
