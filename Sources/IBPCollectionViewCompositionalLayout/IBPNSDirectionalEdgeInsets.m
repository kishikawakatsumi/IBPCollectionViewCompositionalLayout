#import "IBPNSDirectionalEdgeInsets.h"

const IBPNSDirectionalEdgeInsets IBPNSDirectionalEdgeInsetsZero = {0, 0, 0, 0};
NSString *IBPNSStringFromDirectionalEdgeInsets(IBPNSDirectionalEdgeInsets insets) {
    if (@available(iOS 11, *)) {
        return NSStringFromDirectionalEdgeInsets(NSDirectionalEdgeInsetsMake(insets.top, insets.leading, insets.bottom, insets.trailing));
    } else {
        return NSStringFromUIEdgeInsets(UIEdgeInsetsMake(insets.top, insets.leading, insets.bottom, insets.trailing));
    }
}
