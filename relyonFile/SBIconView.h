//生明SBIconView类
#import "SBIcon.h"
@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
-(void)handleSwipeFrom;
- (UIViewController *)getCurrentVC;
-(id)labelView;
-(void)myBadgeNumberOnTheApp:(id)app;
-(void)iconRenameWithBundleID:(NSString *)bundleID onTheApp:(id)app;
-(id)applicationBundleURL;//for ios 13.2.2 and lower
- (id)applicationBundleURLForShortcuts;//for ios 13.2.3
-(void)jumpToApp:(NSString *)path;
-(void)resetPortraitColumns;
@end