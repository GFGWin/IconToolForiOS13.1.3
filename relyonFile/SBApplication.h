@interface SBApplication : NSObject
@property (nonatomic, copy) id badgeValue;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *bundleIdentifier;
@end