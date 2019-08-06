#import "IBPNSCollectionLayoutContainer.h"

@interface IBPNSCollectionLayoutContainer()

@property (nonatomic, readwrite) NSDirectionalEdgeInsets contentInsets;
@property (nonatomic, readwrite) CGSize contentSize;

@end

@implementation IBPNSCollectionLayoutContainer

- (id)initWithContentSize:(CGSize)contentSize contentInsets:(NSDirectionalEdgeInsets)contentInsets {
    self = [super init];
    if (self) {
        self.contentSize = contentSize;
        self.contentInsets = contentInsets;
    }
    return self;
}

- (NSDirectionalEdgeInsets)effectiveContentInsets {
    NSDirectionalEdgeInsets effectiveContentInsets = self.contentInsets;
    if (self.contentInsets.top < 1.0) {
        effectiveContentInsets.top = self.contentSize.height * self.contentInsets.top;
    }
    if (self.contentInsets.leading < 1.0) {
        effectiveContentInsets.leading = self.contentSize.width * self.contentInsets.leading;
    }
    if (self.contentInsets.bottom < 1.0) {
        effectiveContentInsets.bottom = self.contentSize.height * self.contentInsets.bottom;
    }
    if (self.contentInsets.trailing < 1.0) {
        effectiveContentInsets.trailing = self.contentSize.width * self.contentInsets.trailing;
    }
    return effectiveContentInsets;
}

- (CGSize)effectiveContentSize {
    CGSize effectiveContentSize = self.contentSize;
    effectiveContentSize.width -= self.effectiveContentInsets.leading + self.effectiveContentInsets.trailing;
    effectiveContentSize.height -= self.effectiveContentInsets.top + self.effectiveContentInsets.bottom;

    return effectiveContentSize;
}

@end
