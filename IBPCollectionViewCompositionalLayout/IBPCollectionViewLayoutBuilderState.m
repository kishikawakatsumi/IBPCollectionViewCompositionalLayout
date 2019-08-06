#import "IBPCollectionViewLayoutBuilderState.h"

@implementation IBPCollectionViewLayoutBuilderState

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rootGroupFrame = CGRectZero;
        self.itemResults = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
