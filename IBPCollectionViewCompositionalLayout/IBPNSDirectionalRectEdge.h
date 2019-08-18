#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, IBPNSDirectionalRectEdge) {
    IBPNSDirectionalRectEdgeNone     = 0,
    IBPNSDirectionalRectEdgeTop      = 1 << 0,
    IBPNSDirectionalRectEdgeLeading  = 1 << 1,
    IBPNSDirectionalRectEdgeBottom   = 1 << 2,
    IBPNSDirectionalRectEdgeTrailing = 1 << 3,
    IBPNSDirectionalRectEdgeAll      = IBPNSDirectionalRectEdgeTop | IBPNSDirectionalRectEdgeLeading | IBPNSDirectionalRectEdgeBottom | IBPNSDirectionalRectEdgeTrailing
};
