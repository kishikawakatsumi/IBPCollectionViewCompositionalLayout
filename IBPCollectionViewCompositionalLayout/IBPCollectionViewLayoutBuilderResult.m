#import "IBPCollectionViewLayoutBuilderResult.h"

@implementation IBPCollectionViewLayoutBuilderResult

+ (instancetype)resultWithLayoutItem:(IBPNSCollectionLayoutItem *)layoutItem frame:(CGRect)frame {
    return  [[IBPCollectionViewLayoutBuilderResult alloc] initWithLayoutItem:layoutItem frame:frame];
}

- (instancetype)initWithLayoutItem:(IBPNSCollectionLayoutItem *)layoutItem frame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.layoutItem = layoutItem;
        self.frame = frame;
    }
    return self;
}

@end
