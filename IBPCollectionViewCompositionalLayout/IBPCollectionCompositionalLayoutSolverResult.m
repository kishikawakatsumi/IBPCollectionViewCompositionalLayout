#import "IBPCollectionCompositionalLayoutSolverResult.h"

@implementation IBPCollectionCompositionalLayoutSolverResult

+ (instancetype)resultWithLayoutItem:(IBPNSCollectionLayoutItem *)layoutItem frame:(CGRect)frame {
    return  [[IBPCollectionCompositionalLayoutSolverResult alloc] initWithLayoutItem:layoutItem frame:frame];
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
