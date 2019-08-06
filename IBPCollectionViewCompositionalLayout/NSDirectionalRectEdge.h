#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
typedef NS_OPTIONS(NSUInteger, NSDirectionalRectEdge) {
    NSDirectionalRectEdgeNone       = 0,
    NSDirectionalRectEdgeTop        = 1 << 0,
    NSDirectionalRectEdgeLeading    = 1 << 1,
    NSDirectionalRectEdgeBottom     = 1 << 2,
    NSDirectionalRectEdgeTrailing   = 1 << 3,
    NSDirectionalRectEdgeAll        = NSDirectionalRectEdgeTop | NSDirectionalRectEdgeLeading | NSDirectionalRectEdgeBottom | NSDirectionalRectEdgeTrailing
};
#endif
