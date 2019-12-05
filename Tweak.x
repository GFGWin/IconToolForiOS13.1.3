#import "relyonFile/SBIconView.h"
#import "relyonFile/SBIconLegibilityLabelView.h"
#import "relyonFile/SBIconLabelImageParameters.h"
#import "relyonFile/SBApplication.h"
//判断手势的全局变量
static CGPoint gestureStartPoint;
//图标的新名字
static NSString * NewIconName;

static UIViewController *currentVC;
#define kSettingsFilePath "/var/mobile/Library/Preferences/com.GFGWin.iconrenamer.plist"
%hook SBIconView

%new
//判断手势是向上滑动执行的方法
-(void)handleSwipeFrom
{
	NSString * bundleID = [[self icon] applicationBundleID];
    id app = [[self icon] application];
	if (bundleID)
	{
		currentVC = [self getCurrentVC];
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:bundleID message:nil preferredStyle: UIAlertControllerStyleActionSheet];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        	
    	}];
		UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"复制BundleID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        	UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
			pastboard.string = bundleID;
    	}];
    	UIAlertAction *ReNameIcon = [UIAlertAction actionWithTitle:@"图标重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    		[self iconRenameWithBundleID:bundleID onTheApp:app];
    	}];


        UIAlertAction *setBadgeAction = [UIAlertAction actionWithTitle:@"自定义角标" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self myBadgeNumberOnTheApp:app];
        }];

		[alertController addAction:cancelAction];
		[alertController addAction:archiveAction];
		[alertController addAction:ReNameIcon];
        [alertController addAction:setBadgeAction];
		[currentVC presentViewController:alertController animated:YES completion:nil];
	}
}
%new
-(void)iconRenameWithBundleID:(NSString *)bundleID onTheApp:(id)app
{
    SBIconLegibilityLabelView * labelView = [self labelView];
    SBIconLabelImageParameters * Parameters = [labelView imageParameters];
    NSString *title = [NSString stringWithFormat:@"%@ 图标重命名",Parameters.text];
    UIAlertController *ReNameAlertVC = [UIAlertController alertControllerWithTitle:title message:@"请输入新的名称" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionDefault = [UIAlertAction actionWithTitle:@"更改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存数据
        NewIconName = [ReNameAlertVC.textFields firstObject].text;
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:@kSettingsFilePath];
        if (dic.allKeys>0)
        {
            [dic setObject:NewIconName forKey:bundleID];
            [dic writeToFile:@kSettingsFilePath atomically:YES];
        }else
        {
            NSMutableDictionary * dic1 = [[NSMutableDictionary alloc]init];
            [dic1 setObject:NewIconName forKey:bundleID];
            [dic1 writeToFile:@kSettingsFilePath atomically:YES];
        }
                
        //刷新UI,借用更改角标来刷新UI；
        id str = [app badgeValue];
        [app setBadgeValue:0];
        [app setBadgeValue:str];
    }];

    UIAlertAction* recoverDefault = [UIAlertAction actionWithTitle:@"恢复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:@kSettingsFilePath];
        if (dic.allKeys>0)
        {
            if ([dic.allKeys containsObject:bundleID])
            {
                [dic removeObjectForKey:bundleID];
                [dic writeToFile:@kSettingsFilePath atomically:YES];
            }
        }      
        //刷新UI,借用更改角标来刷新UI；
        id str = [app badgeValue];
        [app setBadgeValue:0];
        [app setBadgeValue:str];
    }]; 

    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ReNameAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

    }];

    [ReNameAlertVC addAction:actionDefault];
    [ReNameAlertVC addAction:recoverDefault];
    [ReNameAlertVC addAction:actionCancel];
    [currentVC presentViewController:ReNameAlertVC animated:YES completion:nil];
}

%new
-(void)myBadgeNumberOnTheApp:(id)app
{
    SBIconLegibilityLabelView * labelView = [self labelView];
    SBIconLabelImageParameters * Parameters = [labelView imageParameters];
    NSString *title = [NSString stringWithFormat:@"%@ 设定角标",Parameters.text];
    UIAlertController *badgeAlertVC = [UIAlertController alertControllerWithTitle:title message:@"请输入新的角标" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id number = [badgeAlertVC.textFields firstObject].text;
        [app setBadgeValue:number];
    }];
            
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [badgeAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

    }];
    [badgeAlertVC addAction:actionDefault];
    [badgeAlertVC addAction:actionCancel];
    [currentVC presentViewController:badgeAlertVC animated:YES completion:nil];
}
%new
//获取当前的VC
- (UIViewController *)getCurrentVC {
    
    UIViewController* result = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        
        if ([result isKindOfClass:[UITabBarController class]]) {
            result = ((UITabBarController*)result).selectedViewController;
        }
        if ([result isKindOfClass:[UINavigationController class]]) {
            result = ((UINavigationController*)result).visibleViewController;
        }
        if (result.presentedViewController) {
            result = result.presentedViewController;
        }else{
            break;
        }
    }
    
    return result;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    %orig;
    UITouch *touch = [touches anyObject];
    gestureStartPoint= [touch locationInView:[(UIView *)self superview]];//开始触摸
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPosition = [touch locationInView:[(UIView *)self superview]];
    
    CGFloat deltaX = (gestureStartPoint.x - currentPosition.x);
    
    CGFloat deltaY = gestureStartPoint.y - currentPosition.y;
    
    float MINDISTANCE = sqrt(deltaX * deltaX + deltaY * deltaY)/2; 
    if(fabs(deltaY) > fabs(deltaX))
    {
        if (deltaY > MINDISTANCE)
        {
            [self handleSwipeFrom];
        }      
    }
}

%end

%hook SBApplication
- (id)displayName{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:@kSettingsFilePath];
    if (dic.allKeys>0)
    {
       for (int i = 0; i < dic.allKeys.count; i++)
       {
           if ([self.bundleIdentifier isEqualToString:dic.allKeys[i]])
           {
               return [dic objectForKey:dic.allKeys[i]];
           }
       }
    }
    return %orig;
}
%end

