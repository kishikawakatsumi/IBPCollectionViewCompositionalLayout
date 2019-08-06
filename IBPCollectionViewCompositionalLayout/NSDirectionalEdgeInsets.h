#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 110000
typedef struct NSDirectionalEdgeInsets {
    CGFloat top, leading, bottom, trailing;
} NSDirectionalEdgeInsets

UIKIT_STATIC_INLINE NSDirectionalEdgeInsets NSDirectionalEdgeInsetsMake(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
    NSDirectionalEdgeInsets insets = {top, leading, bottom, trailing};
    return insets;
}
#endif
