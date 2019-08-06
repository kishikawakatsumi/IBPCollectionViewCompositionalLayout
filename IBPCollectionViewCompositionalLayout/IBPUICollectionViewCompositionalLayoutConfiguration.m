#import "IBPUICollectionViewCompositionalLayoutConfiguration.h"

@implementation IBPUICollectionViewCompositionalLayoutConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.interSectionSpacing = 0;
        self.boundarySupplementaryItems = [[NSArray<IBPNSCollectionLayoutBoundarySupplementaryItem *> alloc] init];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    IBPUICollectionViewCompositionalLayoutConfiguration *configuration = [[IBPUICollectionViewCompositionalLayoutConfiguration allocWithZone:zone] init];
    configuration.scrollDirection = self.scrollDirection;
    configuration.interSectionSpacing = self.interSectionSpacing;
    configuration.boundarySupplementaryItems = self.boundarySupplementaryItems;
    return configuration;
}

@end
