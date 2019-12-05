#import "SBIconView.h"
#import "SBIconLegibilityLabelView.h"
#import "SBIconLabelImageParameters.h"
#import "SBApplication.h"
//判断手势的全局变量
static CGPoint gestureStartPoint;
//图标的新名字
static NSString * NewIconName;
#define kSettingsFilePath "/var/mobile/Library/Preferences/com.GFGWin.iconrenamer.plist"
%hook SBIconView

%new
//判断手势是向上滑动执行的方法
-(void)handleSwipeFrom
{
	NSString * bundleID = [[self icon] applicationBundleID];
    
    //先获取当前的app简便方法
    // id app1 = [[self icon] application];
	// NSLog(@"gfggfgaaaaa--%@",bundleID);
 //    NSLog(@"gfggfgbbbbb--%@",app1);
	if (bundleID)
	{
		UIViewController *currentVC = [self getCurrentVC];
		//NSLog(@"gfggfgcurrentVC--%@",currentVC);
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:bundleID message:nil preferredStyle: UIAlertControllerStyleActionSheet];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        	
    	}];
		UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"复制BundleID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        	UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
			pastboard.string = bundleID;
    	}];
    	UIAlertAction *ReNameIcon = [UIAlertAction actionWithTitle:@"图标重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    		SBIconLegibilityLabelView * labelView = [self labelView];
    		SBIconLabelImageParameters * Parameters = [labelView imageParameters];
    		NSString *title = [NSString stringWithFormat:@"%@ 图标重命名",Parameters.text];
        	UIAlertController *ReNameAlertVC = [UIAlertController alertControllerWithTitle:title message:@"请输入新的名称" preferredStyle:UIAlertControllerStyleAlert];
        	UIAlertAction* actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        		//NSLog(@"titleOne is pressed--%@",[ReNameAlertVC.textFields firstObject].text);
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
                
                // app1.displayName=@"NewIconName";

                ////先获取当前的app复杂方法，获取所有，然后遍历
                // SBIconController * iconController = [(SBHomeScreenViewController *)currentVC iconController];
                // NSLog(@"gfggfg--SBIconController%@",iconController);
                // NSArray *allApplications  = [iconController allApplications];
                // for (int i = 0; i < allApplications.count; i++)
                // {

                //     SBApplication *app = allApplications[i];
                //     NSLog(@"gfggfg--SBApplication%@",app);
                //     if ([[app bundleIdentifier] isEqualToString:bundleID])
                //     {
                //         NSLog(@"gfggfg--app%@ ---- appname%@",app,[app bundleIdentifier]);
                //         // app.displayName=@"NewIconName";
                        
                //     }

                // }


                // [iconController loadView];
    		}];
            
    		UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        		//NSLog(@"titleThree is pressed");
    		}];
    		[ReNameAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

    		}];
    		[ReNameAlertVC addAction:actionDefault];
    		[ReNameAlertVC addAction:actionCancel];
    		[currentVC presentViewController:ReNameAlertVC animated:YES completion:nil];
    	}];

		[alertController addAction:cancelAction];
		[alertController addAction:archiveAction];
		[alertController addAction:ReNameIcon];
		[currentVC presentViewController:alertController animated:YES completion:nil];
	}
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
    //NSLog(@"gfggfgtouchesEnded");
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPosition = [touch locationInView:[(UIView *)self superview]];
    
    CGFloat deltaX = (gestureStartPoint.x - currentPosition.x);
    
    CGFloat deltaY = gestureStartPoint.y - currentPosition.y;
    
    float MINDISTANCE = sqrt(deltaX * deltaX + deltaY * deltaY)/2;
    //上下滑动
    
    if(fabs(deltaY) > fabs(deltaX))
    {
        //向上滑动
        if (deltaY > MINDISTANCE)   //有效滑动距离 MINDISTANCE
        {
            // NSLog(@"gfggfgtouchesUP");
            [self handleSwipeFrom];
        }
        
        //向下滑动
        // else if (deltaY < -MINDISTANCE)
            
        // {
        //     NSLog(@"gfggfgtouchesDown");
        //     [self handleSwipeFrom];
        // } 
        
    }
    
    //左右滑动
    
    // else if(fabs(deltaX) > fabs(deltaY))
        
    // {
    //     //向左滑动
    //     if (deltaX > MINDISTANCE)
            
    //     {
    //         NSLog(@"gfggfgtouchesleft");
    //     }
    //     //向右滑动
    //     else if (deltaX < -MINDISTANCE)
    //     {
    //         NSLog(@"gfggfgtouchesright");
    //     }
    // }
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

