#import <UIKit/UIKit.h>

typedef struct IBPNSDirectionalEdgeInsets {
    CGFloat top, leading, bottom, trailing;
} IBPNSDirectionalEdgeInsets;

UIKIT_STATIC_INLINE IBPNSDirectionalEdgeInsets IBPNSDirectionalEdgeInsetsMake(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
    IBPNSDirectionalEdgeInsets insets = {top, leading, bottom, trailing};
    return insets;
}

UIKIT_EXTERN const IBPNSDirectionalEdgeInsets IBPNSDirectionalEdgeInsetsZero;
UIKIT_EXTERN NSString *IBPNSStringFromDirectionalEdgeInsets(IBPNSDirectionalEdgeInsets insets);
