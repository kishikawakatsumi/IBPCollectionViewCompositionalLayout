#import "IBPNSCollectionLayoutEdgeSpacing.h"

@interface IBPNSCollectionLayoutEdgeSpacing()

@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *leading;
@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *top;
@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *trailing;
@property (nonatomic, readwrite) IBPNSCollectionLayoutSpacing *bottom;

@end

@implementation IBPNSCollectionLayoutEdgeSpacing

+ (instancetype)spacingForLeading:(IBPNSCollectionLayoutSpacing *)leading
                              top:(IBPNSCollectionLayoutSpacing *)top
                         trailing:(IBPNSCollectionLayoutSpacing *)trailing
                           bottom:(IBPNSCollectionLayoutSpacing *)bottom {
    if (@available(iOS 13, *)) {
        return [NSClassFromString(@"NSCollectionLayoutEdgeSpacing") spacingForLeading:leading
                                                                                  top:top
                                                                             trailing:trailing
                                                                               bottom:bottom];
    } else {
        return [[self alloc] initForLeading:leading top:top trailing:trailing bottom:bottom];
    }
}

- (instancetype)initForLeading:(IBPNSCollectionLayoutSpacing *)leading
                           top:(IBPNSCollectionLayoutSpacing *)top
                      trailing:(IBPNSCollectionLayoutSpacing *)trailing
                        bottom:(IBPNSCollectionLayoutSpacing *)bottom {
    self = [super init];
    if (self) {
        self.leading = leading;
        self.top = top;
        self.trailing = trailing;
        self.bottom = bottom;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [IBPNSCollectionLayoutEdgeSpacing spacingForLeading:self.leading top:self.top trailing:self.trailing bottom:self.bottom];
}

@end
