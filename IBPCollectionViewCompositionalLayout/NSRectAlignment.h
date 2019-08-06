#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
typedef NS_ENUM(NSInteger, NSRectAlignment) {
    NSRectAlignmentNone = 0,
    NSRectAlignmentTop,
    NSRectAlignmentTopLeading,
    NSRectAlignmentLeading,
    NSRectAlignmentBottomLeading,
    NSRectAlignmentBottom,
    NSRectAlignmentBottomTrailing,
    NSRectAlignmentTrailing,
    NSRectAlignmentTopTrailing,
};
#endif
