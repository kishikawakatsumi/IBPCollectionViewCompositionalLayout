#import "IBPCollectionCompositionalLayoutSolverState.h"

@implementation IBPCollectionCompositionalLayoutSolverState

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rootGroupFrame = CGRectZero;
        self.itemResults = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
