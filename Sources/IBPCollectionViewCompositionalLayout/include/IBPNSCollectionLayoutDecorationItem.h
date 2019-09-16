#import <UIKit/UIKit.h>
#import "IBPNSDirectionalEdgeInsets.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBPNSCollectionLayoutDecorationItem : NSObject<NSCopying>

// Useful for setting a background decoration view behind a section's content area.
//
// contentInset can also be applied as-needed.
// Register the elementKind with the layout instance to associate with your custom view class/nib
//
//   +----------------------------------+
//   |                                  |
//   |  +----------------------------+  |      +--------------------------------+
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |      |Background Decoration Item      |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~<--+------|* contentInsets applied         |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |      +--------------------------------+
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |      +--------------------------------+
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |<-----|        Section Geometry        |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |      +--------------------------------+
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  |~~~~~~~~~~~~~~~~~~~~~~~~~~~~|  |
//   |  +----------------------------+  |
//   |                                  |
//   +----------------------------------+

+ (instancetype)backgroundDecorationItemWithElementKind:(NSString *)elementKind NS_SWIFT_NAME(background(elementKind:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic) NSInteger zIndex; // default is 0; all other section items will be automatically be promoted to zIndex=1
@property (nonatomic, readonly) NSString *elementKind;
@property (nonatomic) IBPNSDirectionalEdgeInsets contentInsets;

@end

NS_ASSUME_NONNULL_END
