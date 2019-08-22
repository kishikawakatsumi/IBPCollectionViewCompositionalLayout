#import <UIKit/UIKit.h>

@class IBPNSCollectionLayoutSpacing;

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutEdgeSpacing : NSObject<NSCopying>

// Edge spacing specifies additional outsets around items required when performing layout.
//   Edges may be omitted as-needed
//
//    +-----------------+--------+-----------------+------+-----------------+
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    |~~~~~~~~~~~~~~~~~|        |~~~~~~~~~~~~~~~~~|      |~~~~~~~~~~~~~~~~~|
//    +-----------------+        +-----------------+      +-----------------+
//    |                                                                     |
//    |        ^                         ^                          ^       |
//    +--------+-------------------------+--------------------------+-------+
//             |                         |                          |
//             |                         |                          |
//   +---------+-------------------------+--------------------------+--------------------------+
//   |NSCollectionLayoutEdgeSpacing(leading:nil, top: nil, bottom:.flexible(0.0), trailing:nil)|
//   |                                                                                         |
//   |*forces items to align to the top of their group's geometry                              |
//   +-----------------------------------------------------------------------------------------+

+ (instancetype)spacingForLeading:(nullable IBPNSCollectionLayoutSpacing *)leading
                              top:(nullable IBPNSCollectionLayoutSpacing *)top
                         trailing:(nullable IBPNSCollectionLayoutSpacing *)trailing
                           bottom:(nullable IBPNSCollectionLayoutSpacing *)bottom NS_SWIFT_NAME(init(leading:top:trailing:bottom:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *leading;
@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *top;
@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *trailing;
@property (nonatomic, readonly, nullable) IBPNSCollectionLayoutSpacing *bottom;

@end

NS_ASSUME_NONNULL_END
