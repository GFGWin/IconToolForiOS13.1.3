//生明SBIconView类
#import "SBIcon.h"
@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
-(void)handleSwipeFrom;
- (UIViewController *)getCurrentVC;
-(id)labelView;
-(void)myBadgeNumberOnTheApp:(id)app;
-(void)iconRenameWithBundleID:(NSString *)bundleID onTheApp:(id)app;
-(id)applicationBundleURL;
-(void)jumpToApp:(NSString *)path;
@end